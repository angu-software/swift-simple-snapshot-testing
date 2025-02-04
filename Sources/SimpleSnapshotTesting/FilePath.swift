//
//  FilePath.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 17.01.25.
//

import Foundation

typealias FilePath = URL

extension FilePath {

    var stringValue: String {
        return path()
    }

    init(_ path: String) {
        self.init(filePath: path)
    }
}

struct SnapshotFilePath: Equatable {

    var directoryURL: URL {
        return fileURL.deletingLastPathComponent()
    }

    let fileURL: URL
}
