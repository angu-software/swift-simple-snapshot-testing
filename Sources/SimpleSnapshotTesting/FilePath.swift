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
        return path
    }

    init(_ path: String) {
        self.init(filePath: path)
    }

    mutating func removeLastSegment() {
        deleteLastPathComponent()
    }

    mutating func addSegment(_ segment: String) {
        append(path: segment)
    }

    mutating func addExtension(_ pathExtension: String) {
        appendPathExtension(pathExtension)
    }
}
