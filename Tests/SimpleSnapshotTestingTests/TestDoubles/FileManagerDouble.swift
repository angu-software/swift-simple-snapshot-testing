//
//  FileManagerDouble.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 23.01.25.
//

import Foundation

@testable import SimpleSnapshotTesting

final class FileManagerDouble: FileManaging {

    typealias Path = String

    var shouldThrowError = false
    private(set) var createdDirectories: [Path] = []
    private(set) var writtenData: [Path: Data] = [:]

    // MARK: - FileManaging

    func isDirectoryExisting(at directoryPath: FilePath) -> Bool {
        return false
    }

    func createDirectory(at directoryPath: SimpleSnapshotTesting.FilePath) {
        createdDirectories.append(directoryPath.path())
    }

    func write(_ data: Data, to filePath: FilePath) throws {
        if shouldThrowError {
            throw .dummy()
        }
        writtenData[filePath.path()] = data
    }
}
