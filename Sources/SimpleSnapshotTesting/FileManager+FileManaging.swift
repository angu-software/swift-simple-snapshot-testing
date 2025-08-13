//
//  FileManager+FileManaging.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 23.01.25.
//

import Foundation

extension FileManaging where Self == Foundation.FileManager {
    static var `default`: Self {
        return Foundation.FileManager.default
    }
}

extension FileManager: FileManaging {

    // MARK: - FileManaging

    func isFileExisting(at fileURL: URL) -> Bool {
        var isDir: ObjCBool = false
        let isExisting = fileExists(atPath: fileURL.filePath,
                                    isDirectory: &isDir)
        return isExisting && !isDir.boolValue
    }

    func isDirectoryExisting(at directoryURL: URL) -> Bool {
        var isDir: ObjCBool = false
        let isExisting = fileExists(atPath: directoryURL.filePath,
                   isDirectory: &isDir)
        return isExisting && isDir.boolValue
    }
    
    func createDirectory(at directoryURL: URL) throws {
        try createDirectory(at: directoryURL,
                            withIntermediateDirectories: true)
    }
    
    func write(_ data: Data, to fileURL: URL) throws {
        try data.write(to: fileURL)
    }

    func load(contentsOf fileURL: URL) throws -> Data {
        return try Data(contentsOf: fileURL,
                        options: .uncached)
    }
}

extension URL {

    fileprivate var filePath: String {
        return path(percentEncoded: false)
    }
}
