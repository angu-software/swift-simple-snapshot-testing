//
//  SnapshotFilePathFactory+TestingPaths.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 31.01.25.
//

@testable import SimpleSnapshotTesting

extension SnapshotFilePathFactory {

    func testFixtureImagePath(for imageName: String) -> FilePath {
        return testTargetSnapshotsDir
            .deletingLastPathComponent()
            .appending(path: "Fixtures",
                       directoryHint: .isDirectory)
            .appending(path: imageName,
                       directoryHint: .notDirectory)
            .appendingPathExtension("png")
    }
}
