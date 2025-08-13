//
//  FileManagerTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 13.08.25.
//

import Testing

@testable import SimpleSnapshotTesting

struct FileManagerTests {

    @Test
    func should_find_file_with_spaces_in_path() async throws {
        let fileURL = try #require(TestFixtures.url(forResourceFileNamed: "file with spaces", withExtension: "txt"))

        let fileManager: FileManaging = .default

        #expect(fileManager.isFileExisting(at: fileURL))
    }

    @Test
    func should_find_directory_with_spaces_in_path() async throws {
        let dirURL = try #require(TestFixtures.url(forResourceDirectory: "folder with spaces"))

        let fileManager: FileManaging = .default

        #expect(fileManager.isDirectoryExisting(at: dirURL))
    }
}
