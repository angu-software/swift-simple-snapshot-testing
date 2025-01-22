//
//  SnapshotTest.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

struct SnapshotTest: Equatable, Identifiable {

    // MARK: Identifiable

    var id: String {
        return [testName,
                testTag]
            .filter { !$0.isEmpty }
            .joined(separator: idSeparator)
    }

    var testName: String {
        return testFunction.replacingOccurrences(of: "()",
                                                 with: "")
    }

    let testFunction: String
    let testFilePath: String

    /// ID of the tests source file
    ///
    /// The structure of file IDs is described in the documentation for the [#fileID](https://developer.apple.com/documentation/swift/fileID()) macro in the Swift standard library.
    let testFileID: String
    let testFile: String
    let testTag: String

    private let idSeparator = "_"
}

extension SnapshotTest {

    /// [#fileID may become deprecated with Swift 6+](https://forums.swift.org/t/file-vs-fileid-in-swift-6/74614/4) in favor of #file
    /// See also [#file](https://developer.apple.com/documentation/swift/file())  macro overview.
    init(testFunction: StaticString = #function,
         testFilePath: StaticString = #filePath,
         testFileID: StaticString = #fileID,
         testFile: StaticString = #file,
         testTag: String = "") {
        self.init(testFunction: "\(testFunction)",
                  testFilePath: "\(testFilePath)",
                  testFileID: "\(testFileID)",
                  testFile: "\(testFile)",
                  testTag: testTag)
    }
}

