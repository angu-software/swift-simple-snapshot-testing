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
        let pathFactory = SnapshotFilePathFactory(testLocation: testLocation)

        let manager = SnapshotManager(testLocation: testLocation)
        let snapshot = try manager.makeSnapshot(view: Rectangle(),
                                                testLocation: testLocation)

        try manager.saveSnapshot(snapshot)

        try FileManager.default.removeItem(at: pathFactory.testTargetSnapshotsDir)
    }
}
