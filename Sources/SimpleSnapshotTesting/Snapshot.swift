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
    let fileName: String
    let filePath: String

    private init(image: SnapshotImage?,
                 fileName: String,
                 filePath: String) {
        self.image = image
        self.fileName = fileName
        self.filePath = filePath
    }
}

extension Snapshot {

    convenience init<SwiftUIView: SwiftUI.View>(from view: SwiftUIView,
                                                testMethod: StaticString = #function,
                                                testSourcePath: StaticString = #filePath,
                                                testTag: String = "") {

        let filePath = SnapshotFilePath(test: SnapshotTest(methodSignature: testMethod,
                                                           sourcePath: testSourcePath,
                                                           tag: testTag))

        self.init(image: SnapshotImageRenderer.makeImage(view: view),
                  fileName: filePath.fileName,
                  filePath: filePath.filePath.path())
    }
}
