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
        let rgbaColor: [UInt8] = [255, 0, 0, 255]

        self.bytes = Array(repeating: rgbaColor, count: scale * scale).flatMap { $0 }
    }
}
