//
//  DiffImageFactoryTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 30.12.24.
//

import SwiftUI
import UIKit

import Testing

@testable import SimpleSnapshotTesting

@MainActor
struct DiffImageFactoryTests {

    private var defaultScale: CGFloat {
        return DiffImageFactory.defaultImageScale
    }

    @Test
    func should_create_diff_image() throws {
        let refDiffImage = try #require(TestFixtures.image(named: "fixture_image_diff"))
        let image1 = try #require(makeSnapshotImage(view: FixtureView()))
        let image2 = try #require(makeSnapshotImage(view: FixtureView(isChanged: true)))

        let diffImage = try #require(DiffImageFactory.makeDiffImage(image1, image2))

//        try recordFixtureImage(diffImage)

        #expect(diffImage.scale == defaultScale)
        #expect(diffImage.pngData() == refDiffImage.pngData())
    }

    @Test
    func whenCreatingDiffImages_itItRendersInSpecifiedScale() async throws {
        let image1 = try #require(makeSnapshotImage(view: Rectangle()))
        let image2 = try #require(makeSnapshotImage(view: Rectangle()))

        let diffImage = try #require(DiffImageFactory.makeDiffImage(image1, image2, scale: 1))

        #expect(diffImage.scale == 1)
    }

    @Test
    func whenCreatingDiffImages_fromDifferentSizedImages_itRetrunsDiffImageWithBiggestSize() async throws {
        let image1 = try #require(makeSnapshotImage(view: Rectangle().frame(width: 20, height: 20)))
        let image2 = try #require(makeSnapshotImage(view: Rectangle()))

        let diffImage = try #require(DiffImageFactory.makeDiffImage(image1, image2))

        #expect(diffImage.size == CGSize(width: 20, height: 20))
    }

    // MARK: Test DSL

    private func makeSnapshotImage<SwiftUIView: SwiftUI.View>(view: SwiftUIView) -> UIImage? {
        let converter = NormalizedImageDataConverter()
        guard let imageData = converter.makeNormalizedImageData(view: view, scale: Int(defaultScale)) else {
            return nil
        }

        return converter.makeUIImage(normalizedImageData: imageData)
    }

    private func recordFixtureImage(_ image: UIImage) throws {
        let location = SnapshotTestLocation.fixture()
        let path = SnapshotFilePathFactory(testLocation: location, deviceScale: defaultScale)
        let diffSnapshot = try #require (Snapshot(image: image,
                                                  filePath: SnapshotFilePath(fileURL: path.testFixtureImagePath(for: "fixture_image_diff"))))
        let manager = SnapshotManager(testLocation: location,
                                      recordingScale: 2)
        try manager.saveSnapshot(diffSnapshot)
    }
}
