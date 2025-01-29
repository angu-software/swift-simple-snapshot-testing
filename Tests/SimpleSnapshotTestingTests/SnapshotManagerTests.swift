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

    init() {
        self.fileManager = FileManagerDouble()
        self.snapshotFilePath = SnapshotFilePath(testLocation: .fixture())
        self.snapshotImage = SnapshotImage.dummy()
        self.snapshot = Snapshot(image: snapshotImage, filePath: snapshotFilePath)
    }

    @Test
    func should_save_reference_snapshot_as_image_on_file_system() async throws {
        let snapshotManager = makeSnapshotManager(testLocation: .fixture())

        try snapshotManager.saveSnapshot(snapshot)

        #expect(
            fileManager.writtenData == [snapshotFilePath.referenceSnapshotFile.path(): SnapshotImage.dummy().pngData()]
        )
    }

    @Test
    func should_throw_error_when_failing_to_save_reference_snapshot() async throws {
        fileManager.shouldThrowWriteFileError = true
        let snapshotManager = makeSnapshotManager(testLocation: .fixture())

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
        let snapshotManager = makeSnapshotManager(testLocation: .fixture())

        #expect(throws: SnapshotManager.Error.failedToConvertImageToData, performing: {
            try snapshotManager.saveSnapshot(brokenSnapshot)
        })
    }

    @Test
    func should_create_directory_if_not_existing_before_saving_snapshot() async throws {
        let snapshotManager = makeSnapshotManager(testLocation: .fixture())

        try snapshotManager.saveSnapshot(snapshot)

        #expect(fileManager.createdDirectories == [snapshotFilePath.testSuiteSnapshotsDir.path()])
    }

    @Test
    func should_throw_error_if_directory_could_not_be_created() async throws {
        fileManager.shouldThrowCreateDirError = true
        let snapshotManager = makeSnapshotManager(testLocation: .fixture())

        #expect(performing: {
            try snapshotManager.saveSnapshot(snapshot)
        }, throws: { _ in
            return true
        })
    }

    @Test
    func should_report_match_for_equal_snapshots() throws {
        let snapshotManager = makeSnapshotManager(testLocation: .fixture())
        let refSnap = try snapshotManager.makeSnapshot(view: Rectangle())
        let takenSnap = try snapshotManager.makeSnapshot(view: Rectangle())

        let result = snapshotManager.compareSnapshot(takenSnap, with: refSnap)

        #expect(result == .matching)
    }

    // MARK: Testing DSL

    private func makeSnapshotManager(testLocation: SnapshotTestLocation) -> SnapshotManager {
        return SnapshotManager(testLocation: testLocation,
                               fileManager: fileManager)
    }
}
