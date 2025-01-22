//
//  SnapshotFilePathTest.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

import Testing

@testable import SimpleSnapshotTesting

struct SnapshotFilePathTest {

    @Test
    func should_resolve_snapshot_base_path() async throws {
        let path = SnapshotFilePath(test: SnapshotTest())

        var expectedPath = FilePath(filePath: "\(#filePath)")
        expectedPath.removeLastSegment()
        expectedPath.addSegment("__Snapshots__")

        #expect(path.basePath == expectedPath)
    }
}
