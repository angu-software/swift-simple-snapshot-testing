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

        try recordFixtureImage(diffImage)

        #expect(diffImage.scale == 1)
        #expect(diffImage.scale == refDiffImage.scale)
        #expect(diffImage.pngData() == refDiffImage.pngData())
    }

    private func makeSnapshotImage<SwiftUIView: SwiftUI.View>(view: SwiftUIView) -> SnapshotImage? {
        return SnapshotImageRenderer.makeImage(view: view)
    }

    private func recordFixtureImage(_ image: UIImage) throws {
        let location = SnapshotTestLocation.fixture()
        let path = SnapshotFilePathFactory(testLocation: location)
        let diffSnapshot = Snapshot(image: image,
                                    imageFilePath: path.testFixtureImagePath(for: "fixture_image_diff"))
        let manager = SnapshotManager(testLocation: location)
        try manager.saveSnapshot(diffSnapshot)
    }
}

extension SnapshotFilePathFactory {

    func testFixtureImagePath(for imageName: String) -> FilePath {
        return testTargetSnapshotsDir
            .deletingLastPathComponent()
            .appending(path: "Fixtures",
                       directoryHint: .isDirectory)
            .appending(path: imageName,
                       directoryHint: .notDirectory)
            .appendingPathExtension("png")
    }
}
