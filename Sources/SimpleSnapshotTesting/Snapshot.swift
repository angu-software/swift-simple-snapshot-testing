//
//  Snapshot.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 31.12.24.
//

import SwiftUI

@MainActor
final class Snapshot {

    // TODO: make non-optional in favor of fail-able init
    let image: SnapshotImage?
    let filePath: SnapshotFilePath

    var fileName: String {
        filePath.fileName
    }

    private init(image: SnapshotImage?,
                 filePath: SnapshotFilePath) {
        self.image = image
        self.filePath = filePath
    }
}

extension Snapshot {

    convenience init<SwiftUIView: SwiftUI.View>(from view: SwiftUIView,
                                                testMethod: StaticString = #function,
                                                testSourcePath: StaticString = #filePath,
                                                testTag: String = "") {
        self.init(
            image: SnapshotImageRenderer.makeImage(view: view),
            filePath: SnapshotFilePath(
                test: SnapshotTest(
                    testFunction: testMethod,
                    testFilePath: testSourcePath,
                    testTag: testTag
                )
            )
        )
    }
}
