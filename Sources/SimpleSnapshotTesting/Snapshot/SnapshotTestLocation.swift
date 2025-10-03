//
//  SnapshotTestLocation.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

struct SnapshotDevice: Equatable, CustomStringConvertible {

    let name: String
    let osName: String
    let osVersion: String

    // MARK: - CustomStringConvertible

    var description: String {
        return [name,
                osName,
                osVersion]
            .joined(separator: " ")
    }
}

import UIKit

extension SnapshotDevice {

    static let current = Self(uiDevice: .current)

    init(uiDevice: UIDevice) {
        self.init(name: uiDevice.name,
                  osName: uiDevice.systemName,
                  osVersion: uiDevice.systemVersion)
    }
}

struct SnapshotTestLocation: Equatable {

    var testIdentifier: String {
        return [testFunction.replacingOccurrences(of: "()",
                                                  with: ""),
                testTag]
            .filter { !$0.isEmpty }
            .joined(separator: idSeparator)
    }

    var moduleName: String {
        return testFileID
            .components(separatedBy: "/")
            .first ?? ""
    }

    var fileName: String {
        return testFileID
            .components(separatedBy: "/")
            .last ?? ""
    }

    let testFunction: String
    let testFilePath: String

    /// ID of the tests source file
    ///
    /// The structure of file IDs is described in the documentation for the [#fileID](https://developer.apple.com/documentation/swift/fileID()) macro in the Swift standard library.
    let testFileID: String
    let testTag: String

    let device: SnapshotDevice

    private let idSeparator = "_"
}

extension SnapshotTestLocation {

    /// [#fileID may become deprecated with Swift 6+](https://forums.swift.org/t/file-vs-fileid-in-swift-6/74614/4) in favor of #file
    /// See also [#file](https://developer.apple.com/documentation/swift/file())  macro overview.
    init(testFunction: StaticString,
         testFilePath: StaticString,
         testFileID: StaticString,
         testTag: String = "",
         device: SnapshotDevice = .current) {
        self.init(testFunction: "\(testFunction)",
                  testFilePath: "\(testFilePath)",
                  testFileID: "\(testFileID)",
                  testTag: testTag,
                  device: device)
    }
}
