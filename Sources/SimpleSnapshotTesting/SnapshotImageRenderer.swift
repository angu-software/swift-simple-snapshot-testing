//
//  SnapshotImageRenderer.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 30.12.24.
//

import SwiftUI

typealias SnapshotImage = UIImage

enum SnapshotImageRenderer {

    static let defaultImageScale: CGFloat = 1

    private static let diffBlendMode: CGBlendMode = .difference
    private static let diffAlpha: CGFloat = 0.75

    @MainActor
    static func makeImage<UIKitView: UIView>(view: UIKitView) -> SnapshotImage? {
        let canvasFrame = CGRect(origin: .zero, size: view.frame.size)
        let renderer = UIGraphicsImageRenderer(bounds: canvasFrame)

        return renderer.image { ctx in
            view.draw(canvasFrame)
        }
    }

    @MainActor
    static func makeImage<SwiftUIView: View>(view: SwiftUIView) -> SnapshotImage? {
        let renderer = ImageRenderer(content: view)
        renderer.scale = defaultImageScale

        return renderer.uiImage
    }

    @MainActor
    static func makePNGData<SwiftUIView: View>(view: SwiftUIView) -> SnapshotImageData? {
        guard let image = makeImage(view: view) else {
            return nil
        }

        return makeImageData(image: image)
    }

    static func makeImageData(image: SnapshotImage) -> SnapshotImageData? {
        return image.pngData()
    }

    static func makeImage(data: Data, scale: CGFloat = Self.defaultImageScale) -> SnapshotImage? {
        return SnapshotImage(data: data,  scale: scale)
    }

    @MainActor
    static func makeDiffImage(_ image1: SnapshotImage, _ image2: SnapshotImage) -> SnapshotImage? {
        let size = makeCanvasSize(size1: image1.size, size2: image2.size)

        let renderer = UIGraphicsImageRenderer(size: size,
                                               format: makeFormat())

        let image = renderer.image { context in
            image1.draw(at: .zero)
            image2.draw(at: .zero,
                        blendMode: diffBlendMode,
                        alpha: diffAlpha)
        }

        return image
    }

    private static func makeCanvasSize(size1: CGSize, size2: CGSize) -> CGSize {
        let canvasWidth = max(size1.width, size2.width)
        let canvasHeight = max(size1.height, size2.height)
        return CGSize(width: canvasWidth, height: canvasHeight)
    }

    private static func makeFormat() -> UIGraphicsImageRendererFormat {
        let format = UIGraphicsImageRendererFormat()
        format.scale = defaultImageScale

        return format
    }
}
