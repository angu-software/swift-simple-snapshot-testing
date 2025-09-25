//
//  GraphicsRendererFactory.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 25.09.25.
//

import UIKit
import SwiftUI

@MainActor
enum GraphicsRendererFactory {

    private static let isOpaque = false

    static func makeImageRenderer(imageSize: CGSize, scale: CGFloat) -> UIGraphicsImageRenderer {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = isOpaque

        return UIGraphicsImageRenderer(size: imageSize,
                                       format: format)
    }

    static func makeImageRenderer<Content: View>(content: Content, scale: CGFloat) -> ImageRenderer<Content> {
        let renderer = ImageRenderer(content: content)
        renderer.scale = scale
        renderer.isOpaque = isOpaque

        return renderer
    }
}
