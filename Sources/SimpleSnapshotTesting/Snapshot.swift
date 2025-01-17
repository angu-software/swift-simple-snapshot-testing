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

    private init(image: SnapshotImage?,
                 fileName: String) {
        self.image = image
        self.fileName = fileName
    }
}

extension Snapshot {

    convenience init<SwiftUIView: SwiftUI.View>(from view: SwiftUIView,
                                                testName: StaticString = #function,
                                                identifier: String = "") {
        self.init(image: SnapshotImageRenderer.makeImage(view: view),
                  fileName: Self.makeFileName(testName: "\(testName)",
                                              snapshotIdentifier: identifier))
    }

    private static func makeFileName(testName: String,
                                     snapshotIdentifier: String) -> String {
        return [testName.replacingOccurrences(of: "()", with: ""),
                snapshotIdentifier]
            .filter { !$0.isEmpty }
            .joined(separator: "_")
    }
}
