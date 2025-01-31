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


    @Test
    func should_create_diff_image() throws {
        let refDiffImage = try #require(TestFixtures.image(named: "fixture_image_diff"))
        let image1 = try #require(makeSnapshotImage(view: FixtureView()))
        let image2 = try #require(makeSnapshotImage(view: FixtureView(isChanged: true)))

        let diffImage = try #require(SnapshotImageRenderer.makeDiffImage(image1, image2))

        #expect(diffImage.scale == 2) // TODO: should be scale 1, same as all other images
        #expect(diffImage.scale == refDiffImage.scale)
        #expect(diffImage.pngData() == refDiffImage.pngData())
    }

    private func makeSnapshotImage<SwiftUIView: SwiftUI.View>(view: SwiftUIView) -> SnapshotImage? {
        return SnapshotImageRenderer.makeImage(view: view)
    }
}
