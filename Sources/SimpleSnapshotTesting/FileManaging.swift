//
//  FileManaging.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 23.01.25.
//

import Foundation
import UIKit

protocol FileManaging {
    func isDirectoryExisting(at directoryURL: URL) -> Bool
    func createDirectory(at directoryURL: URL) throws
    func write(_ data: Data, to fileURL: URL) throws
    func isFileExisting(at fileURL: URL) -> Bool
    func load(contentsOf fileURL: URL) throws -> Data
}
