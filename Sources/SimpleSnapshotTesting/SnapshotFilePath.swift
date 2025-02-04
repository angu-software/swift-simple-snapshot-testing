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

    let fileURL: URL
}
