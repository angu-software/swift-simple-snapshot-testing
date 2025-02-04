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

        evaluate(Rectangle(),
                 record: true,
                 sourceLocation: testLocation)

        #expect(fileExists(at: pathFactory.referenceSnapshotFilePath))

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

@MainActor
func evaluate<View: SwiftUI.View>(_ view: View, record: Bool, sourceLocation: SnapshotTestLocation) {
    let manager = SnapshotManager(testLocation: sourceLocation)
    do {
        let snapshot = try manager.makeSnapshot(view: view)

        try manager.saveSnapshot(snapshot)
    } catch {
        assertionFailure("")
    }
}
