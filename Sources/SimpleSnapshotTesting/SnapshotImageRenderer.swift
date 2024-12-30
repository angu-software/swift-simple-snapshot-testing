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
}
