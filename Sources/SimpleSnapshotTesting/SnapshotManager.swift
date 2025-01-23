//
//  SnapshotManager.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 23.01.25.
//

import Foundation

@MainActor
final class SnapshotManager {

    enum Error: Swift.Error {
        case failedToConvertImageToData
    }

    private let fileManager: FileManaging

    init(fileManager: FileManaging = .default) {
        self.fileManager = fileManager
    }

    func saveSnapshot(_ snapshot: Snapshot) throws {
        guard let imageData = snapshot.imageData else {
            throw Error.failedToConvertImageToData
        }

        try createSnapshotDirectory(snapshot)

        try fileManager.write(imageData,
                              to: snapshot.filePath.snapshotFilePath)
    }

    private func createSnapshotDirectory(_ snapshot: Snapshot) throws {
        if !fileManager.isDirectoryExisting(at: snapshot.filePath.testSuiteSnapshotsDir) {
            try fileManager.createDirectory(at: snapshot.filePath.testSuiteSnapshotsDir)
        }
    }
}

extension Snapshot {

    var imageData: Data? {
        return image.pngData()
    }
}
