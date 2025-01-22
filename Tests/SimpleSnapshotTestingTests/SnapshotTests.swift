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

@MainActor
@Suite(.tags(.acceptanceTest))
struct SnapshotTests {

    @Test
    func snapshot_should_render_an_image_of_the_evaluated_view() async throws {
        let snapshot = Snapshot(from: Rectangle())

        #expect(snapshot.image != nil)
    }

    @Test
    func snapshot_file_path_should_equal_path_of_test_file() async throws {
        let snapshot = Snapshot(from: Rectangle())
        let expectedPath = SnapshotFilePath(testLocation: .fixture())

        #expect(snapshot.filePath == expectedPath)
    }
}
