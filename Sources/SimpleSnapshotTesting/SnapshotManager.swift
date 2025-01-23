//
//  SnapshotManager.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 23.01.25.
//

import Foundation

protocol FileManaging {

    func isDirectoryExisting(at directoryPath: FilePath) -> Bool
    func createDirectory(at directoryPath: FilePath)
    func write(_ data: Data, to filePath: FilePath) throws
}

@MainActor
final class SnapshotManager {

    enum Error: Swift.Error {
        case failedToConvertImageToData
    }

    private let fileManager: FileManaging

    init(fileManager: FileManaging) {
        self.fileManager = fileManager
    }

    func saveSnapshot(_ snapshot: Snapshot) throws {
        guard let imageData = snapshot.imageData else {
            throw Error.failedToConvertImageToData
        }

        createSnapshotDirectory(snapshot)

        try fileManager.write(imageData,
                              to: snapshot.filePath.snapshotFilePath)
    }

    private func createSnapshotDirectory(_ snapshot: Snapshot) {
        if !fileManager.isDirectoryExisting(at: snapshot.filePath.testSuiteSnapshotsDir) {
            fileManager.createDirectory(at: snapshot.filePath.testSuiteSnapshotsDir)
        }
    }
}

extension Snapshot {

    var imageData: Data? {
        return image.pngData()
    }
}
