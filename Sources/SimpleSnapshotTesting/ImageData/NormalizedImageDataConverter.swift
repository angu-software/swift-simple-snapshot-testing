//
//  NormalizedImageDataConverter.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 23.09.25.
//


import SwiftUI
import UIKit

enum NormalizedImageDataConverter {

    private static let scale: CGFloat = 1
    private static let isOpaque = false

    @MainActor
    static func from<SwiftUIView: SwiftUI.View>(swiftUIView: SwiftUIView) -> NormalizedImageData? {
        let renderer = makeImageRenderer(content: swiftUIView)

        guard let cgImage = renderer.cgImage else {
            return nil
        }

        return from(cgImage: cgImage)
    }

    @MainActor
    static func from(uiView: UIView) -> NormalizedImageData? {
        let renderer = makeImageRenderer(imageSize: uiView.bounds.size)

        let normalizedImage = renderer.image { context in
            uiView.layer.render(in: context.cgContext)
        }

        return from(uiImage: normalizedImage)
    }

    @MainActor
    static func from(uiImage: UIImage) -> NormalizedImageData? {
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
    static func from(pngData: Data) -> NormalizedImageData? {
        guard let imageSource = CGImageSourceCreateWithData(pngData as CFData, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            return nil
        }

        return Self.from(cgImage: cgImage)
    }

    static func from(cgImage: CGImage) -> NormalizedImageData {
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

        return NormalizedImageData(data: rawData,
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
