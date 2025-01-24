//
//  SnapshotFilePath.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

import UniformTypeIdentifiers

struct SnapshotFilePath: Equatable {

    private let testSourceFile: FilePath
    private let fileExtension = UTType.png
    private let rootFolderName = "__Snapshots__"

    private let testLocation: SnapshotTestLocation

    var snapshotImageFileName: String {
        return testLocation.testIdentifier
    }

    private var diffOriginalImageFileName: String {
        return "ORIG_\(snapshotImageFileName)"
    }

    var testTargetSnapshotsDir: FilePath {
        return testTargetDir
            .appending(component: rootFolderName,
                       directoryHint: .isDirectory)
    }

    var testSuiteSnapshotsDir: FilePath {
        return testTargetSnapshotsDir
            .appending(component: testSourceFileName,
                       directoryHint: .isDirectory)
    }

    var referenceSnapshotFile: FilePath {
        return testSuiteSnapshotsDir
            .appending(component: snapshotImageFileName)
            .appendingPathExtension(for: fileExtension)
    }

    var failureDiffsDir: FilePath {
        return testTargetSnapshotsDir
            .appending(component: "FailureDiffs",
                       directoryHint: .isDirectory)
    }

    var testSuiteFailureDiffsDir: FilePath {
        return failureDiffsDir
            .appending(component: testSourceFileName,
                       directoryHint: .isDirectory)
    }

    var failureOriginalSnapshotFile: FilePath {
        return testSuiteFailureDiffsDir
            .appending(component: diffOriginalImageFileName)
            .appendingPathExtension(for: fileExtension)
    }

    var testTargetDir: FilePath {
        return testSourceFile
            .deletingLastPathComponent()
    }

    var testTargetName: String {
        return testTargetDir.lastPathComponent
    }

    var testSourceFileName: String {
        return testSourceFile.deletingPathExtension().lastPathComponent
    }

    init(testLocation: SnapshotTestLocation) {
        self.testLocation = testLocation
        self.testSourceFile = FilePath("\(testLocation.testFilePath)")
    }
}
