//
//  FileManaging.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 23.01.25.
//

import Foundation

protocol FileManaging {
    func isDirectoryExisting(at directoryPath: FilePath) -> Bool
    func createDirectory(at directoryPath: FilePath)
    func write(_ data: Data, to filePath: FilePath) throws
}
