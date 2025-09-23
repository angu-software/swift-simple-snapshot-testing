//
//  NormalizedImageData+Convenience.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 23.09.25.
//

import Foundation

@testable import SimpleSnapshotTesting

extension NormalizedImageData {

    init(data: Data, width: Int, height: Int) {
        self.init(data: data,
                  pixelBufferInfo: PixelBufferInfo(width: width, height: height))
    }
}
