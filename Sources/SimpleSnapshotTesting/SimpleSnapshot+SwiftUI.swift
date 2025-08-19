//
//  SimpleSnapshot+SwiftUI.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 12.03.25.
//

import Testing

import SwiftUI

public enum EvaluationError: Swift.Error {
    case didRecordReference
    case notMatchingReference
}

@MainActor
public func evaluate<View: SwiftUI.View>(_ view: View,
                                   testTag: String = "",
                                   record: Bool = false,
                                   function: StaticString = #function,
                                   filePath: StaticString = #filePath,
                                   fileID: StaticString = #fileID,
                                   line: Int = #line,
                                   column: Int = #column) {
    switch evaluate(view,
                    record: record,
                    sourceLocation: SnapshotTestLocation(testFunction: function,
                                                         testFilePath: filePath,
                                                         testFileID: fileID,
                                                         testTag: testTag)) {
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

@MainActor
func evaluate<View: SwiftUI.View>(_ view: View,
                                  record: Bool,
                                  sourceLocation: SnapshotTestLocation) -> Result<Void, any Error> {
    let manager = SnapshotManager(testLocation: sourceLocation)

    do {
        let takenSnapshot = try manager.makeSnapshot(view: view)

        if record {
            try manager.saveSnapshot(takenSnapshot)
            throw EvaluationError.didRecordReference
        }

        let referenceSnapshot = try manager.makeSnapshot(filePath: takenSnapshot.filePath)

        switch manager.compareSnapshot(takenSnapshot,
                                       with: referenceSnapshot) {
        case .matching:
            return .success(())
        case .different:
            let failureSnapshot = try manager.makeFailureSnapshot(taken: takenSnapshot,
                                                                  reference: referenceSnapshot)
            try manager.saveFailureSnapshot(failureSnapshot)

            throw EvaluationError.notMatchingReference
        }
    } catch {
        return .failure(error)
    }
}
