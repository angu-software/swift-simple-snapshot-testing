//
//  NormalizedImageData.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import Foundation
import CoreGraphics
import UIKit

struct NormalizedImageData: Equatable {
    let data: Data
    let pixelBufferInfo: PixelBufferInfo
}

struct PixelBufferInfo: Equatable {
    let width: Int
    let height: Int
    // TODO: scale?

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

extension NormalizedImageData {

    var cgImage: CGImage? {
        guard let dataProvider = CGDataProvider(data: data as CFData) else {
            return nil
        }
        
        return CGImage(width: pixelBufferInfo.width,
                       height: pixelBufferInfo.height,
                       bitsPerComponent: pixelBufferInfo.bitsPerComponent,
                       bitsPerPixel: pixelBufferInfo.bitsPerPixel,
                       bytesPerRow: pixelBufferInfo.bytesPerRow,
                       space: pixelBufferInfo.colorSpace,
                       bitmapInfo: pixelBufferInfo.bitmapInfo,
                       provider: dataProvider,
                       decode: nil,
                       shouldInterpolate: false,
                       intent: .defaultIntent)
    }

    var uiImage: UIImage? {
        guard let cgImage else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }

    func pngData() -> Data? {
        return uiImage?.pngData()
    }
}

extension NormalizedImageData {

    static func from(pngData: Data) -> Self? {
        guard let imageSource = CGImageSourceCreateWithData(pngData as CFData, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            return nil
        }

        return Self.from(cgImage: cgImage)
    }

    static func from(cgImage: CGImage) -> Self {
        let meta = PixelBufferInfo(width: cgImage.width, height: cgImage.height)
        var rawData = Data(count: meta.byteCount)

        rawData.withUnsafeMutableBytes { bufferPointer in
            if let context = CGContext(data: bufferPointer.baseAddress,
                                       width: meta.width,
                                       height: meta.height,
                                       bitsPerComponent: meta.bitsPerComponent,
                                       bytesPerRow: meta.bytesPerRow,
                                       space: meta.colorSpace,
                                       bitmapInfo: meta.bitmapInfo) {
                context.draw(cgImage, in: meta.bounds)
            }
        }

        return Self(data: rawData,
                    pixelBufferInfo: meta)
    }
}
