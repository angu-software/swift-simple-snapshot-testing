//
//  SnapshotTestCase.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 24.09.25.
//

import Foundation
import SwiftUI
import UIKit

@MainActor
struct SnapshotTestCase {

    let isRecordingReference: Bool
    let sourceLocation: SnapshotTestLocation
    let precision: Double

    private let manager: SnapshotManager

    init(isRecordingReference: Bool,
         sourceLocation: SnapshotTestLocation,
         precision: Double ) {
        self.isRecordingReference = isRecordingReference
        self.sourceLocation = sourceLocation
        self.precision = precision

        self.manager = SnapshotManager(testLocation: sourceLocation)
    }

    func evaluate<View: SwiftUI.View>(_ view: View) -> Result<Void, any Error> {

        do {
            let takenSnapshot = try manager.snapshot(from: view)

            if isRecordingReference {
                try manager.saveSnapshot(takenSnapshot)
                throw EvaluationError.didRecordReference
            }

            let referenceSnapshot = try manager.referenceSnapshot(from: takenSnapshot.filePath)

            switch compare(takenSnapshot, with: referenceSnapshot) {
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

    @MainActor
    func evaluate<View: UIView>(_ view: View) -> Result<Void, any Error> {
        do {
            let takenSnapshot = try manager.snapshot(from: view)

            if isRecordingReference {
                try manager.saveSnapshot(takenSnapshot)
                throw EvaluationError.didRecordReference
            }

            let referenceSnapshot = try manager.referenceSnapshot(from: takenSnapshot.filePath)

            switch compare(takenSnapshot, with: referenceSnapshot) {
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

    private func compare(_ snapshot: Snapshot, with reference: Snapshot) -> SnapshotComparisonResult {
        return manager.compareSnapshot(snapshot,
                                       with: reference,
                                       precision: precision)
    }
}
