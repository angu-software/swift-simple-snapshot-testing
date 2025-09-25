//
//  SimpleSnapshot+SwiftUI.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 12.03.25.
//

import SwiftUI
import Testing

@MainActor
public func evaluate<View: SwiftUI.View>(_ view: View,
                                         testTag: String = "",
                                         precision: Double = 1.0,
                                         record: Bool = false,
                                         function: StaticString = #function,
                                         filePath: StaticString = #filePath,
                                         sourceLocation: SourceLocation = #_sourceLocation) {
    let testLocation = SnapshotTestLocation(testFunction: "\(function)",
                                              testFilePath: "\(filePath)",
                                              testFileID: sourceLocation.fileID,
                                              testTag: testTag)

    let testCase = SnapshotTestCase(isRecordingReference: record,
                                    matchingPrecision: precision,
                                    sourceLocation: testLocation)
    let testResult = testCase.evaluate(view)

    switch testResult {
        case .success(()):
            break
        case let .failure(error):
            Issue.record(error,
                         "\(error.localizedDescription)",
                         sourceLocation: sourceLocation)
    }
}
