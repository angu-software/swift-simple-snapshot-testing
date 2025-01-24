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
    private let snapshotsRootFolderName = "__Snapshots__"
    private let failureDiffsRootFolderName = "FailureDiffs"

    private let testLocation: SnapshotTestLocation

    var snapshotImageFileName: String {
        return testLocation.testIdentifier
    }

    private var diffOriginalImageFileName: String {
        return "ORIG_\(snapshotImageFileName)"
    }

    var testTargetSnapshotsDir: FilePath {
        return makeDirPath(basePath: testTargetDir,
                           snapshotsRootFolderName)
    }

    var testTargetFailureDiffsDir: FilePath {
        return makeDirPath(basePath: testTargetSnapshotsDir,
                           failureDiffsRootFolderName)
    }

    var testSuiteSnapshotsDir: FilePath {
        return makeDirPath(basePath: testTargetSnapshotsDir,
                           testSourceFileName)
    }

    var testSuiteFailureDiffsDir: FilePath {
        return makeDirPath(basePath: testTargetFailureDiffsDir,
                           testSourceFileName)
    }

    var referenceSnapshotFile: FilePath {
        return appendFile(named: snapshotImageFileName,
                          on: testSuiteSnapshotsDir)
    }

    var failureOriginalSnapshotFile: FilePath {
        return appendFile(named: diffOriginalImageFileName,
                          on: testSuiteFailureDiffsDir)
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

    private func makeDirPath(basePath: FilePath, _ subPathSegments: String...) -> FilePath {
        var path = basePath
        for segment in subPathSegments {
            path.append(path: segment,
                        directoryHint: .isDirectory)
        }

        return path
    }

    private func appendFile(named fileName: String, on dirPath: FilePath) -> FilePath {
        return dirPath
            .appending(component: fileName)
            .appendingPathExtension(for: fileExtension)
    }
}

private enum PathBuilder {

}
