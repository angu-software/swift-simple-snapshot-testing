//
//  SnapshotTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 30.12.24.
//

import Foundation
import SwiftUI

import Testing


@testable import SimpleSnapshotTesting

// TODO: Move to Manager tests

@MainActor
@Suite(.tags(.acceptanceTest))
struct SnapshotTests {

    @Test
    func snapshot_file_path_should_equal_path_of_test_file() async throws {
        let location = SnapshotTestLocation.fixture()
        let manager = SnapshotManager(testLocation: location)

        let snapshot = try manager.makeSnapshot(view: Rectangle(),
                                                testLocation: location)

        #expect(snapshot.imageFilePath == SnapshotFilePathFactory(testLocation: location).referenceSnapshotFile)
    }
}
