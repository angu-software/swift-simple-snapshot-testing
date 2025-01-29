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

    var shouldThrowCreateDirError = false
    var shouldThrowWriteFileError = false
    var stubbedFileData: [String: Data] = [:]
    private(set) var createdDirectories: [Path] = []
    private(set) var writtenData: [Path: Data] = [:]

    // MARK: - FileManaging

    func isDirectoryExisting(at directoryPath: FilePath) -> Bool {
        return false
    }

    func createDirectory(at directoryPath: SimpleSnapshotTesting.FilePath) throws {
        if shouldThrowCreateDirError {
            throw .dummy()
        }
        createdDirectories.append(directoryPath.path())
    }

    func write(_ data: Data, to filePath: FilePath) throws {
        if shouldThrowWriteFileError {
            throw .dummy()
        }
        writtenData[filePath.path()] = data
    }

    func load(contentsOf file: FilePath) throws -> Data {
        return stubbedFileData[file.path()] ?? Data()
    }
}
