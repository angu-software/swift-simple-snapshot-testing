//
//  SimpleSnapshot.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 12.03.25.
//

import SwiftUI

enum EvaluationError: Swift.Error {
    case didRecordReference
    case notMatchingReference
}

@MainActor
func evaluate<View: SwiftUI.View>(_ view: View,
                                  testTag: String = "",
                                  record: Bool = false,
                                  function: StaticString = #function,
                                  filePath: StaticString = #filePath,
                                  fileID: StaticString = #fileID) -> Result<Void, any Error> {
    return evaluate(view,
                    record: record,
                    sourceLocation: SnapshotTestLocation(testFunction: function,
                                                         testFilePath: filePath,
                                                         testFileID: fileID,
                                                         testTag: testTag))
}

@MainActor
func evaluate<View: SwiftUI.View>(_ view: View, record: Bool, sourceLocation: SnapshotTestLocation) -> Result<Void, any Error> {
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
