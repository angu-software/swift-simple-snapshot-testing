//
//  SnapshotManagerTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 23.01.25.
//

import SwiftUI

import Testing

@testable import SimpleSnapshotTesting

@MainActor
struct SnapshotManagerTests {

    private let fileManager: FileManagerDouble
    private let snapshotFilePath: SnapshotFilePath
    private let snapshotImage: SnapshotImage
    private let snapshot: Snapshot

    private let snapshotManager: SnapshotManager

    init() {
        self.fileManager = FileManagerDouble()
        self.snapshotFilePath = SnapshotFilePath(testLocation: .fixture())
        self.snapshotImage = SnapshotImage.dummy()
        self.snapshot = Snapshot(image: snapshotImage, filePath: snapshotFilePath)
        self.snapshotManager = SnapshotManager(fileManager: fileManager)
    }

    @Test
    func should_save_reference_snapshot_as_image_on_file_system() async throws {
        try snapshotManager.saveSnapshot(snapshot)

        #expect(
            fileManager.writtenData == [snapshotFilePath.snapshotFilePath.path(): SnapshotImage.dummy().pngData()]
        )
    }

    @Test
    func should_throw_error_when_failing_to_save_reference_snapshot() async throws {
        fileManager.shouldThrowError = true

        #expect(performing: {
            try snapshotManager.saveSnapshot(snapshot)
        }, throws: { _ in
            return true
        })
    }

    @Test
    func should_throw_error_when_image_conversion_to_data_fails() async throws {
        let brokenImage = SnapshotImage.fixture(size: .zero)
        let brokenSnapshot = Snapshot(image: brokenImage, filePath: snapshotFilePath)

        #expect(throws: SnapshotManager.Error.failedToConvertImageToData, performing: {
            try snapshotManager.saveSnapshot(brokenSnapshot)
        })
    }

    @Test
    func should_create_directory_if_not_existing_before_saving_snapshot() async throws {
        try snapshotManager.saveSnapshot(snapshot)

        #expect(fileManager.createdDirectories == [snapshotFilePath.testSuiteSnapshotsDir.path()])
    }
}
