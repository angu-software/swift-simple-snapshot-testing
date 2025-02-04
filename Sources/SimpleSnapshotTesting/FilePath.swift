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

    let fileURL: URL
}

extension SnapshotFilePath {

    var fullPath: String {
        return fileURL.path()
    }

    init(fullPath: String) {
        self.init(fileURL: URL(filePath: fullPath))
    }
}
