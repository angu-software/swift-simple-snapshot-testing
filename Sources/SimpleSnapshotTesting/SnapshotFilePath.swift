//
//  SnapshotFilePath.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

import UniformTypeIdentifiers

struct SnapshotFilePath: Equatable {

    let fileName: String
    private let testSourceFile: FilePath
    private let fileExtension = UTType.png
    private let rootFolderName = "__Snapshots__"

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

    init(test: SnapshotTestLocation) {
        self.fileName = test.id
        self.testSourceFile = FilePath("\(test.testFilePath)")
    }
}
