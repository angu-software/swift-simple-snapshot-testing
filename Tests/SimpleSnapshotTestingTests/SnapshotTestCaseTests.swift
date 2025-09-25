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
                                        precision: 1.0,
                                        fileManager: fileManager)
        try? testCase.evaluate(Rectangle()).get()
        fileManager.stubbedFileData = fileManager.writtenData
        testCase.isRecordingReference = false

        #expect(try testCase.evaluate(Rectangle()).get() == ())
    }

    @Test
    func whenComparingSnapshot_whenReferenceMatchesWithinPrecision_itThrowsNoError() async throws {
        let fileManager = FileManagerDouble()
        var testCase = SnapshotTestCase(isRecordingReference: true,
                                        sourceLocation: SnapshotTestLocation(testFunction: "testFunction",
                                                                             testFilePath: "SnapshotTest/TestCase.swift",
                                                                             testFileID: "SnapshotTest/TestCase.swift",
                                                                             testTag: ""),
                                        precision: 0.2,
                                        fileManager: fileManager)
        try? testCase.evaluate(Rectangle().fill(.red)).get()
        fileManager.stubbedFileData = fileManager.writtenData
        testCase.isRecordingReference = false

        #expect(try testCase.evaluate(Rectangle().fill(.green)).get() == ())
    }

    @Test
    func whenComparingSnapshot_whenReferenceNotMatching_itThrowsNotMatchingError() async throws {
        let fileManager = FileManagerDouble()
        var testCase = SnapshotTestCase(isRecordingReference: true,
                                        sourceLocation: SnapshotTestLocation(testFunction: "testFunction",
                                                                             testFilePath: "SnapshotTest/TestCase.swift",
                                                                             testFileID: "SnapshotTest/TestCase.swift",
                                                                             testTag: ""),
                                        precision: 1.0,
                                        fileManager: fileManager)
        try? testCase.evaluate(Rectangle().fill(.red)).get()
        fileManager.stubbedFileData = fileManager.writtenData
        testCase.isRecordingReference = false

        #expect(throws: EvaluationError.snapshotNotMatchingReference) {
            try testCase.evaluate(Rectangle().fill(.green)).get()
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
                                        precision: 1.0,
                                        fileManager: fileManager)

        #expect(throws: EvaluationError.noReferenceSnapshotFound) {
            try testCase.evaluate(Text("Hello")).get()
        }
    }

    @Test
    func whenComparingSnapshot_whenSnapshotNotMatchingReference_itStoresAFailureDiffReport() async throws {
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

        try? testCase.evaluate(Text("Hello")).get()


        #expect(fileManager.writtenData.keys.contains(where: { $0.contains(#/FailureDiffs.*ORIG.*\.png/#) }))
        #expect(fileManager.writtenData.keys.contains(where: { $0.contains(#/FailureDiffs.*FAIL.*\.png/#) }))
        #expect(fileManager.writtenData.keys.contains(where: { $0.contains(#/FailureDiffs.*DIFF.*\.png/#) }))
    }
}
