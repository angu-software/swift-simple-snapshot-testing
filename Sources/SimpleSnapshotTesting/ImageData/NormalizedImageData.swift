//
//  NormalizedImageData.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import Foundation
import CoreGraphics

struct NormalizedImageData: Equatable {

    let data: Data
    let pixelBufferInfo: PixelBufferInfo
}

struct PixelBufferInfo: Equatable {
    let width: Int
    let height: Int

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    let bitsPerComponent = 8
    let bytesPerPixel = 4

    var bitsPerPixel: Int {
        return bytesPerPixel * bitsPerComponent
    }

    var bytesPerRow: Int {
        return width * bytesPerPixel
    }

    var byteCount: Int {
        return height * bytesPerRow
    }

    var bounds: CGRect {
        return CGRect(origin: .zero, size: CGSize(width: width, height: height))
    }
}
