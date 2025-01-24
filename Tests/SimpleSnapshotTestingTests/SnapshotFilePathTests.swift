//
//  SnapshotFilePathTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

import Testing

@testable import SimpleSnapshotTesting

struct SnapshotFilePathTests {

    private let moduleName = "SimpleSnapshotTestingTests"
    private let testSourceFileName = "SnapshotFilePathTests"

    @Test
    func should_resolve_test_target_snapshot_dir() {
        let path = SnapshotFilePath(testLocation: .fixture())

        #expect(
            path.testTargetSnapshotsDir.path()
                .hasSuffix("swift-simple-snapshot-testing/Tests/\(moduleName)/__Snapshots__/")
        )
    }

    // testDeviceDir

    @Test
    func should_resolve_test_suite_dir() {
        let path = SnapshotFilePath(testLocation: .fixture())

        #expect(
            path.testSuiteSnapshotsDir.path()
                .hasSuffix("swift-simple-snapshot-testing/Tests/\(moduleName)/__Snapshots__/\(testSourceFileName)/")
        )
    }

    @Test(.tags(.acceptanceTest))
    func should_resolve_test_snapshot_reference_file() {
        let location = SnapshotTestLocation.fixture()
        let testName = location.testIdentifier

        let path = SnapshotFilePath(testLocation: location)

        #expect(
            path.referenceSnapshotFile.path()
                .hasSuffix("swift-simple-snapshot-testing/Tests/\(moduleName)/__Snapshots__/\(testSourceFileName)/\(testName).png")
        )
    }


    @Test
    func should_resolve_failure_diff_original_snapshot_file_path() {
        let location = SnapshotTestLocation.fixture()
        let testName = location.testIdentifier

        let path = SnapshotFilePath(testLocation: location)

        #expect(
            path.failureOriginalSnapshotFile.path()
                .hasSuffix("swift-simple-snapshot-testing/Tests/\(moduleName)/__Snapshots__/FailureDiffs/\(testSourceFileName)/ORIG_\(testName).png")
        )
    }

    @Test
    func should_have_file_name_according_to_test_method_name() async throws {
        let path = SnapshotFilePath(testLocation: .fixture())

        #expect(path.snapshotImageFileName == "should_have_file_name_according_to_test_method_name")
    }

    @Test
    func snapshot_should_append_identifier_to_filename_when_specified() async throws {
        let path = SnapshotFilePath(testLocation: .fixture(testTag: "someIdentifier"))

        #expect(path.snapshotImageFileName == "snapshot_should_append_identifier_to_filename_when_specified_someIdentifier")
    }
}
