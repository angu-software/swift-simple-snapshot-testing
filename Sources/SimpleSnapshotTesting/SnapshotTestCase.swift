//
//  SnapshotTestCase.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 24.09.25.
//

import Foundation
import SwiftUI
import UIKit

struct SnapshotTestCase {

    let isRecordingReference: Bool
    let sourceLocation: SnapshotTestLocation
    let precision: Double

    init(isRecordingReference: Bool,
         sourceLocation: SnapshotTestLocation,
         precision: Double ) {
        self.isRecordingReference = isRecordingReference
        self.sourceLocation = sourceLocation
        self.precision = precision
    }

    @MainActor
    func evaluate<View: SwiftUI.View>(_ view: View) -> Result<Void, any Error> {
        let manager = SnapshotManager(testLocation: sourceLocation)

        do {
            let takenSnapshot = try manager.snapshot(from: view)

            if isRecordingReference {
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
}
