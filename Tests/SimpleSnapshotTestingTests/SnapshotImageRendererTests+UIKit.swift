//
//  SnapshotImageRendererTests+UIKit.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 30.12.24.
//

import UIKit

import Testing

@testable import SimpleSnapshotTesting

@MainActor
struct SnapshotImageRendererTests_UIKit {

    @Test
    func should_create_an_image_from_a_UIView() throws {
        #expect(makeSnapshotImage(view: makeText("Hello World")) != nil)
    }

    @Test
    func should_create_image_with_views_size() throws {
        let view = makeText("Hello World", size: CGSize(width: 100, height: 100))
        let image = try #require(makeSnapshotImage(view: view))

        #expect(image.size == CGSize(width: 100, height: 100))
    }

    // MARK: Test DSL

    private func makeSnapshotImage<UIKitView: UIView>(view: UIKitView) -> SnapshotImage? {
        return SnapshotImageRenderer.makeImage(view: view)
    }

    private func makeText(_ string: String, size: CGSize = CGSize(width: 40, height: 20)) -> UILabel {
        let text = UILabel(frame: CGRect(origin: .zero, size: size))
        text.text = string

        return text
    }

    private func recordFixtureImage(_ image: UIImage) throws {
        let location = SnapshotTestLocation.fixture()
        let path = SnapshotFilePathFactory(testLocation: location)
        let diffSnapshot = try #require (Snapshot(image: image,
                                                  imageFilePath: SnapshotFilePath(fileURL: path.testFixtureImagePath(for: "fixture_image_diff"))))
        let manager = SnapshotManager(testLocation: location)
        try manager.saveSnapshot(diffSnapshot)
    }
}
