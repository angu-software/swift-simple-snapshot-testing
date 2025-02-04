//
//  SimpleSnapshotTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 23.01.25.
//

import SwiftUI
import Testing

@testable import SimpleSnapshotTesting

@MainActor
@Suite(.tags(.acceptanceTest))
struct SimpleSnapshotTests {

    @Test
    func should_save_reference_image_when_recording_is_set() async throws {
        _ = evaluate(Rectangle(), record: true)
        
        #expect(
            fileExists(at: SnapshotFilePathFactory(testLocation: makeLocation())
                .referenceSnapshotFilePath)
        )
        
        removeSnapshotFolder()
    }

    @Test
    func should_fail_when_recording_reference_snapshot() {
        let result = evaluate(Rectangle(), record: true)

        #expect(throws: EvaluationError.didRecordReference,
                performing: {
            try result.get()
        })

        removeSnapshotFolder()
    }

    @Test
    func should_fail_when_view_snapshot_not_matching_reference() async throws {
        _ = evaluate(Rectangle(), record: true)

        let result = evaluate(Text("Hello"))

        #expect(throws: EvaluationError.notMatchingReference,
                performing: {
            try result.get()
        })

        removeSnapshotFolder()
    }

    @Test
    func should_save_snapshot_diff_artifacts_when_snapshot_not_matching() {
        let pathFactory = SnapshotFilePathFactory(testLocation: makeLocation())
        _ = evaluate(Rectangle(), record: true)

        _ = evaluate(Text("Hello"))

        #expect(fileExists(at: pathFactory.failureDiffSnapshotFilePath))
        #expect(fileExists(at: pathFactory.failureFailedSnapshotFilePath))
        #expect(fileExists(at: pathFactory.failureOriginalSnapshotFilePath))

        removeSnapshotFolder()
    }

    // MARK: Testing DSL

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
        let pathFactory = SnapshotFilePathFactory(testLocation: SnapshotTestLocation(testFunction: #function,
                                                                                     testFilePath: #filePath,
                                                                                     testFileID: #fileID,
                                                                                     testTag: ""))
        let snapshotFolderURL = pathFactory.referenceSnapshotFilePath.directoryURL.deletingLastPathComponent()
        do {
            if FileManager.default.fileExists(atPath: snapshotFolderURL.path()) {
                try FileManager.default.removeItem(at: snapshotFolderURL)
            }
        } catch {
            assertionFailure()
        }
    }
}

enum EvaluationError: Swift.Error {
    case didRecordReference
    case notMatchingReference
}

@MainActor
func evaluate<View: SwiftUI.View>(_ view: View,
                                  testTag: String = "",
                                  record: Bool = false,
                                  function: StaticString = #function,
                                  filePath: StaticString = #filePath,
                                  fileID: StaticString = #fileID) -> Result<Void, any Error> {
    return evaluate(view,
                    record: record,
                    sourceLocation: SnapshotTestLocation(testFunction: function,
                                                         testFilePath: filePath,
                                                         testFileID: fileID,
                                                         testTag: testTag))
}

@MainActor
func evaluate<View: SwiftUI.View>(_ view: View, record: Bool, sourceLocation: SnapshotTestLocation) -> Result<Void, any Error> {
    let manager = SnapshotManager(testLocation: sourceLocation)

    do {
        let takenSnapshot = try manager.makeSnapshot(view: view)

        if record {
            try manager.saveSnapshot(takenSnapshot)
            throw EvaluationError.didRecordReference
        }

        let referenceSnapshot = try manager.makeSnapshot(filePath: takenSnapshot.filePath)

        switch manager.compareSnapshot(takenSnapshot,
                                       with: referenceSnapshot) {
        case .matching:
            return .success(())
        case .different:
            let failureSnapshot = try manager.makeFailureSnapshot(taken: takenSnapshot,
                                                                  reference: referenceSnapshot)
            try manager.saveFailureSnapshot(failureSnapshot)

            throw EvaluationError.notMatchingReference
        }
    } catch {
        return .failure(error)
    }
}
