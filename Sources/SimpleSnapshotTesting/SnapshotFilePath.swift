//
//  SnapshotFilePath.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

struct SnapshotFilePath {

    let fileName: String
    private let testSourcePath: String
    private let fileExtension = "png"

    var filePath: FilePath {
        var filePath = FilePath("\(testSourcePath)")
        filePath.removeLastSegment()
        filePath.addSegment("__Snapshots__/\(filePath.lastPathComponent)")
        filePath.addSegment(fileName)
        filePath.addExtension(fileExtension)

        return filePath
    }

    init(test: SnapshotTest) {
        self.fileName = test.id
        self.testSourcePath = "\(test.sourcePath)"
    }
}
