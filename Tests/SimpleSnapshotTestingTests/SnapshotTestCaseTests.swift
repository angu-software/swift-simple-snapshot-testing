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

        #expect(throws: EvaluationError.didRecordReference) {
            try testCase.evaluate(Rectangle()).get()
        }
    }

    @Test
    func should_save_reference_image_when_recording_is_set() async throws {
        withKnownIssue() {
            evaluate(Rectangle(), record: true)
        }

        #expect(
            fileExists(at: makePathFactory(testLocation: makeLocation()).referenceSnapshotFilePath)
        )
        
        removeSnapshotFolder()
    }

    @Test
    func should_fail_when_view_snapshot_not_matching_reference() async throws {
        record(Rectangle())

        withKnownIssue {
            evaluate(Text("Hello"))
        } matching: { issue in
            issue.error as? EvaluationError == .notMatchingReference
        }

        removeSnapshotFolder()
    }

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

    @Test()
    func should_pass_test_if_snapshot_matches_reference_image() async throws {
        let view = Rectangle()
        record(view)

        evaluate(view)

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
