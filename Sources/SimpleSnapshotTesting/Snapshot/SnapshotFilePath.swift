//
//  SnapshotFilePath.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 17.01.25.
//

import Foundation

struct SnapshotFilePath: Equatable {

    var directoryURL: URL {
        return fileURL.deletingLastPathComponent()
    }

    var scale: CGFloat {
        if fileURL.filePath.contains("@3x") {
            return 3
        } else if fileURL.filePath.contains("@2x") {
            return 2
        } else {
            return 1
        }
    }

    let fileURL: URL
}
