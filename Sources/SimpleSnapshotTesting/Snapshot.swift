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
                                                testName: StaticString = #function,
                                                testSourcePath: StaticString = #filePath,
                                                identifier: String = "") {

        let fileName = Self.makeFileName(testName: "\(testName)",
                                         snapshotIdentifier: identifier)
        var filePath = FilePath("\(testSourcePath)")
        filePath.removeLastSegment()
        filePath.addSegment("__Snapshots__/\(filePath.lastPathComponent)")
        filePath.addSegment("\(fileName)")
        filePath.addExtension("png")

        self.init(image: SnapshotImageRenderer.makeImage(view: view),
                  fileName: fileName,
                  filePath: filePath.path())
    }

    private static func makeFileName(testName: String,
                                     snapshotIdentifier: String) -> String {
        return [testName.replacingOccurrences(of: "()", with: ""),
                snapshotIdentifier]
            .filter { !$0.isEmpty }
            .joined(separator: "_")
    }
}
