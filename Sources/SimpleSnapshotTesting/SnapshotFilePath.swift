//
//  SnapshotFilePath.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

import UniformTypeIdentifiers

struct SnapshotFilePath: Equatable {

    var fileName: String {
        return testLocation.id
    }

    private let testSourceFile: FilePath
    private let fileExtension = UTType.png
    private let rootFolderName = "__Snapshots__"

    private let testLocation: SnapshotTestLocation

    var testTargetSnapshotsDir: FilePath {
        return testTargetDir
            .appending(component: rootFolderName,
                       directoryHint: .isDirectory)
    }

    var testSuiteSnapshotsDir: FilePath {
        testTargetSnapshotsDir
            .appending(component: testSourceFileName,
                       directoryHint: .isDirectory)
    }

    var testSnapshotsFile: FilePath {
        return testSuiteSnapshotsDir
            .appending(component: fileName)
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
