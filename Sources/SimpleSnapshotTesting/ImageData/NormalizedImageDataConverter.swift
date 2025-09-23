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

    // MARK: Conversion to NormalizedImageData

    @MainActor
    static func makeNormalizedImageData<SwiftUIView: SwiftUI.View>(from view: SwiftUIView) -> NormalizedImageData? {
        let renderer = makeImageRenderer(content: view)

        guard let cgImage = renderer.cgImage else {
            return nil
        }

        return makeNormalizedImageData(from: cgImage)
    }

    @MainActor
    static func makeNormalizedImageData(from uiView: UIView) -> NormalizedImageData? {
        let renderer = makeImageRenderer(imageSize: uiView.bounds.size)

        let normalizedImage = renderer.image { context in
            uiView.layer.render(in: context.cgContext)
        }

        return makeNormalizedImageData(from: normalizedImage)
    }

    @MainActor
    static func makeNormalizedImageData(from uiImage: UIImage) -> NormalizedImageData? {
        let imageBounds = CGRect(origin: .zero, size: uiImage.size)
        let renderer = makeImageRenderer(imageSize: imageBounds.size)

        let normalizedImage = renderer.image { context in
            uiImage.draw(in: imageBounds)
        }

        guard let cgImage = normalizedImage.cgImage else {
            return nil
        }

        return makeNormalizedImageData(from: cgImage)
    }

    /// - Note: Assumes the `pngData` is @1x scale
    static func makeNormalizedImageData(from pngData: Data) -> NormalizedImageData? {
        guard let imageSource = CGImageSourceCreateWithData(pngData as CFData, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            return nil
        }

        return Self.makeNormalizedImageData(from: cgImage)
    }
    
    private static func makeNormalizedImageData(from cgImage: CGImage) -> NormalizedImageData? {
        let bufferInfo = PixelBufferInfo(width: cgImage.width, height: cgImage.height)
        var rawData = Data(count: bufferInfo.byteCount)

        rawData.withUnsafeMutableBytes { bufferPointer in
            makeCGContext(buffer: bufferPointer,
                          bufferInfo: bufferInfo)?
                .draw(cgImage,
                      in: bufferInfo.bounds)
        }

        return NormalizedImageData(data: rawData,
                                   pixelBufferInfo: bufferInfo)
    }

    private static func makeCGContext(buffer bufferPointer: UnsafeMutableRawBufferPointer,
                                      bufferInfo: PixelBufferInfo) -> CGContext? {
        return CGContext(data: bufferPointer.baseAddress,
                         width: bufferInfo.width,
                         height: bufferInfo.height,
                         bitsPerComponent: bufferInfo.bitsPerComponent,
                         bytesPerRow: bufferInfo.bytesPerRow,
                         space: bufferInfo.colorSpace,
                         bitmapInfo: bufferInfo.bitmapInfo)
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
