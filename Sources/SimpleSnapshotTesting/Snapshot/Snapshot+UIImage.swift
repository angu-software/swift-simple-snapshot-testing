//
//  Snapshot+UIImage.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import UIKit

extension Snapshot {

    var image: UIImage? {
        return NormalizedImageDataConverter().makeUIImage(normalizedImageData: imageData)
    }

    @MainActor
    init?(image: UIImage,
          filePath: SnapshotFilePath) {
        guard let imageData = NormalizedImageDataConverter().makeNormalizedImageData(uiImage: image) else {
            return nil
        }

        self.init(imageData: imageData,
                  filePath: filePath)
    }
}
