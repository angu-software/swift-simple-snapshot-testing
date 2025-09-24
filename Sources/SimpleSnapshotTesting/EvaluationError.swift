//
//  EvaluationError.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 19.08.25.
//

import Foundation

public enum EvaluationError: Swift.Error {
    case didRecordReference
    case notMatchingReference // TODO: rename Snapshot did not match reference
}
