//
//  SnapshotTestLocationDouble.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

@testable import SimpleSnapshotTesting

extension SnapshotTestLocation {

    static func fixture(testFunction: StaticString = #function,
                        testFilePath: StaticString = #filePath,
                        testFileID: StaticString = #fileID,
                        testTag: String = "",
                        device: SnapshotDevice = .dummy) -> Self {
        return Self(testFunction: testFunction,
                    testFilePath: testFilePath,
                    testFileID: testFileID,
                    testTag: testTag,
                    device: device)
    }
}

extension SnapshotDevice {

    static var dummy: Self {
        return fixture()
    }

    static func fixture() -> Self {
        return Self(name: "iPhone 16",
                    osName: "iOS",
                    osVersion: "18.4")
    }
}
