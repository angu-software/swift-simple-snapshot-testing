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
struct SimpleSnapshotTests {

    @Test
    func playing_arround() async throws {
        let testLocation = SnapshotTestLocation(testFunction: #function,
                                           testFilePath: #filePath,
                                           testFileID: #fileID,
                                           testTag: "SomeTag")

        let snapshot = try Snapshot(view: Rectangle(),
                                    testLocation: testLocation)
        let manager = SnapshotManager()

        try manager.saveSnapshot(snapshot)

        let snapshotFilePath = SnapshotFilePath(testLocation: testLocation)

        try FileManager.default.removeItem(at: snapshotFilePath.testTargetSnapshotsDir)
    }
}
