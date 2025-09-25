//
//  SnapshotTestCaseTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 23.01.25.
//

import SwiftUI
import Testing

@testable import SimpleSnapshotTesting

@MainActor
@Suite(.tags(.acceptanceTest))
struct SnapshotTestCaseTests {

    // MARK: Recording Reference

    @Test
    func whenRecordingReference_itThrowsDidRecordReferenceError() async throws {
        let fileManager = FileManagerDouble()
        let testCase = SnapshotTestCase(isRecordingReference: true,
                                        sourceLocation: SnapshotTestLocation(testFunction: "testFunction",
                                                                             testFilePath: "SnapshotTest/TestCase.swift",
                                                                             testFileID: "SnapshotTest/TestCase.swift",
                                                                             testTag: ""),
                                        precision: 0.0,
                                        fileManager: fileManager)

        #expect(throws: EvaluationError.didRecordReferenceSnapshot) {
            try testCase.evaluate(Rectangle()).get()
        }
    }

    @Test
    func whenRecordingReference_itStoresTheReferenceImageInFileSystem() async throws {
        let fileManager = FileManagerDouble()
        let testCase = SnapshotTestCase(isRecordingReference: true,
                                        sourceLocation: SnapshotTestLocation(testFunction: "testFunction",
                                                                             testFilePath: "SnapshotTest/TestCase.swift",
                                                                             testFileID: "SnapshotTest/TestCase.swift",
                                                                             testTag: ""),
                                        precision: 0.0,
                                        fileManager: fileManager)

        try? testCase.evaluate(RectangleView()).get()

        #expect(fileManager.writtenData.isEmpty == false)
    }

    // MARK: Comparing Snapshot

    @Test
    func whenComparingSnapshot_whenReferenceMatches_itThrowsNoError() async throws {
        let fileManager = FileManagerDouble()
        var testCase = SnapshotTestCase(isRecordingReference: true,
                                        sourceLocation: SnapshotTestLocation(testFunction: "testFunction",
                                                                             testFilePath: "SnapshotTest/TestCase.swift",
                                                                             testFileID: "SnapshotTest/TestCase.swift",
                                                                             testTag: ""),
                                        precision: 0.0,
                                        fileManager: fileManager)
        try? testCase.evaluate(Rectangle()).get()
        fileManager.stubbedFileData = fileManager.writtenData
        testCase.isRecordingReference = false

        #expect(try testCase.evaluate(Rectangle()).get() == ())
    }

    @Test
    func whenComparingSnapshot_whenReferenceNotMatching_itThrowsNotMatchingError() async throws {
        let fileManager = FileManagerDouble()
        var testCase = SnapshotTestCase(isRecordingReference: true,
                                        sourceLocation: SnapshotTestLocation(testFunction: "testFunction",
                                                                             testFilePath: "SnapshotTest/TestCase.swift",
                                                                             testFileID: "SnapshotTest/TestCase.swift",
                                                                             testTag: ""),
                                        precision: 0.0,
                                        fileManager: fileManager)
        try? testCase.evaluate(Rectangle()).get()
        fileManager.stubbedFileData = fileManager.writtenData
        testCase.isRecordingReference = false

        #expect(throws: EvaluationError.snapshotNotMatchingReference) {
            try testCase.evaluate(Text("Hello")).get()
        }
    }

    @Test
    func whenComparingSnapshot_whenReferenceNotExisting_itThrowsReferenceNotFoundError() async throws {
        let fileManager = FileManagerDouble()
        let testCase = SnapshotTestCase(isRecordingReference: false,
                                        sourceLocation: SnapshotTestLocation(testFunction: "testFunction",
                                                                             testFilePath: "SnapshotTest/TestCase.swift",
                                                                             testFileID: "SnapshotTest/TestCase.swift",
                                                                             testTag: ""),
                                        precision: 0.0,
                                        fileManager: fileManager)

        #expect(throws: EvaluationError.noReferenceSnapshotFound) {
            try testCase.evaluate(Text("Hello")).get()
        }
    }

    // TODO: reference does not exist

    @Test
    func should_save_snapshot_diff_artifacts_when_snapshot_not_matching() {
        let pathFactory = makePathFactory(testLocation: makeLocation())
        record(Rectangle())

        withKnownIssue {
            evaluate(Text("Hello"))
        }

        #expect(fileExists(at: pathFactory.failureDiffSnapshotFilePath))
        #expect(fileExists(at: pathFactory.failureFailedSnapshotFilePath))
        #expect(fileExists(at: pathFactory.failureOriginalSnapshotFilePath))

        removeSnapshotFolder()
    }

    // MARK: Testing DSL

    public func record<View: SwiftUI.View>(_ view: View,
                                           function: StaticString = #function,
                                           filePath: StaticString = #filePath,
                                           sourceLocation: SourceLocation = #_sourceLocation) {
        withKnownIssue {
            evaluate(view,
                     record: true,
                     function: function,
                     filePath: filePath,
                     sourceLocation: sourceLocation)
        }
    }

    private func fileExists(at filePath: SnapshotFilePath) -> Bool {
        return FileManager.default.fileExists(atPath: filePath.fullPath)
    }

    private func makeLocation(function: StaticString = #function,
                              filePath: StaticString = #filePath,
                              fileID: StaticString = #fileID) -> SnapshotTestLocation {
        return SnapshotTestLocation(testFunction: function,
                                    testFilePath: filePath,
                                    testFileID: fileID,
                                    testTag: "")
    }

    private func removeSnapshotFolder() {
        let pathFactory = makePathFactory(testLocation: makeLocation())
        let snapshotFolderURL = pathFactory.referenceSnapshotFilePath.directoryURL.deletingLastPathComponent()
        do {
            if FileManager.default.fileExists(atPath: snapshotFolderURL.path()) {
                try FileManager.default.removeItem(at: snapshotFolderURL)
            }
        } catch {
            assertionFailure()
        }
    }

    private func makePathFactory(testLocation: SnapshotTestLocation) -> SnapshotFilePathFactory {
        return SnapshotFilePathFactory(testLocation: testLocation,
                                       deviceScale: DiffImageFactory.defaultImageScale)
    }
}
