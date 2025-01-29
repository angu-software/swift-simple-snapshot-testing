//
//  FileManaging.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 23.01.25.
//

import Foundation

protocol FileManaging {
    func isDirectoryExisting(at directoryPath: FilePath) -> Bool
    func createDirectory(at directoryPath: FilePath) throws
    func write(_ data: Data, to filePath: FilePath) throws
    func isFileExisting(at filePath: FilePath) -> Bool
    func load(contentsOf file: FilePath) throws -> Data
}
