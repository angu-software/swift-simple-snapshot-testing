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

    func isFileExisting(at filePath: FilePath) -> Bool {
        var isDir: ObjCBool = false
        let isExisting = fileExists(atPath: filePath.stringValue,
                                    isDirectory: &isDir)
        return isExisting && !isDir.boolValue
    }

    func isDirectoryExisting(at directoryPath: FilePath) -> Bool {
        var isDir: ObjCBool = false
        let isExisting = fileExists(atPath: directoryPath.stringValue,
                   isDirectory: &isDir)
        return isExisting && isDir.boolValue
    }
    
    func createDirectory(at directoryPath: FilePath) throws {
        try createDirectory(at: directoryPath,
                            withIntermediateDirectories: true)
    }
    
    func write(_ data: Data, to filePath: FilePath) throws {
        try data.write(to: filePath)
    }

    func load(contentsOf file: FilePath) throws -> Data {
        return try Data(contentsOf: file,
                        options: .uncached)
    }
}
