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
        let testLocation = SnapshotTestLocation(testFunction: #function,
                                                testFilePath: #filePath,
                                                testFileID: #fileID)
        let pathFactory = SnapshotFilePathFactory(testLocation: testLocation)

        _ = evaluate(Rectangle(),
                 record: true,
                 sourceLocation: testLocation)

        #expect(fileExists(at: pathFactory.referenceSnapshotFilePath))

        removeSnapshotFolder()
    }

    @Test
    func should_fail_when_recording_reference_snapshot() {
        let testLocation = SnapshotTestLocation(testFunction: #function,
                                                testFilePath: #filePath,
                                                testFileID: #fileID)
        let result = evaluate(Rectangle(),
                              record: true,
                              sourceLocation: testLocation)

        #expect(throws: EvaluationError.didRecordReference,
                performing: {
            try result.get()
        })

        removeSnapshotFolder()
    }

    // MARK: Testing DSL

    private func fileExists(at filePath: SnapshotFilePath) -> Bool {
        return FileManager.default.fileExists(atPath: filePath.fullPath)
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
}

@MainActor
func evaluate<View: SwiftUI.View>(_ view: View, record: Bool, sourceLocation: SnapshotTestLocation) -> Result<Void, any Error> {
    let manager = SnapshotManager(testLocation: sourceLocation)

    do {
        let snapshot = try manager.makeSnapshot(view: view)

        if record {
            try manager.saveSnapshot(snapshot)
            throw EvaluationError.didRecordReference
        }

        return .success(())
    } catch {
        return .failure(error)
    }
}
