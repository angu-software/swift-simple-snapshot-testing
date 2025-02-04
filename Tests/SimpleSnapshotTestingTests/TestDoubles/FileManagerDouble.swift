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

    func isFileExisting(at fileURL: URL) -> Bool {
        stubbedFileData.keys.contains(fileURL.path())
    }

    func isDirectoryExisting(at directoryURL: URL) -> Bool {
        return false
    }

    func createDirectory(at directoryURL: URL) throws {
        if shouldThrowCreateDirError {
            throw .dummy()
        }
        createdDirectories.append(directoryURL.path())
    }

    func write(_ data: Data, to fileURL: URL) throws {
        if shouldThrowWriteFileError {
            throw .dummy()
        }
        writtenData[fileURL.path()] = data
    }

    func load(contentsOf fileURL: URL) throws -> Data {
        return stubbedFileData[fileURL.path()] ?? Data()
    }
}
