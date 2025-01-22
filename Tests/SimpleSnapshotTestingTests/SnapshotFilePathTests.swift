//
//  SnapshotFilePathTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

import Testing

@testable import SimpleSnapshotTesting

struct SnapshotFilePathTests {

    @Test
    func should_resolve_test_target_snapshot_dir() {
        let path = SnapshotFilePath(test: SnapshotTest())

        #expect(
            path.testTargetSnapshotsDir.path()
                .hasSuffix("swift-simple-snapshot-testing/Tests/SimpleSnapshotTestingTests/__Snapshots__/")
        )
    }

    // testDeviceDir

    @Test
    func should_resolve_test_suite_dir() {
        let path = SnapshotFilePath(test: SnapshotTest())

        #expect(
            path.testSuiteSnapshotsDir.path()
                .hasSuffix("swift-simple-snapshot-testing/Tests/SimpleSnapshotTestingTests/__Snapshots__/SnapshotFilePathTests/")
        )
    }

    @Test
    func should_resolve_test_snapshot_reference_file() {
        let snapshotTest = SnapshotTest()
        let path = SnapshotFilePath(test: snapshotTest)

        #expect(
            path.testSnapshotsFile.path()
                .hasSuffix("swift-simple-snapshot-testing/Tests/SimpleSnapshotTestingTests/__Snapshots__/SnapshotFilePathTests/\(snapshotTest.id).png")
        )
    }
}
