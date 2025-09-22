//
//  Snapshot+UIImage.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import UIKit

extension Snapshot {

    var image: SnapshotImage? {
        return SnapshotImageRenderer.makeImage(data: pngData,
                                               scale: scale)
    }

    var isValid: Bool {
        return image != nil
    }

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
