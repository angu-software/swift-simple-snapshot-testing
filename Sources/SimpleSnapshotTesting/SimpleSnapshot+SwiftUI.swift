//
//  SimpleSnapshot+SwiftUI.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 12.03.25.
//

import SwiftUI
import Testing

// TODO: inject SwiftTesting #_sourceLocation here as this method is build for this framework as it reports an issue
@MainActor
public func evaluate<View: SwiftUI.View>(_ view: View,
                                         testTag: String = "",
                                         precision: Double = 1.0,
                                         record: Bool = false,
                                         function: StaticString = #function,
                                         filePath: StaticString = #filePath,
                                         fileID: StaticString = #fileID,
                                         line: Int = #line,
                                         column: Int = #column) {

    let sourceLocation = SnapshotTestLocation(testFunction: function,
                                         testFilePath: filePath,
                                         testFileID: fileID,
                                         testTag: testTag)

    let testCase = SnapshotTestCase(isRecordingReference: record,
                                    sourceLocation: sourceLocation,
                                    precision: precision)
    let testResult = testCase.evaluate(view)

    switch testResult {
        case .success(()):
            break
        case let .failure(error):
            Issue.record(error,
                         "\(error.localizedDescription)",
                         sourceLocation: SourceLocation(fileID: "\(fileID)",
                                                        filePath: "\(filePath)",
                                                        line: line,
                                                        column: column))
    }
}


