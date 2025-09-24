//
//  Snapshot.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 31.12.24.
//

import SwiftUI

typealias SnapshotImageData = Data

struct Snapshot {

    let imageData: NormalizedImageData
    let filePath: SnapshotFilePath

    init(imageData: NormalizedImageData,
         filePath: SnapshotFilePath) {

        self.imageData = imageData
        self.filePath = filePath
    }
}

extension Snapshot: Equatable {

    var pngData: SnapshotImageData {
        guard let data = NormalizedImageDataConverter().makePNGImageData(normalizedImageData: imageData)?.data else {
            return Data()
        }

        return data
    }

    var scale: CGFloat {
        return CGFloat(imageData.pixelBufferInfo.scale)
    }

    @available(*, deprecated, message: "Use init(imageData: filePath:)")
    init?(pngData: SnapshotImageData, scale: CGFloat, filePath: SnapshotFilePath) {
        guard let imageData = NormalizedImageDataConverter().makeNormalizedImageData(pngImageData: (pngData, Int(scale))) else {
            self.init(imageData: NormalizedImageData(data: Data(), pixelBufferInfo: PixelBufferInfo(width: 0, height: 0, scale: Int(scale))),
                      filePath: filePath)
            return
        }

        self.init(imageData: imageData,
                  filePath: filePath)
    }
}

extension Snapshot {

    func matches(_ other: Self, precision: Double) -> Bool {
        return pngData.isMatching(other.pngData, precision: precision)
    }
}
