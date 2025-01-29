//
//  Snapshot.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 31.12.24.
//

import SwiftUI

struct Snapshot {

    let image: SnapshotImage
    let imageFilePath: FilePath

    @available(*, deprecated, renamed: "imageFilePath")
    let filePath: SnapshotFilePath
}

extension Snapshot {

    @available(*, deprecated)
    init(image: SnapshotImage,
         filePath: SnapshotFilePath) {
        self.init(image: image,
                  imageFilePath: filePath.referenceSnapshotFile,
                  filePath: filePath)
    }

    private init(image: SnapshotImage,
                 testLocation: SnapshotTestLocation) {
        let pathFactory = SnapshotFilePathFactory(testLocation: testLocation)

        self.init(image: image,
                  imageFilePath: pathFactory.referenceSnapshotFile,
                  filePath: pathFactory)
    }
}

extension Snapshot {

    enum Error: Swift.Error {
        case snapshotImageRenderingFailed
    }

    @MainActor
    init<SwiftUIView: SwiftUI.View>(view: SwiftUIView,
                                    testLocation: SnapshotTestLocation) throws {
        guard let image = SnapshotImageRenderer.makeImage(view: view) else {
            throw Error.snapshotImageRenderingFailed
        }

        self.init(image: image,
                  testLocation: testLocation)
    }
}
