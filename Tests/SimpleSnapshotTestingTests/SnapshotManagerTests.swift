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
    private let testLocation: SnapshotTestLocation
    private let pathFactory: SnapshotFilePathFactory
    private let manager: SnapshotManager

    init() {
        self.testLocation = SnapshotTestLocation.fixture(testFunction: "some_test_function()")
        self.pathFactory = SnapshotFilePathFactory(testLocation: testLocation)
        self.manager = SnapshotManager(testLocation: testLocation,
                                       fileManager: fileManager)
    }

    // MARK: Create snapshot from view

    @Test(.tags(.acceptanceTest))
    func should_create_snapshot_from_view() async throws {
        let snapshot = try manager.makeSnapshot(view: Rectangle())

        #expect(snapshot.filePath == pathFactory.referenceSnapshotFilePath)
    }

    // MARK: Saving snapshot

    @Test
    func should_save_reference_snapshot_as_image_on_file_system() async throws {
        let snapshot = Snapshot.dummy

        try manager.saveSnapshot(snapshot)

        #expect(
            fileManager.writtenData == [snapshot.filePath.fullPath: snapshot.imageData]
        )
    }

    @Test
    func should_throw_error_when_failing_to_save_reference_snapshot() async throws {
        fileManager.shouldThrowWriteFileError = true

        #expect(performing: {
            try manager.saveSnapshot(.dummy)
        }, throws: { _ in
            return true
        })
    }

    @Test
    func should_throw_error_when_image_conversion_to_data_fails() async throws {
        let brokenImage = SnapshotImageData.fixture(size: .zero)
        let brokenSnapshot = Snapshot.fixture(imageData: brokenImage)

        #expect(throws: SnapshotManager.Error.malformedSnapshotImage, performing: {
            try manager.saveSnapshot(brokenSnapshot)
        })
    }

    @Test
    func should_create_directory_if_not_existing_before_saving_snapshot() async throws {
        let snapshot = Snapshot.fixture(imageFilePath: pathFactory.referenceSnapshotFilePath)
        try manager.saveSnapshot(snapshot)

        #expect(fileManager.createdDirectories == [snapshot.filePath.directoryPath])
    }

    @Test
    func should_throw_error_if_directory_could_not_be_created() async throws {
        fileManager.shouldThrowCreateDirError = true

        #expect(performing: {
            try manager.saveSnapshot(.dummy)
        }, throws: { _ in
            return true
        })
    }

    // MARK: Load snapshot from file

    @Test
    func should_load_snapshot_from_ref_file() async throws {
        let refFilePath = createRefImage()

        let snapshot = try manager.makeSnapshot(filePath: refFilePath)

        #expect(snapshot.filePath == refFilePath)
    }

    @Test
    func should_fail_loading_snapshot_if_file_does_not_exist() {
        #expect(throws: SnapshotManager.Error.fileDoesNotExist,
                performing: {
            _ = try manager.makeSnapshot(filePath: .dummy())
        })
    }

    // MARK: Compare snapshots

    @Test
    func should_report_match_for_matching_taken_and_reference_snapshot() throws {
        let result = manager.compareSnapshot(.fixture(),
                                             with: .fixture())

        #expect(result == .matching)
    }

    @Test
    func should_report_no_match_for_not_equal_snapshots() throws {
        let result = manager.compareSnapshot(.fixture(),
                                             with: .fixture(imageData: .fixture(color: .blue)))

        #expect(result == .different)
    }

    // MARK: Failure Snapshots

    @Test
    func should_create_failure_snapshot() async throws {
        let refSnap = Snapshot.fixture()
        let takenSnap = Snapshot.fixture(imageData: .fixture(color: .blue))
        let takenImage = try #require(takenSnap.image)
        let refImage = try #require(refSnap.image)
        let diffImage = try #require(SnapshotImageRenderer.makeDiffImage(takenImage, refImage))

        let orignialSnap = refSnap.with(filePath: pathFactory.failureOriginalSnapshotFilePath)
        let failedSnap = takenSnap.with(filePath: pathFactory.failureFailedSnapshotFilePath)
        let diffSnap = Snapshot(image: diffImage,
                                imageFilePath: pathFactory.failureDiffSnapshotFilePath)

        let failureSnapshot = try manager.makeFailureSnapshot(taken: takenSnap, reference: refSnap)

        #expect(failureSnapshot.original == orignialSnap)
        #expect(failureSnapshot.failed == failedSnap)
        #expect(failureSnapshot.diff == diffSnap)
    }

    @Test
    func should_create_diff_dir_when_saving_failing_snapshot_artifacts() throws {
        let failureSnap = FailureSnapshot(original: .fixture(imageFilePath: pathFactory.failureOriginalSnapshotFilePath),
                                          failed: .fixture(imageFilePath: pathFactory.failureFailedSnapshotFilePath),
                                          diff: .fixture(imageFilePath: pathFactory.failureDiffSnapshotFilePath))

        try manager.saveFailureSnapshot(failureSnap)

        #expect(fileManager.createdDirectories == [pathFactory.failureDiffSnapshotFilePath.directoryPath])
    }

    @Test
    func should_save_failure_diff_artifacts_on_filesystem() throws {
        let original = Snapshot.fixture(imageFilePath: pathFactory.failureOriginalSnapshotFilePath)
        let failed = Snapshot.fixture(imageFilePath: pathFactory.failureFailedSnapshotFilePath)
        let diff = Snapshot.fixture(imageFilePath: pathFactory.failureDiffSnapshotFilePath)
        let failureSnap = FailureSnapshot(original: original,
                                          failed: failed,
                                          diff: diff)

        try manager.saveFailureSnapshot(failureSnap)

        #expect(fileManager.writtenData == [original.filePath.fullPath: original.imageData,
                                            failed.filePath.fullPath: failed.imageData,
                                            diff.filePath.fullPath: diff.imageData])
    }

    // MARK: Testing DSL

    private func makeSnapshotManager(testLocation: SnapshotTestLocation) -> SnapshotManager {
        return SnapshotManager(testLocation: testLocation,
                               fileManager: fileManager)
    }

    private func setSnapshotAsReference(_ snapshot: Snapshot) -> SnapshotFilePath {
        fileManager.stubbedFileData = [snapshot.filePath.fullPath: snapshot.imageData]
        return snapshot.filePath
    }

    private func createRefImage() -> SnapshotFilePath {
        return setSnapshotAsReference(.fixture())
    }
}
