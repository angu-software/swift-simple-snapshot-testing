//
//  SnapshotFilePathFactory.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

import UniformTypeIdentifiers

struct SnapshotFilePathFactory: Equatable {

    private let testSourceFile: URL
    private let fileExtension = UTType.png
    private let snapshotsRootFolderName = "__Snapshots__"
    private let failureDiffsRootFolderName = "FailureDiffs"

    private let testLocation: SnapshotTestLocation

    var referenceSnapshotFilePath: SnapshotFilePath {
        return SnapshotFilePath(fileURL: appendFile(named: snapshotImageFileName,
                                                    at: testSuiteSnapshotsDir))
    }

    var failureOriginalSnapshotFilePath: SnapshotFilePath {
        return SnapshotFilePath(fileURL: appendFile(named: failureOriginalImageFileName,
                                                    at: testSuiteFailureDiffsDir))
    }

    var failureFailedSnapshotFilePath: SnapshotFilePath {
        return SnapshotFilePath(fileURL: appendFile(named: failureFailingImageFileName,
                                                    at: testSuiteFailureDiffsDir))
    }

    var failureDiffSnapshotFilePath: SnapshotFilePath {
        return SnapshotFilePath(fileURL: appendFile(named: failureDiffImageFileName,
                                                    at: testSuiteFailureDiffsDir))
    }

    private var snapshotImageFileName: String {
        return testLocation.testIdentifier
    }

    private var testTargetSnapshotsDir: URL {
        return appendDir(named: snapshotsRootFolderName,
                         at: testTargetDir)
    }

    private var testTargetFailureDiffsDir: URL {
        return appendDir(named: failureDiffsRootFolderName,
                         at: testTargetSnapshotsDir)
    }

    private var testSuiteSnapshotsDir: URL {
        return appendDir(named: testSourceFileName,
                         at: testTargetSnapshotsDir)
    }

    private var testSuiteFailureDiffsDir: URL {
        return appendDir(named: testSourceFileName,
                         at: testTargetFailureDiffsDir)
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

    private var testTargetDir: URL {
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
        self.testSourceFile = URL(filePath: "\(testLocation.testFilePath)")
    }

    private func appendDir(named dirName: String,
                           at dirPath: URL) -> URL {
        return dirPath.appending(path: dirName,
                                 directoryHint: .isDirectory)
    }

    private func appendFile(named fileName: String,
                            at dirPath: URL) -> URL {
        return dirPath
            .appending(component: fileName)
            .appendingPathExtension(for: fileExtension)
    }
}
