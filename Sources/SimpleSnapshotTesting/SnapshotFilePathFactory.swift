//
//  SnapshotFilePathFactory.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

import UniformTypeIdentifiers

struct SnapshotFilePathFactory: Equatable {

    private let testSourceFile: FilePath
    private let fileExtension = UTType.png
    private let snapshotsRootFolderName = "__Snapshots__"
    private let failureDiffsRootFolderName = "FailureDiffs"

    private let testLocation: SnapshotTestLocation

    var snapshotImageFileName: String {
        return testLocation.testIdentifier
    }

    var testTargetSnapshotsDir: FilePath {
        return appendDir(named: snapshotsRootFolderName,
                         at: testTargetDir)
    }

    var testTargetFailureDiffsDir: FilePath {
        return appendDir(named: failureDiffsRootFolderName,
                         at: testTargetSnapshotsDir)
    }

    var testSuiteSnapshotsDir: FilePath {
        return appendDir(named: testSourceFileName,
                         at: testTargetSnapshotsDir)
    }

    var testSuiteFailureDiffsDir: FilePath {
        return appendDir(named: testSourceFileName,
                         at: testTargetFailureDiffsDir)
    }

    var referenceSnapshotFile: FilePath {
        return appendFile(named: snapshotImageFileName,
                          at: testSuiteSnapshotsDir)
    }

    var failureOriginalSnapshotFile: FilePath {
        return appendFile(named: failureOriginalImageFileName,
                          at: testSuiteFailureDiffsDir)
    }

    var failureFailingSnapshotFile: FilePath {
        return appendFile(named: failureFailingImageFileName,
                          at: testSuiteFailureDiffsDir)
    }

    var failureDiffSnapshotFile: FilePath {
        return appendFile(named: failureDiffImageFileName,
                          at: testSuiteFailureDiffsDir)
    }

    private var failureOriginalImageFileName: String {
        return "ORIG_\(snapshotImageFileName)"
    }

    private var failureFailingImageFileName: String {
        return "FAIL_\(snapshotImageFileName)"
    }

    private var failureDiffImageFileName: String {
        return "DIFF_\(snapshotImageFileName)"
    }

    private var testTargetDir: FilePath {
        return testSourceFile
            .deletingLastPathComponent()
    }

    private var testTargetName: String {
        return testTargetDir.lastPathComponent
    }

    private var testSourceFileName: String {
        return testSourceFile.deletingPathExtension().lastPathComponent
    }

    init(testLocation: SnapshotTestLocation) {
        self.testLocation = testLocation
        self.testSourceFile = FilePath("\(testLocation.testFilePath)")
    }

    private func appendDir(named dirName: String,
                           at dirPath: FilePath) -> FilePath {
        return dirPath.appending(path: dirName,
                                 directoryHint: .isDirectory)
    }

    private func appendFile(named fileName: String,
                            at dirPath: FilePath) -> FilePath {
        return dirPath
            .appending(component: fileName)
            .appendingPathExtension(for: fileExtension)
    }
}
