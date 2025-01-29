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
    }

    private let fileManager: FileManaging

    init(fileManager: FileManaging = .default) {
        self.fileManager = fileManager
    }

    @MainActor
    func makeSnapshot<SwiftUIView: SwiftUI.View>(view: SwiftUIView,
                                                 testLocation: SnapshotTestLocation) throws -> Snapshot {
        return try Snapshot(view: view,
                            testLocation: testLocation)
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
