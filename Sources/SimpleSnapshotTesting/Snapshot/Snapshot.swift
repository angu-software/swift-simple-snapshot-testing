//
//  Snapshot.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 31.12.24.
//

import SwiftUI

typealias SnapshotImageData = Data

struct Snapshot: Equatable {

    let pngData: SnapshotImageData
    let scale: CGFloat
    let filePath: SnapshotFilePath

    @available(*, deprecated, message: "Use init(imageData: filePath:)")
    init?(pngData: SnapshotImageData, scale: CGFloat, filePath: SnapshotFilePath) {
        self.pngData = pngData
        self.scale = scale
        self.filePath = filePath
    }
}

extension Snapshot {

    init(imageData: NormalizedImageData,
         filePath: SnapshotFilePath) {

        self.pngData = imageData.data
        self.scale = CGFloat(imageData.pixelBufferInfo.scale)
        self.filePath = filePath
    }
}

extension Snapshot {

    func matches(_ other: Self, precision: Double) -> Bool {
        return pngData.isMatching(other.pngData, precision: precision)
    }
}
