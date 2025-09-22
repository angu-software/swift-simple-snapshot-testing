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

    typealias Error = SnapshotFactory.Error

    private let testLocation: SnapshotTestLocation
    private let fileManager: FileManaging
    private let pathFactory: SnapshotFilePathFactory

    private let snapshotFactory: SnapshotFactory

    init(testLocation: SnapshotTestLocation,
         fileManager: FileManaging = .default) {
        self.testLocation = testLocation
        self.pathFactory = SnapshotFilePathFactory(testLocation: testLocation)
        self.fileManager = fileManager
        self.snapshotFactory = SnapshotFactory(fileManager: fileManager, pathFactory: pathFactory)
    }

    func snapshot<UIKitView: UIView>(from view: UIKitView) throws -> Snapshot {
        return try snapshotFactory.snapshot(from: view)
    }

    func snapshot<SwiftUIView: SwiftUI.View>(from view: SwiftUIView) throws -> Snapshot {
        return try snapshotFactory.snapshot(from: view)
    }

    func referenceSnapshot(from filePath: SnapshotFilePath) throws -> Snapshot {
        return try snapshotFactory.referenceSnapshot(from: filePath)
    }

    func saveSnapshot(_ snapshot: Snapshot) throws {
        guard snapshot.isValid else {
            throw Error.malformedSnapshotImage
        }

        try createSnapshotDirectory(snapshot)

        try fileManager.write(snapshot.pngData,
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
