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
        case failedToConvertImageToData
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
        guard let image = SnapshotImageRenderer.makeImage(view: view) else {
            throw Error.snapshotImageRenderingFailed
        }

        return Snapshot(image: image,
                        imageFilePath: pathFactory.referenceSnapshotFile)
    }

    func makeSnapshot(filePath: FilePath) throws -> Snapshot {
        guard fileManager.isFileExisting(at: filePath) else {
            throw Error.fileDoesNotExist
        }

        let data = try fileManager.load(contentsOf: filePath)
        guard let snapshot =  Snapshot(imageData: data,
                                       imageFilePath: filePath) else {
            throw Error.failedToLoadSnapshotFromFile
        }

        return snapshot
    }

    func saveSnapshot(_ snapshot: Snapshot) throws {
        guard let imageData = snapshot.imageData else {
            throw Error.failedToConvertImageToData
        }

        try createSnapshotDirectory(snapshot)

        try fileManager.write(imageData,
                              to: snapshot.imageFilePath)
    }

    func compareSnapshot(_ snapshot: Snapshot, with referenceSnapshot: Snapshot) -> SnapshotComparisonResult {
        if snapshot.imageData == referenceSnapshot.imageData {
            return .matching
        } else {
            return .different
        }
    }

    func makeFailureSnapshot(taken: Snapshot, reference: Snapshot) -> FailureSnapshot {
        let originalSnapshot = Snapshot(image: reference.image,
                                        imageFilePath: pathFactory.failureOriginalSnapshotFile)
        let failedSnapshot = Snapshot(image: taken.image,
                                      imageFilePath: pathFactory.failureFailedSnapshotFile)
        let diffSnapshot = Snapshot(image: SnapshotImageRenderer.makeDiffImage(taken.image, reference.image)!,
                                    imageFilePath: pathFactory.failureDiffSnapshotFile)
        return FailureSnapshot(original: originalSnapshot,
                               failed: failedSnapshot,
                               diff: diffSnapshot)
    }

    private func createSnapshotDirectory(_ snapshot: Snapshot) throws {
        let testSuiteSnapshotsDir = pathFactory.testSuiteSnapshotsDir
        if !fileManager.isDirectoryExisting(at: testSuiteSnapshotsDir) {
            try fileManager.createDirectory(at: testSuiteSnapshotsDir)
        }
    }
}
