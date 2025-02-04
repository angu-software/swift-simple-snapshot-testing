//
//  SnapshotManager.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 23.01.25.
//

import Foundation
import SwiftUI

enum SnapshotComparisonResult {
    case matching
    case different
}

@MainActor
final class SnapshotManager {

    enum Error: Swift.Error {
        case malformedSnapshotImage
        case failedToLoadSnapshotFromFile
        case snapshotImageRenderingFailed
        case fileDoesNotExist
    }

    private let testLocation: SnapshotTestLocation
    private let fileManager: FileManaging
    private let pathFactory: SnapshotFilePathFactory

    init(testLocation: SnapshotTestLocation,
         fileManager: FileManaging = .default) {
        self.testLocation = testLocation
        self.pathFactory = SnapshotFilePathFactory(testLocation: testLocation)
        self.fileManager = fileManager
    }

    func makeSnapshot<SwiftUIView: SwiftUI.View>(view: SwiftUIView) throws -> Snapshot {
        guard let imageData = SnapshotImageRenderer.makePNGData(view: view) else {
            throw Error.snapshotImageRenderingFailed
        }

        return Snapshot(imageData: imageData,
                        scale: SnapshotImageRenderer.defaultImageScale,
                        imageFilePath: pathFactory.referenceSnapshotFile)
    }

    func makeSnapshot(filePath: FilePath) throws -> Snapshot {
        guard fileManager.isFileExisting(at: filePath) else {
            throw Error.fileDoesNotExist
        }

        let data = try fileManager.load(contentsOf: filePath)
        let snapshot =  Snapshot(imageData: data,
                                 scale: 1,
                                 imageFilePath: filePath)
        guard snapshot.isValid else {
            throw Error.failedToLoadSnapshotFromFile
        }

        return snapshot
    }

    func saveSnapshot(_ snapshot: Snapshot) throws {
        guard snapshot.isValid else {
            throw Error.malformedSnapshotImage
        }

        try createSnapshotDirectory(snapshot)

        try fileManager.write(snapshot.imageData,
                              to: snapshot.imageFilePath)
    }

    func compareSnapshot(_ snapshot: Snapshot, with referenceSnapshot: Snapshot) -> SnapshotComparisonResult {
        if snapshot == referenceSnapshot {
            return .matching
        } else {
            return .different
        }
    }

    func makeFailureSnapshot(taken: Snapshot, reference: Snapshot) -> FailureSnapshot {
        let originalSnapshot = Snapshot(imageData: reference.imageData,
                                        scale: reference.scale,
                                        imageFilePath: pathFactory.failureOriginalSnapshotFile)
        let failedSnapshot = Snapshot(imageData: taken.imageData,
                                      scale: taken.scale,
                                      imageFilePath: pathFactory.failureFailedSnapshotFile)
        let diffImage = SnapshotImageRenderer.makeDiffImage(taken.image!, reference.image!)!
        let diffSnapshot = Snapshot(image: diffImage,
                                    imageFilePath: pathFactory.failureDiffSnapshotFile)
        return FailureSnapshot(original: originalSnapshot,
                               failed: failedSnapshot,
                               diff: diffSnapshot!)
    }

    private func createSnapshotDirectory(_ snapshot: Snapshot) throws {
        let testSuiteSnapshotsDir = pathFactory.testSuiteSnapshotsDir
        if !fileManager.isDirectoryExisting(at: testSuiteSnapshotsDir) {
            try fileManager.createDirectory(at: testSuiteSnapshotsDir)
        }
    }
}
