//
//  NormalizedImageDataConverter.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 23.09.25.
//

import SwiftUI
import UIKit

final class NormalizedImageDataConverter {

    private let scale: CGFloat
    private let isOpaque = false

    init(scale: CGFloat = 1) {
        self.scale = scale
    }

    // MARK: Conversions from NormalizedImageData

    func makeCGImage(from normalizedData: NormalizedImageData) -> CGImage? {
        guard let dataProvider = CGDataProvider(data: normalizedData.data as CFData) else {
            return nil
        }

        let pixelBufferInfo = normalizedData.pixelBufferInfo

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

    func makeUIImage(from normalizedData: NormalizedImageData) -> UIImage? {
        guard let cgImage = makeCGImage(from: normalizedData) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }

    func makePNGData(from normalizedData: NormalizedImageData) -> Data? {
        return makeUIImage(from: normalizedData)?.pngData()
    }

    // MARK: Conversion to NormalizedImageData

    @MainActor
    func makeNormalizedImageData<SwiftUIView: SwiftUI.View>(from view: SwiftUIView) -> NormalizedImageData? {
        let renderer = makeImageRenderer(content: view)

        guard let cgImage = renderer.cgImage else {
            return nil
        }

        return makeNormalizedImageData(from: cgImage)
    }

    @MainActor
    func makeNormalizedImageData(from uiView: UIView) -> NormalizedImageData? {
        let renderer = makeImageRenderer(imageSize: uiView.bounds.size)

        let normalizedImage = renderer.image { context in
            uiView.layer.render(in: context.cgContext)
        }

        return makeNormalizedImageData(from: normalizedImage)
    }

    @MainActor
    func makeNormalizedImageData(from uiImage: UIImage) -> NormalizedImageData? {
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
    func makeNormalizedImageData(from pngData: Data) -> NormalizedImageData? {
        guard let imageSource = CGImageSourceCreateWithData(pngData as CFData, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            return nil
        }

        return makeNormalizedImageData(from: cgImage)
    }
    
    private func makeNormalizedImageData(from cgImage: CGImage) -> NormalizedImageData? {
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

    private func makeCGContext(buffer bufferPointer: UnsafeMutableRawBufferPointer,
                                      bufferInfo: PixelBufferInfo) -> CGContext? {
        return CGContext(data: bufferPointer.baseAddress,
                         width: bufferInfo.width,
                         height: bufferInfo.height,
                         bitsPerComponent: bufferInfo.bitsPerComponent,
                         bytesPerRow: bufferInfo.bytesPerRow,
                         space: bufferInfo.colorSpace,
                         bitmapInfo: bufferInfo.bitmapInfo)
    }

    // MARK: Supporting Factory Methods

    @MainActor
    private func makeImageRenderer(imageSize: CGSize) -> UIGraphicsImageRenderer {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = isOpaque

        return UIGraphicsImageRenderer(size: imageSize,
                                       format: format)
    }

    @MainActor
    private func makeImageRenderer<Content: View>(content: Content) -> ImageRenderer<Content> {
        let renderer = ImageRenderer(content: content)
        renderer.scale = scale
        renderer.isOpaque = isOpaque

        return renderer
    }
}
