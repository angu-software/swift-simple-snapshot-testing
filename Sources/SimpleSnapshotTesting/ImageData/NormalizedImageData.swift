//
//  NormalizedImageData.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import Foundation
import CoreGraphics
import UIKit

/*
 struct Snapshot {
    let normalizedImageData: NormalizedImageData
    let scale: CGFloat
 }
 */

struct NormalizedImageData: Equatable {
    let data: Data
    let width: Int
    let height: Int

    // TODO: CGSize, CGRect convenience?
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
        let width = cgImage.width
        let height = cgImage.height
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel

        var rawData = Data(count: height * bytesPerRow)

        rawData.withUnsafeMutableBytes { bufferPointer in
            if let context = CGContext(data: bufferPointer.baseAddress,
                                       width: width,
                                       height: height,
                                       bitsPerComponent: bitsPerComponent,
                                       bytesPerRow: bytesPerRow,
                                       space: CGColorSpaceCreateDeviceRGB(),
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
                let imageRect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
                context.draw(cgImage, in: imageRect)
            }
        }
        
        return Self(data: rawData,
                    width: width,
                    height: height)
    }
}
