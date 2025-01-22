//
//  SnapshotTestLocationTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

import Testing

@testable import SimpleSnapshotTesting

struct SnapshotTestLocationTests {

    @Test
    func should_resolve_module_name() async throws {
        let snapshotTest = SnapshotTestLocation.fixture()

        #expect(snapshotTest.moduleName == "SimpleSnapshotTestingTests")
    }

    @Test
    func should_resolve_test_file_name() async throws {
        let snapshotTest = SnapshotTestLocation.fixture()

        #expect(snapshotTest.fileName == "SnapshotTestLocationTests.swift")
    }
}
