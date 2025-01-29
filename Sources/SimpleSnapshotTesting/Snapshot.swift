//
//  Snapshot.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 31.12.24.
//

import SwiftUI

struct Snapshot {

    let image: SnapshotImage
    let imageFilePath: FilePath
}

extension Snapshot {

    var imageData: Data? {
        return image.pngData()
    }

    init?(imageData: Data,
          scale: CGFloat = 1,
          imageFilePath: FilePath) {
        guard let image = SnapshotImage(data: imageData,
                                        scale: scale) else {
            return nil
        }

        self.init(image: image,
                  imageFilePath: imageFilePath)
    }
}
