//
//  FilePathDouble.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 29.01.25.
//

import Foundation

@testable import SimpleSnapshotTesting

extension FilePath {

    static func dummy() -> Self {
        return Self(filePath: "/foo/bar/file.png")
    }
}

extension SnapshotFilePath {

    static func dummy() -> Self {
        return Self(fullPath: "/foo/bar/file.png")
    }

    var directoryPath: String {
        return directoryURL.path()
    }

    var fullPath: String {
        return fileURL.path()
    }

    private init(fullPath: String) {
        self.init(fileURL: URL(filePath: fullPath))
    }
}
