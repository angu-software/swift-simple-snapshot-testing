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

    private let fileManager = FileManagerDouble()

    // MARK: Recording Reference

    @Test
    func whenRecordingReference_itThrowsDidRecordReferenceError() async throws {
        let testCase = makeTestCase(isRecordingReference: true,
                                    precision: 0.0)

        #expect(throws: EvaluationError.didRecordReferenceSnapshot) {
            try testCase.evaluate(Rectangle()).get()
        }
    }

    @Test
    func whenRecordingReference_itStoresTheReferenceImageInFileSystem() async throws {
        let testCase = makeTestCase(isRecordingReference: true,
                                    precision: 0.0)

        try? testCase.evaluate(RectangleView()).get()

        #expect(fileManager.writtenData.isEmpty == false)
    }

    @Test
    func whenRecordingReference_itRecordsWithTheCurrentDeviceScreenScale() async throws {
        let currentScreenScale = Int(UIScreen.main.scale)
        let testCase = makeTestCase(isRecordingReference: true,
                                    precision: 0.0)

        try? testCase.evaluate(RectangleView()).get()

        #expect(fileManager.writtenData.keys.allSatisfy({ $0.contains("@\(currentScreenScale)x.png")}))
    }

    @Test
    func whenRecordingReference_withCustomRecordingScale_itRecordsWithSpecifiedSalce() async throws {
        let testCase = makeTestCase(isRecordingReference: true,
                                    precision: 0.0,
                                    recordingScale: 2)

        try? testCase.evaluate(RectangleView()).get()

        #expect(fileManager.writtenData.keys.allSatisfy({ $0.contains("@2x.png")}))
    }

    @Test
    func whenGloballySettingRecordMode_itRecordsReference() {
        SnapshotGlobalConfig.enableReferenceRecoding()

        let testCase = makeTestCase(isRecordingReference: false, precision: 0.0)

        try? testCase.evaluate(RectangleView()).get()

        #expect(fileManager.writtenData.isEmpty == false)

        SnapshotGlobalConfig.disableReferenceRecoding()
    }

    // MARK: Comparing Snapshot

    @Test
    func whenComparingSnapshot_whenReferenceMatches_itThrowsNoError() async throws {
        setReferenceSnapshot(Rectangle())
        let testCase = makeTestCase(precision: 1.0)

        #expect(try testCase.evaluate(Rectangle()).get() == ())
    }

    @Test
    func whenComparingSnapshot_whenReferenceMatchesWithinPrecision_itThrowsNoError() async throws {
        setReferenceSnapshot(Rectangle().fill(.red))
        let testCase = makeTestCase(precision: 0.2)

        #expect(try testCase.evaluate(Rectangle().fill(.green)).get() == ())
    }

    @Test
    func whenComparingSnapshot_whenReferenceNotMatching_itThrowsNotMatchingError() async throws {
        setReferenceSnapshot(Rectangle().fill(.red))
        let testCase = makeTestCase(precision: 1.0)

        #expect(throws: EvaluationError.snapshotNotMatchingReference) {
            try testCase.evaluate(Rectangle().fill(.green)).get()
        }
    }

    @Test
    func whenComparingSnapshot_whenReferenceNotExisting_itThrowsReferenceNotFoundError() async throws {
        let testCase = makeTestCase(precision: 1.0)

        #expect(throws: EvaluationError.noReferenceSnapshotFound) {
            try testCase.evaluate(Text("Hello")).get()
        }
    }

    @Test
    func whenComparingSnapshot_whenSnapshotNotMatchingReference_itStoresAFailureDiffReport() async throws {
        setReferenceSnapshot(Rectangle())
        let testCase = makeTestCase(precision: 0.0)

        try? testCase.evaluate(Text("Hello")).get()

        #expect(fileManager.writtenData.keys.contains(where: { $0.contains(#/FailureDiffs.*ORIG.*\.png/#) }))
        #expect(fileManager.writtenData.keys.contains(where: { $0.contains(#/FailureDiffs.*FAIL.*\.png/#) }))
        #expect(fileManager.writtenData.keys.contains(where: { $0.contains(#/FailureDiffs.*DIFF.*\.png/#) }))
    }

    @Test
    func whenComparingSnapshot_whenSnapshotNotMatchingReference_withSpecifiedRecordingScale_itRecordsDiffReportImagesInRecordingScale() async throws {
        setReferenceSnapshot(Rectangle())
        let testCase = makeTestCase(precision: 0.0)

        try? testCase.evaluate(Text("Hello")).get()

        #expect(fileManager.writtenData.keys.contains(where: { $0.contains(#/FailureDiffs.*ORIG.*\@3x.png/#)}))
        #expect(fileManager.writtenData.keys.contains(where: { $0.contains(#/FailureDiffs.*FAIL.*\@3x.png/#)}))
        #expect(fileManager.writtenData.keys.contains(where: { $0.contains(#/FailureDiffs.*DIFF.*\@3x.png/#)}))
    }

    private func makeTestCase(isRecordingReference: Bool = false, precision: Double, recordingScale: CGFloat? = nil) -> SnapshotTestCase {
        return SnapshotTestCase(isRecordingReference: isRecordingReference,
                                recordingScale: recordingScale ?? SnapshotTestCase.defaultRecordingScale,
                                matchingPrecision: precision,
                                sourceLocation: SnapshotTestLocation(testFunction: "testFunction",
                                                                     testFilePath: "SnapshotTest/TestCase.swift",
                                                                     testFileID: "SnapshotTest/TestCase.swift",
                                                                     testTag: ""),
                                fileManager: fileManager)
    }

    private func setReferenceSnapshot<View: SwiftUI.View>(_ view: View, recordingScale: CGFloat? = nil) {
        let testCase = makeTestCase(isRecordingReference: true, precision: 0.0, recordingScale: recordingScale)

        _ = testCase.evaluate(view)

        fileManager.stubbedFileData = fileManager.writtenData
    }
}
