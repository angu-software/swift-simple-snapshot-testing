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

import SwiftUI
import UIKit

extension NormalizedImageData {

    private static let scale: CGFloat = 1
    private static let isOpaque = false

    @MainActor
    static func from<SwiftUIView: SwiftUI.View>(swiftUIView: SwiftUIView) -> Self? {
        let renderer = makeImageRenderer(content: swiftUIView)

        guard let cgImage = renderer.cgImage else {
            return nil
        }

        return from(cgImage: cgImage)
    }

    @MainActor
    static func from(uiView: UIView) -> Self? {
        let renderer = makeImageRenderer(imageSize: uiView.bounds.size)

        let normalizedImage = renderer.image { context in
            uiView.layer.render(in: context.cgContext)
        }

        return from(uiImage: normalizedImage)
    }

    @MainActor
    static func from(uiImage: UIImage) -> Self? {
        let imageBounds = CGRect(origin: .zero, size: uiImage.size)
        let renderer = makeImageRenderer(imageSize: imageBounds.size)

        let normalizedImage = renderer.image { context in
            uiImage.draw(in: imageBounds)
        }

        guard let cgImage = normalizedImage.cgImage else {
            return nil
        }

        return from(cgImage: cgImage)
    }

    /// - Note: Assumes the `pngData` is @1x scale
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

    @MainActor
    private static func makeImageRenderer(imageSize: CGSize) -> UIGraphicsImageRenderer {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = isOpaque

        return UIGraphicsImageRenderer(size: imageSize,
                                       format: format)
    }

    @MainActor
    private static func makeImageRenderer<Content: View>(content: Content) -> ImageRenderer<Content> {
        let renderer = ImageRenderer(content: content)
        renderer.scale = scale
        renderer.isOpaque = isOpaque

        return renderer
    }
}
