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
    func snapshot_should_have_file_name_according_to_test_method_name() async throws {
        let snapshot = Snapshot(from: Rectangle())

        #expect(snapshot.fileName == "snapshot_should_have_file_name_according_to_test_method_name")
    }

    @Test
    func snapshot_should_append_identifier_to_filename_when_specified() async throws {
        let snapshot = Snapshot(from: Rectangle(),
                                testTag: "someIdentifier")

        #expect(snapshot.fileName.hasSuffix("_someIdentifier"))
    }

    @Test
    func snapshot_file_path_should_equal_path_of_test_file() async throws {
        let snapshot = Snapshot(from: Rectangle())
        let expectedPath = SnapshotFilePath(test: SnapshotTest())

        #expect(snapshot.filePath == expectedPath)
    }
}
