//
//  Snapshot.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 31.12.24.
//

import SwiftUI

typealias SnapshotImageData = Data

struct Snapshot: Equatable {

    let imageData: SnapshotImageData
    let scale: CGFloat
    let imageFilePath: FilePath
}

extension Snapshot {

    var image: SnapshotImage? {
        return SnapshotImageRenderer.makeImage(data: imageData,
                                               scale: scale)
    }

    var isValid: Bool {
        return image != nil
    }

    init?(image: UIImage,
          imageFilePath: FilePath) {
        guard let imageData = SnapshotImageRenderer.makeImageData(image: image) else {
            return nil
        }

        self.init(imageData: imageData,
                  scale: image.scale,
                  imageFilePath: imageFilePath)
    }
}
