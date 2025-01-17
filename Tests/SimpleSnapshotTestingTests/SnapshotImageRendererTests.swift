//
//  SnapshotImageRendererTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 30.12.24.
//

import SwiftUI

import Testing

@testable import SimpleSnapshotTesting

@MainActor
@Suite
struct SnapshotImageRendererTests {

    @Test
    func should_create_an_image_from_a_view() throws {
        #expect(makeSnapshotImage(view: Text("Hello World")) != nil)
    }

    @Test
    func should_create_image_with_views_size() throws {
        let view = Text("Hello World")
            .frame(width: 100, height: 100)

        let image = try #require(makeSnapshotImage(view: view))

        #expect(image.size == CGSize(width: 100, height: 100))
    }

    @Test
    func should_create_image_with_default_scale() throws {
        let image = try #require(makeSnapshotImage(view: Text("Hello World")))

        #expect(image.scale == 1)

    }

    private func makeSnapshotImage<SwiftUIView: SwiftUI.View>(view: SwiftUIView) -> SnapshotImage? {
        return SnapshotImageRenderer.makeImage(view: view)
    }
}
