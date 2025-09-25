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
         recordingScale: @autoclosure @MainActor () -> CGFloat = UIScreen.main.scale,
         matchingPrecision: Double,
         sourceLocation: SnapshotTestLocation,
         fileManager: FileManaging = .default) {
        self.isRecordingReference = isRecordingReference || SnapshotGlobalConfig.isRecordingReference
        self.sourceLocation = sourceLocation
        self.precision = matchingPrecision

        self.manager = SnapshotManager(testLocation: sourceLocation,
                                       fileManager: fileManager,
                                       recordingScale: recordingScale())
    }

    func evaluate<View: SwiftUI.View>(_ view: View) -> Result<Void, any Error> {
        do {
            try evaluateSnapshot(try snapshot(for: view))
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    @MainActor
    func evaluate<View: UIView>(_ view: View) -> Result<Void, any Error> {
        do {
            try evaluateSnapshot(try snapshot(for: view))
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    private func snapshot<View: SwiftUI.View>(for view: View) throws -> Snapshot {
        return try manager.snapshot(from: view)
    }

    private func snapshot(for view: UIView) throws -> Snapshot {
        return try manager.snapshot(from: view)
    }

    private func evaluateSnapshot(_ takenSnapshot: Snapshot) throws {
        if isRecordingReference {
            try recordReferenceSnapshot(takenSnapshot)
        } else {
            try evaluateSnapshot(takenSnapshot,
                                 withReferenceSnapshot: try referenceSnapshot(for: takenSnapshot))
        }
    }

    private func recordReferenceSnapshot(_ takenSnapshot: Snapshot) throws {
        try manager.saveSnapshot(takenSnapshot)
        throw EvaluationError.didRecordReferenceSnapshot
    }

    private func referenceSnapshot(for snapshot: Snapshot) throws -> Snapshot {
        do {
            return try manager.referenceSnapshot(from: snapshot.filePath)
        } catch {
            throw EvaluationError.noReferenceSnapshotFound
        }
    }

    private func evaluateSnapshot(_ takenSnapshot: Snapshot, withReferenceSnapshot referenceSnapshot: Snapshot) throws {
        switch compare(takenSnapshot, with: referenceSnapshot) {
            case .matching:
                return
            case .different:
                try recordFailure(takenSnapshot, referenceSnapshot)
                throw EvaluationError.snapshotNotMatchingReference
        }
    }

    private func compare(_ snapshot: Snapshot, with reference: Snapshot) -> SnapshotComparisonResult {
        return manager.compareSnapshot(snapshot,
                                       with: reference,
                                       precision: precision)
    }

    private func recordFailure(_ takenSnapshot: Snapshot, _ referenceSnapshot: Snapshot) throws {
        let failureSnapshot = try manager.makeFailureSnapshot(taken: takenSnapshot,
                                                              reference: referenceSnapshot)
        try manager.saveFailureSnapshot(failureSnapshot)
    }
}
