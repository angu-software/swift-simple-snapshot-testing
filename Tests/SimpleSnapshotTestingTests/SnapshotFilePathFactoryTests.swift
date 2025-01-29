//
//  SnapshotFilePathFactoryTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

import Testing

@testable import SimpleSnapshotTesting

struct SnapshotFilePathFactoryTests {

    private let moduleName = "SimpleSnapshotTestingTests"
    private let testSourceFileName = "SnapshotFilePathFactoryTests"

    @Test
    func should_resolve_test_target_snapshot_dir() {
        let path = SnapshotFilePathFactory(testLocation: .fixture())

        #expect(
            path.testTargetSnapshotsDir.stringValue
                .hasSuffix("swift-simple-snapshot-testing/Tests/\(moduleName)/__Snapshots__/")
        )
    }

    // testDeviceDir

    @Test
    func should_resolve_test_suite_dir() {
        let path = SnapshotFilePathFactory(testLocation: .fixture())

        #expect(
            path.testSuiteSnapshotsDir.stringValue
                .hasSuffix("swift-simple-snapshot-testing/Tests/\(moduleName)/__Snapshots__/\(testSourceFileName)/")
        )
    }

    @Test(.tags(.acceptanceTest))
    func should_resolve_test_snapshot_reference_file() {
        let location = SnapshotTestLocation.fixture()
        let testName = location.testIdentifier

        let path = SnapshotFilePathFactory(testLocation: location)

        #expect(
            path.referenceSnapshotFile.stringValue
                .hasSuffix("swift-simple-snapshot-testing/Tests/\(moduleName)/__Snapshots__/\(testSourceFileName)/\(testName).png")
        )
    }


    @Test
    func should_resolve_failure_diff_original_snapshot_file_path() {
        let location = SnapshotTestLocation.fixture()
        let testName = location.testIdentifier

        let path = SnapshotFilePathFactory(testLocation: location)

        #expect(
            path.failureOriginalSnapshotFile.stringValue
                .hasSuffix("swift-simple-snapshot-testing/Tests/\(moduleName)/__Snapshots__/FailureDiffs/\(testSourceFileName)/ORIG_\(testName).png")
        )
    }

    @Test
    func should_resolve_failure_diff_failing_snapshot_file_path() {
        let location = SnapshotTestLocation.fixture()
        let testName = location.testIdentifier

        let path = SnapshotFilePathFactory(testLocation: location)

        #expect(
            path.failureFailingSnapshotFile.stringValue
                .hasSuffix("swift-simple-snapshot-testing/Tests/\(moduleName)/__Snapshots__/FailureDiffs/\(testSourceFileName)/FAIL_\(testName).png")
        )
    }

    @Test
    func should_resolve_failure_diff_diffed_snapshot_file_path() {
        let location = SnapshotTestLocation.fixture()
        let testName = location.testIdentifier

        let path = SnapshotFilePathFactory(testLocation: location)

        #expect(
            path.failureDiffSnapshotFile.stringValue
                .hasSuffix("swift-simple-snapshot-testing/Tests/\(moduleName)/__Snapshots__/FailureDiffs/\(testSourceFileName)/DIFF_\(testName).png")
        )
    }

    @Test
    func should_have_file_name_according_to_test_method_name() async throws {
        let path = SnapshotFilePathFactory(testLocation: .fixture())

        #expect(path.snapshotImageFileName == "should_have_file_name_according_to_test_method_name")
    }

    @Test
    func snapshot_should_append_identifier_to_filename_when_specified() async throws {
        let path = SnapshotFilePathFactory(testLocation: .fixture(testTag: "someIdentifier"))

        #expect(path.snapshotImageFileName == "snapshot_should_append_identifier_to_filename_when_specified_someIdentifier")
    }
}
