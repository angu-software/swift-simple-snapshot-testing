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
    static func makeImage<SwiftUIView: View>(view: SwiftUIView) -> SnapshotImage? {
        let renderer = ImageRenderer(content: view)
        renderer.scale = defaultImageScale

        return renderer.uiImage
    }

    @MainActor
    static func makePNGData<SwiftUIView: View>(view: SwiftUIView) -> SnapshotImageData? {
        return makeImage(view: view)?.pngData()
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
