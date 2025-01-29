//
//  FilePathDouble.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 29.01.25.
//

@testable import SimpleSnapshotTesting

extension FilePath {

    static func dummy() -> Self {
        return Self(filePath: "/foo/bar/file.png")
    }
}
