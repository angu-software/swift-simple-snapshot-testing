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
        let refFilePath = try createRefImage()
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
    func should_report_match_for_matching_taken_and_reference_snapshot() throws {
        let snapshotManager = makeSnapshotManager(testLocation: .fixture())
        let takenSnap = try snapshotManager.makeSnapshot(view: Rectangle())
        let refFilePath = try setSnapshotAsReference(takenSnap)
        let refSnap = try snapshotManager.makeSnapshot(filePath: refFilePath)

        let result = snapshotManager.compareSnapshot(takenSnap, with: refSnap)

        #expect(result == .matching)
    }

    @Test
    func should_report_no_match_for_not_equal_snapshots() throws {
        let snapshotManager = makeSnapshotManager(testLocation: .fixture())
        let refSnap = try snapshotManager.makeSnapshot(view: Rectangle())
        let takenSnap = try snapshotManager.makeSnapshot(view: Text("Hello"))

        let result = snapshotManager.compareSnapshot(takenSnap, with: refSnap)

        #expect(result == .different)
    }

    // MARK: Failure Snapshots

    @Test
    func should_create_failure_snapshot() async throws {
        let testLocation = SnapshotTestLocation.fixture()
        let path = SnapshotFilePathFactory(testLocation: testLocation)
        let snapshotManager = makeSnapshotManager(testLocation: testLocation)
        let refSnap = try snapshotManager.makeSnapshot(view: Rectangle())
        let takenSnap = try snapshotManager.makeSnapshot(view: Text("Hello"))
        let diffImage = try #require(SnapshotImageRenderer.makeDiffImage(takenSnap.image, refSnap.image))

        let failureSnapshot = snapshotManager.makeFailureSnapshot(taken: takenSnap, reference: refSnap)

        #expect(failureSnapshot.original.imageData == refSnap.imageData)
        #expect(failureSnapshot.original.imageFilePath == path.failureOriginalSnapshotFile)
        #expect(failureSnapshot.failed.imageData == takenSnap.imageData)
        #expect(failureSnapshot.failed.imageFilePath == path.failureFailedSnapshotFile)
        #expect(failureSnapshot.diff.imageData == diffImage.pngData())
        #expect(failureSnapshot.diff.imageFilePath == path.failureDiffSnapshotFile)
    }

    // MARK: Testing DSL

    private func makeSnapshotManager(testLocation: SnapshotTestLocation) -> SnapshotManager {
        return SnapshotManager(testLocation: testLocation,
                               fileManager: fileManager)
    }

    private func setSnapshotAsReference(_ snapshot: Snapshot) throws -> FilePath {
        let imageData = try #require(snapshot.imageData)
        fileManager.stubbedFileData = [snapshot.imageFilePath.stringValue: imageData]
        return snapshot.imageFilePath
    }

    private func createRefImage() throws -> FilePath {
        return try setSnapshotAsReference(Snapshot(image: .dummy(),
                                                   imageFilePath: .dummy()))
    }
}
