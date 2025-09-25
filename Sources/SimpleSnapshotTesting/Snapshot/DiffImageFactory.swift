//
//  DiffImageFactory.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 30.12.24.
//

import SwiftUI

struct DiffImageFactory {

    @available(*, deprecated)
    static let defaultImageScale: CGFloat = 2

    private let diffBlendMode: CGBlendMode = .difference
    private let diffAlpha: CGFloat = 0.75
    private let recordingScale: CGFloat

    init(recordingScale: CGFloat) {
        self.recordingScale = recordingScale
    }

    @MainActor
    func makeDiffImage(_ image1: UIImage, _ image2: UIImage) -> UIImage? {
        let size = makeCanvasSize(size1: image1.size, size2: image2.size)

        let renderer = GraphicsRendererFactory.makeImageRenderer(imageSize: size,
                                                                 scale: recordingScale)

        let image = renderer.image { context in
            image1.draw(at: .zero)
            image2.draw(at: .zero,
                        blendMode: diffBlendMode,
                        alpha: diffAlpha)
        }

        return image
    }

    private func makeCanvasSize(size1: CGSize, size2: CGSize) -> CGSize {
        let canvasWidth = max(size1.width, size2.width)
        let canvasHeight = max(size1.height, size2.height)
        return CGSize(width: canvasWidth, height: canvasHeight)
    }
}
