//
//  Snapshot.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 31.12.24.
//

import SwiftUI

@MainActor
final class Snapshot {

    let image: SnapshotImage
    let filePath: SnapshotFilePath

    private convenience init(image: SnapshotImage,
                             testLocation: SnapshotTestLocation) {
        self.init(image: image,
                  filePath: SnapshotFilePath(testLocation: testLocation))
    }

    init(image: SnapshotImage,
         filePath: SnapshotFilePath) {
        self.image = image
        self.filePath = filePath
    }
}

extension Snapshot {

    enum Error: Swift.Error {
        case snapshotImageRenderingFailed
    }

    convenience init<SwiftUIView: SwiftUI.View>(view: SwiftUIView,
                                                testLocation: SnapshotTestLocation) throws {
        guard let image = SnapshotImageRenderer.makeImage(view: view) else {
            throw Error.snapshotImageRenderingFailed
        }

        self.init(image: image,
                  testLocation: testLocation)
    }
}
