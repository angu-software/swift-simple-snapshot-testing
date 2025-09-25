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
    private let dataConverter = NormalizedImageDataConverter()

    private let recordingImageScale: Int

    init(fileManager: FileManaging,
         pathFactory: SnapshotFilePathFactory,
         recordingScale: CGFloat) {
        self.fileManager = fileManager
        self.pathFactory = pathFactory
        self.recordingImageScale = Int(recordingScale)
    }

    func snapshot<UIKitView: UIView>(from view: UIKitView) throws -> Snapshot {
        guard let imageData = dataConverter.makeNormalizedImageData(view: view, scale: recordingImageScale) else {
            throw Error.snapshotImageRenderingFailed
        }

        return Snapshot(imageData: imageData,
                        filePath: pathFactory.referenceSnapshotFilePath)
    }

    func snapshot<SwiftUIView: SwiftUI.View>(from view: SwiftUIView) throws -> Snapshot {
        guard let imageData = dataConverter.makeNormalizedImageData(view: view, scale: recordingImageScale) else {
            throw Error.snapshotImageRenderingFailed
        }

        return Snapshot(imageData: imageData,
                        filePath: pathFactory.referenceSnapshotFilePath)
    }

    func referenceSnapshot(from filePath: SnapshotFilePath) throws -> Snapshot {
        let fileURL = filePath.fileURL
        guard fileManager.isFileExisting(at: fileURL) else {
            throw Error.fileDoesNotExist
        }

        // TODO: we currently assume the image is png data
        let rawData = try fileManager.load(contentsOf: fileURL)
        guard let uiImage = UIImage(data: rawData, scale: filePath.scale),
              let imageData = uiImage.pngData() else {
            throw Error.failedToLoadSnapshotFromFile
        }
        
        let snapshot = Snapshot(pngData: imageData,
                                scale: filePath.scale,
                                filePath: filePath)!

        return snapshot
    }
}
