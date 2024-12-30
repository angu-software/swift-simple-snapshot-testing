import SwiftUI

import XCTest

@testable import SimpleSnapshotTesting

@MainActor
final class SimpleSnapshotTestingTests: XCTestCase {

    func test_should_create_an_image_from_a_view() throws {
        XCTAssertNotNil(makeSnapshotImage(view: Text("Hello World")))
    }

    func test_should_create_image_with_views_size() throws {
        var view: any View = Text("Hello World")
        view = view.frame(width: 100, height: 100)

        let image = try XCTUnwrap(makeSnapshotImage(view: view))

        XCTAssertEqual(image.size, CGSize(width: 100, height: 100))
    }

    func test_should_create_image_with_default_scale() throws {
        let image = try XCTUnwrap(makeSnapshotImage(view: Text("Hello World")))

        XCTAssertEqual(image.scale, 1)
    }

    private func makeSnapshotImage<View: SwiftUI.View>(view: View) -> SnapshotImage? {
        return SnapshotImageRenderer.makeImage(view: view)
    }
}
