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
        let path = SnapshotFilePath(testLocation: .fixture())

        #expect(
            path.testTargetSnapshotsDir.path()
                .hasSuffix("swift-simple-snapshot-testing/Tests/SimpleSnapshotTestingTests/__Snapshots__/")
        )
    }

    // testDeviceDir

    @Test
    func should_resolve_test_suite_dir() {
        let path = SnapshotFilePath(testLocation: .fixture())

        #expect(
            path.testSuiteSnapshotsDir.path()
                .hasSuffix("swift-simple-snapshot-testing/Tests/SimpleSnapshotTestingTests/__Snapshots__/SnapshotFilePathTests/")
        )
    }

    @Test(.tags(.acceptanceTest))
    func should_resolve_test_snapshot_reference_file() {
        let location = SnapshotTestLocation.fixture()
        let path = SnapshotFilePath(testLocation: location)

        let moduleName = location.moduleName
        let fileName = location.fileName
            .replacingOccurrences(of: ".swift",
                                  with: "")
        let testName = location.testIdentifier

        #expect(
            path.testSnapshotsFile.path()
                .hasSuffix("swift-simple-snapshot-testing/Tests/\(moduleName)/__Snapshots__/\(fileName)/\(testName).png")
        )
    }
}
