//
//  RGBAPixel.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 24.09.25.
//

import Foundation
import UIKit

struct RGBAPixel {

    let bytes: [UInt8]

    var data: Data {
        return Data(bytes)
    }

    init(color: UIColor, scale: Int) {
        let rgbaColor = color.rgbaBytes

        self.bytes = Array(repeating: rgbaColor, count: scale * scale).flatMap { $0 }
    }
}

extension UIColor {

    fileprivate var rgbaBytes: [UInt8] {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        return [
            255 * UInt8(r),
            255 * UInt8(g),
            255 * UInt8(b),
            255 * UInt8(a)
        ]
    }
}
