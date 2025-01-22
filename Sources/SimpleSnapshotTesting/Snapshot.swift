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

    private init(image: SnapshotImage,
                 filePath: SnapshotFilePath) {
        self.image = image
        self.filePath = filePath
    }
}

extension Snapshot {

    enum Error: Swift.Error {
        case snapshotImageRenderingFailed
    }

    convenience init<SwiftUIView: SwiftUI.View>(_ view: SwiftUIView,
                                                testLocation: SnapshotTestLocation) throws {
        guard let image = SnapshotImageRenderer.makeImage(view: view) else {
            throw Error.snapshotImageRenderingFailed
        }

        self.init(image: image,
                  filePath: SnapshotFilePath(testLocation: testLocation)
        )
    }
}
