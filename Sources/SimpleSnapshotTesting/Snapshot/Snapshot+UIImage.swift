//
//  Snapshot+UIImage.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import UIKit

extension Snapshot {

    @available(*, deprecated)
    var image: SnapshotImage? {
        guard let pngData else {
            return nil
        }
        return SnapshotImageRenderer.makeImage(data: pngData,
                                               scale: scale)
    }

    @available(*, deprecated)
    var isValid: Bool {
        return image != nil
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
