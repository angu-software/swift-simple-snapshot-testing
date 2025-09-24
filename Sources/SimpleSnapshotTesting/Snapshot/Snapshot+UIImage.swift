//
//  Snapshot+UIImage.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import UIKit

extension Snapshot {

    var image: SnapshotImage? {
        return NormalizedImageDataConverter().makeUIImage(normalizedImageData: imageData)
    }

    @available(*, deprecated, message: "Use Snapshot(imageData:filePath:) instead")
    init?(image: UIImage,
          imageFilePath: SnapshotFilePath) {
        guard let pngData = SnapshotImageRenderer.makePNGData(image: image) else {
            return nil
        }

        self.init(pngData: pngData,
                  scale: image.scale,
                  filePath: imageFilePath)
    }
}
