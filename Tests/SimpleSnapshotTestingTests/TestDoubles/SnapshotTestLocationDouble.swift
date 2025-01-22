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
                        testTag: String = "") -> Self {
        return Self(testFunction: testFunction,
                    testFilePath: testFilePath,
                    testFileID: testFileID,
                    testTag: testTag)
    }
}
