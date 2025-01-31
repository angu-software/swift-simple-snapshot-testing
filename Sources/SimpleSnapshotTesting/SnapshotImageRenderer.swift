//
//  SnapshotImageRenderer.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 30.12.24.
//

import SwiftUI

typealias SnapshotImage = UIImage

enum SnapshotImageRenderer {

    @MainActor
    static func makeImage<SwiftUIView: View>(view: SwiftUIView) -> UIImage? {
        let renderer = ImageRenderer(content: view)

        return renderer.uiImage
    }

    @MainActor
    static func makeDiffImage(_ image1: UIImage, _ image2: UIImage) -> UIImage? {
        // Determine the canvas size
        let canvasWidth = max(image1.size.width, image2.size.width)
        let canvasHeight = max(image1.size.height, image2.size.height)
        let size = CGSize(width: canvasWidth, height: canvasHeight)

        let renderer = UIGraphicsImageRenderer(size: size)

        let image = renderer.image { context in
            image1.draw(at: .zero)
            image2.draw(at: .zero, blendMode: .difference, alpha: 0.75)
        }

        return image
    }
}
