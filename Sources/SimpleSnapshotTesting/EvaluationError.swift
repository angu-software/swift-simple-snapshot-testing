//
//  EvaluationError.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 19.08.25.
//

import Foundation

public enum EvaluationError: Swift.Error, CustomStringConvertible {
    case didRecordReferenceSnapshot
    case noReferenceSnapshotFound
    case snapshotNotMatchingReference

    public var description: String {
        switch self {
        case .didRecordReferenceSnapshot:
            return "Snapshot recorded! All future runs will compare against this reference."
        case .noReferenceSnapshotFound:
            return "No reference snapshot found! You might need to enable recording first."
        case .snapshotNotMatchingReference:
            return "Snapshot does not match its reference."
        }
    }
}
