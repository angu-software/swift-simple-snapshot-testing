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

    func snapshot<UIKitView: UIView>(from view: UIKitView) throws -> Snapshot {
        guard let imageData = SnapshotImageRenderer.makePNGData(view: view) else {
            throw Error.snapshotImageRenderingFailed
        }

        return Snapshot(imageData: imageData,
                        scale: SnapshotImageRenderer.defaultImageScale,
                        filePath: pathFactory.referenceSnapshotFilePath)
    }

    func snapshot<SwiftUIView: SwiftUI.View>(from view: SwiftUIView) throws -> Snapshot {
        guard let imageData = SnapshotImageRenderer.makePNGData(view: view) else {
            throw Error.snapshotImageRenderingFailed
        }

        return Snapshot(imageData: imageData,
                        scale: SnapshotImageRenderer.defaultImageScale,
                        filePath: pathFactory.referenceSnapshotFilePath)
    }

    func referenceSnapshot(from filePath: SnapshotFilePath) throws -> Snapshot {
        let fileURL = filePath.fileURL
        guard fileManager.isFileExisting(at: fileURL) else {
            throw Error.fileDoesNotExist
        }

        let data = try fileManager.load(contentsOf: fileURL)
        let snapshot =  Snapshot(imageData: data,
                                 scale: SnapshotImageRenderer.defaultImageScale,
                                 filePath: filePath)
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
                              to: snapshot.filePath.fileURL)
    }

    func saveFailureSnapshot(_ failureSnapshot: FailureSnapshot) throws {
        try saveSnapshot(failureSnapshot.diff)
        try saveSnapshot(failureSnapshot.failed)
        try saveSnapshot(failureSnapshot.original)
    }

    func compareSnapshot(_ snapshot: Snapshot,
                         with referenceSnapshot: Snapshot,
                         precision: Double) -> SnapshotComparisonResult {
        if snapshot.matches(referenceSnapshot, precision: precision) {
            return .matching
        } else {
            return .different
        }
    }

    func makeFailureSnapshot(taken: Snapshot, reference: Snapshot) throws -> FailureSnapshot {
        let originalSnapshot = reference.with(filePath: pathFactory.failureOriginalSnapshotFilePath)
        let failedSnapshot = taken.with(filePath: pathFactory.failureFailedSnapshotFilePath)

        guard let takenImage = taken.image,
              let referenceImage = reference.image,
              let diffImage = SnapshotImageRenderer.makeDiffImage(takenImage,
                                                                  referenceImage),
              let diffSnapshot = Snapshot(image: diffImage,
                                          imageFilePath: pathFactory.failureDiffSnapshotFilePath) else {
            throw Error.malformedSnapshotImage
        }

        return FailureSnapshot(original: originalSnapshot,
                               failed: failedSnapshot,
                               diff: diffSnapshot)
    }

    private func createSnapshotDirectory(_ snapshot: Snapshot) throws {
        let testSuiteSnapshotsDir = snapshot.filePath.directoryURL
        if !fileManager.isDirectoryExisting(at: testSuiteSnapshotsDir) {
            try fileManager.createDirectory(at: testSuiteSnapshotsDir)
        }
    }
}
