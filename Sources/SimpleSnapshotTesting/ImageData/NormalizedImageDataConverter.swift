//
//  NormalizedImageDataConverter.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 23.09.25.
//

import SwiftUI
import UIKit

final class NormalizedImageDataConverter {

    typealias PNGImageData = (data: Data, scale: Int)
    typealias CGImageData = (cgImage: CGImage, scale: Int)

    private let isOpaque = false

    // MARK: Conversions from NormalizedImageData

    func makeCGImageData(normalizedData: NormalizedImageData) -> CGImageData? {
        guard let dataProvider = CGDataProvider(data: normalizedData.data as CFData) else {
            return nil
        }

        let pixelBufferInfo = normalizedData.pixelBufferInfo

        guard let cgImage = CGImage(width: pixelBufferInfo.width,
                       height: pixelBufferInfo.height,
                       bitsPerComponent: pixelBufferInfo.bitsPerComponent,
                       bitsPerPixel: pixelBufferInfo.bitsPerPixel,
                       bytesPerRow: pixelBufferInfo.bytesPerRow,
                       space: pixelBufferInfo.colorSpace,
                       bitmapInfo: pixelBufferInfo.bitmapInfo,
                       provider: dataProvider,
                       decode: nil,
                       shouldInterpolate: false,
                                    intent: .defaultIntent) else {
            return nil
        }

        return (cgImage, normalizedData.pixelBufferInfo.scale)
    }

    // TODO: generate image with correct scale
    // TODO: are there dedicated tests?
    func makeUIImage(normalizedImageData normalizedData: NormalizedImageData) -> UIImage? {
        guard let cgImage = makeCGImageData(normalizedData: normalizedData) else {
            return nil
        }

        return UIImage(cgImage: cgImage.cgImage,
                       scale: CGFloat(cgImage.scale),
                       orientation: .up)
    }

    func makePNGImageData(normalizedImageData normalizedData: NormalizedImageData) -> PNGImageData? {
        guard let uiImage = makeUIImage(normalizedImageData: normalizedData),
              let data = uiImage.pngData()else {
            return nil
        }

        return (data, Int(uiImage.scale))
    }

    // MARK: Conversion to NormalizedImageData

    @MainActor
    func makeNormalizedImageData<SwiftUIView: SwiftUI.View>(view: SwiftUIView, scale: Int) -> NormalizedImageData? {
        let renderer = makeImageRenderer(content: view, scale: scale)

        guard let cgImage = renderer.cgImage else {
            return nil
        }

        return makeNormalizedImageData(cgImage: cgImage, scale: scale)
    }

    @MainActor
    func makeNormalizedImageData(view uiView: UIView, scale: Int) -> NormalizedImageData? {
        let renderer = makeImageRenderer(imageSize: uiView.bounds.size, scale: scale)

        let normalizedImage = renderer.image { context in
            uiView.layer.render(in: context.cgContext)
        }

        return makeNormalizedImageData(uiImage: normalizedImage)
    }

    @MainActor
    func makeNormalizedImageData(uiImage: UIImage) -> NormalizedImageData? {
        let imageBounds = CGRect(origin: .zero, size: uiImage.size)
        let scale = Int(uiImage.scale)
        let renderer = makeImageRenderer(imageSize: imageBounds.size,
                                         scale: scale)

        let normalizedImage = renderer.image { context in
            uiImage.draw(in: imageBounds)
        }

        guard let cgImage = normalizedImage.cgImage else {
            return nil
        }

        return makeNormalizedImageData(cgImage: cgImage,
                                       scale: Int(scale))
    }

    func makeNormalizedImageData(pngImageData: PNGImageData) -> NormalizedImageData? {
        return makeNormalizedImageData(pngData: pngImageData.data, scale: pngImageData.scale)
    }

    private func makeNormalizedImageData(cgImageData: CGImageData) -> NormalizedImageData? {
        return makeNormalizedImageData(cgImage: cgImageData.cgImage, scale: cgImageData.scale)
    }

    private func makeNormalizedImageData(pngData: Data, scale: Int) -> NormalizedImageData? {
        guard let imageSource = CGImageSourceCreateWithData(pngData as CFData, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            return nil
        }

        return makeNormalizedImageData(cgImageData: (cgImage, scale))
    }

    private func makeNormalizedImageData(cgImage: CGImage, scale: Int) -> NormalizedImageData? {
        let bufferInfo = PixelBufferInfo(width: cgImage.width, height: cgImage.height, scale: scale)
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
    private func makeImageRenderer(imageSize: CGSize, scale: Int) -> UIGraphicsImageRenderer {
        let format = UIGraphicsImageRendererFormat()
        format.scale = CGFloat(scale)
        format.opaque = isOpaque

        return UIGraphicsImageRenderer(size: imageSize,
                                       format: format)
    }

    @MainActor
    private func makeImageRenderer<Content: View>(content: Content, scale: Int) -> ImageRenderer<Content> {
        let renderer = ImageRenderer(content: content)
        renderer.scale = CGFloat(scale)
        renderer.isOpaque = isOpaque

        return renderer
    }
}
