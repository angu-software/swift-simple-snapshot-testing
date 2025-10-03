//
//  SimpleSnapshot+UIKit.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 12.03.25.
//

import Testing
import UIKit

@MainActor
public func evaluate<View: UIView>(_ view: View,
                                   testTag: String = "",
                                   precision: Double = 1.0,
                                   record: Bool = false,
                                   function: StaticString = #function,
                                   filePath: StaticString = #filePath,
                                   sourceLocation: SourceLocation = #_sourceLocation) {

    let testLocation = SnapshotTestLocation(testFunction: "\(function)",
                                            testFilePath: "\(filePath)",
                                            testFileID: sourceLocation.fileID,
                                            testTag: testTag,
                                            device: .current)

    let testCase = SnapshotTestCase(isRecordingReference: record,
                                    matchingPrecision: precision,
                                    sourceLocation: testLocation)
    handleResult(testCase.evaluate(view),
           sourceLocation: sourceLocation)
}

func handleResult(_ result: Result<Void, any Error>, sourceLocation: SourceLocation) {
    switch result {
        case .success(()):
            break
        case let .failure(error):
            Issue.record(error,
                         sourceLocation: sourceLocation)
    }
}
