//
//  Data+MatchingPrecision.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import Foundation

extension Data {

    func matches(_ other: Data, precision: Double) -> Bool {
        guard count == other.count else {
            return false
        }

        let byteCount = Double(count)
        let diffCount = Double(countDifferences(to: other))
        let matchingBytes = byteCount - diffCount

        return matchingBytes / byteCount >= precision
    }
}
