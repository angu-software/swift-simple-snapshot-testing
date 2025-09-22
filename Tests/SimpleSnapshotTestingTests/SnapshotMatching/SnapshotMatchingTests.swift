//
//  SnapshotMatchingTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import Testing

@testable import SimpleSnapshotTesting

struct SnapshotMatchingTests {

    @Test
    func whenSnapshotsMatching_itReturnsTrue() async throws {
        let snapshot1 = Snapshot(pngData: .fixture(),
                                 scale: 1,
                                 filePath: .dummy())

        #expect(snapshot1.matches(snapshot1, precision: 1.0))
    }
}
