//
//  SnapshotFilePath.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

struct SnapshotFilePath: Equatable {

    let fileName: String
    private let testSourcePath: String
    private let fileExtension = "png"
    private let rootFolderName = "__Snapshots__"

    var basePath: FilePath {
        var filePath = FilePath("\(testSourcePath)")
        filePath.removeLastSegment()
        filePath.addSegment(rootFolderName)

        return filePath
    }

    var filePath: FilePath {
        var filePath = FilePath("\(testSourcePath)")
        filePath.removeLastSegment()
        filePath.addSegment("\(rootFolderName)/\(filePath.lastPathComponent)")
        filePath.addSegment(fileName)
        filePath.addExtension(fileExtension)

        return filePath
    }

    init(test: SnapshotTest) {
        self.fileName = test.id
        self.testSourcePath = "\(test.sourcePath)"
    }
}
