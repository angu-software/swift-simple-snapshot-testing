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

    private let fileManager = FileManagerDouble()
    private let snapshot = Snapshot(image: .dummy(),
                                    imageFilePath: .dummy())

    // MARK: Create snapshot from view

    @Test(.tags(.acceptanceTest))
    func should_create_snapshot_from_view() async throws {
        let testLocation = SnapshotTestLocation.fixture()
        let pathFactory = SnapshotFilePathFactory(testLocation: testLocation)
        let manager = makeSnapshotManager(testLocation: testLocation)

        let snapshot = try manager.makeSnapshot(view: Rectangle())

        #expect(snapshot.imageFilePath == pathFactory.referenceSnapshotFile)
    }

   // MARK: Saving snapshot

    @Test
    func should_save_reference_snapshot_as_image_on_file_system() async throws {
        let snapshotManager = makeSnapshotManager(testLocation: .fixture())

        try snapshotManager.saveSnapshot(snapshot)

        #expect(
            fileManager.writtenData == [snapshot.imageFilePath.stringValue: snapshot.imageData]
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
        let brokenSnapshot = Snapshot(image: brokenImage,
                                      imageFilePath: .dummy())
        let snapshotManager = makeSnapshotManager(testLocation: .fixture())

        #expect(throws: SnapshotManager.Error.failedToConvertImageToData, performing: {
            try snapshotManager.saveSnapshot(brokenSnapshot)
        })
    }

    @Test
    func should_create_directory_if_not_existing_before_saving_snapshot() async throws {
        let testLocation = SnapshotTestLocation.fixture()
        let pathFactory = SnapshotFilePathFactory(testLocation: testLocation)
        let snapshotManager = makeSnapshotManager(testLocation: testLocation)

        try snapshotManager.saveSnapshot(snapshot)

        #expect(fileManager.createdDirectories == [pathFactory.testSuiteSnapshotsDir.stringValue])
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

    // MARK: Load snapshot from file

    @Test
    func should_load_snapshot_from_ref_file() async throws {
        let refFilePath = FilePath.dummy()
        fileManager.stubbedFileData = [refFilePath.stringValue: SnapshotImage.dummy().pngData()!]
        let snapshotManager = makeSnapshotManager(testLocation: .fixture())

        let snapshot = try snapshotManager.makeSnapshot(filePath: refFilePath)

        #expect(snapshot.imageFilePath == refFilePath)
    }

    @Test
    func should_fail_loading_snapshot_if_file_does_not_exist() {
        let snapshotManager = makeSnapshotManager(testLocation: .fixture())

        #expect(throws: SnapshotManager.Error.fileDoesNotExist,
                performing: {
            _ = try snapshotManager.makeSnapshot(filePath: .dummy())
        })
    }

    // MARK: Compare snapshots

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
