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

    func isDirectoryExisting(at directoryPath: FilePath) -> Bool {
        var isDir: ObjCBool = false
        let isExisting = fileExists(atPath: directoryPath.path(),
                   isDirectory: &isDir)
        return isExisting && isDir.boolValue
    }
    
    func createDirectory(at directoryPath: FilePath) {
        try? createDirectory(at: directoryPath,
                             withIntermediateDirectories: true)
    }
    
    func write(_ data: Data, to filePath: FilePath) throws {
        try data.write(to: filePath)
    }
}
