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
                                  precision: Double = 1.0,
                                  record: Bool,
                                  sourceLocation: SnapshotTestLocation) -> Result<Void, any Error> {
    let manager = SnapshotManager(testLocation: sourceLocation)

    do {
        let takenSnapshot = try manager.snapshot(from: view)

        if record {
            try manager.saveSnapshot(takenSnapshot)
            throw EvaluationError.didRecordReference
        }

        let referenceSnapshot = try manager.referenceSnapshot(from: takenSnapshot.filePath)

        switch manager.compareSnapshot(takenSnapshot,
                                       with: referenceSnapshot,
                                       precision: precision) {
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
