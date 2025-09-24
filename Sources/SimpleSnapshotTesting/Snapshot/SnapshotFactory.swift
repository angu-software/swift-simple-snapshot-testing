//
//  SnapshotFactory.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
final class SnapshotFactory {

    enum Error: Swift.Error {
        case malformedSnapshotImage
        case failedToLoadSnapshotFromFile
        case snapshotImageRenderingFailed
        case fileDoesNotExist
    }

    private let fileManager: FileManaging
    private let pathFactory: SnapshotFilePathFactory

    init(fileManager: FileManaging, pathFactory: SnapshotFilePathFactory) {
        self.fileManager = fileManager
        self.pathFactory = pathFactory
    }

    func snapshot<UIKitView: UIView>(from view: UIKitView) throws -> Snapshot {
        guard let imageData = SnapshotImageRenderer.makePNGData(view: view) else {
            throw Error.snapshotImageRenderingFailed
        }

        return Snapshot(pngData: imageData,
                        scale: SnapshotImageRenderer.defaultImageScale,
                        filePath: pathFactory.referenceSnapshotFilePath)!
    }

    func snapshot<SwiftUIView: SwiftUI.View>(from view: SwiftUIView) throws -> Snapshot {
        guard let imageData = SnapshotImageRenderer.makePNGData(view: view) else {
            throw Error.snapshotImageRenderingFailed
        }

        return Snapshot(pngData: imageData,
                        scale: SnapshotImageRenderer.defaultImageScale,
                        filePath: pathFactory.referenceSnapshotFilePath)!
    }

    func referenceSnapshot(from filePath: SnapshotFilePath) throws -> Snapshot {
        let fileURL = filePath.fileURL
        guard fileManager.isFileExisting(at: fileURL) else {
            throw Error.fileDoesNotExist
        }

        let data = try fileManager.load(contentsOf: fileURL)
        let scale = SnapshotImageRenderer.defaultImageScale
        let snapshot =  Snapshot(pngData: data, // TODO: ensure the data is really png data from the loaded snapshot
                                 scale: scale,
                                 filePath: filePath)!

        return snapshot
    }
}
