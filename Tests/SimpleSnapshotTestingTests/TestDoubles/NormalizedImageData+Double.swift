//
//  NormalizedImageData+Double.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 24.09.25.
//

import Foundation
import UIKit

@testable import SimpleSnapshotTesting

extension NormalizedImageData {

    static func fixture(color: UIColor = .red,
                        size: CGSize = CGSize(width: 1, height: 1),
                        scale: Int = 1) -> Self {
        let data = RGBAPixel(color: color,
                             scale: scale).data

        return NormalizedImageData(data: data,
                                   width: Int(size.width) * scale,
                                   height: Int(size.height) * scale,
                                   scale: scale)
    }
}
