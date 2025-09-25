//
//  EvaluationError.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 19.08.25.
//

import Foundation

// Rename EvaluationResult
public enum EvaluationError: Swift.Error {
    case didRecordReferenceSnapshot
    case noReferenceSnapshotFound
    case snapshotNotMatchingReference
}
