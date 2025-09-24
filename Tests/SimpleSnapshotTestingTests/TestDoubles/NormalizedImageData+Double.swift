//
//  NormalizedImageData+Double.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 24.09.25.
//

@testable import SimpleSnapshotTesting

extension NormalizedImageData {

    static func fixture(scale: Int = 1) -> Self {
        let data = RGBAPixel(color: .red,
                             scale: scale).data

        return NormalizedImageData(data: data,
                                   width: 1 * scale,
                                   height: 1 * scale,
                                   scale: scale)
    }
}
