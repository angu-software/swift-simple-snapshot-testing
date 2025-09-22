//
//  Data+DifferenceCount.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import Foundation

extension Data {

    func countDifferences(to other: Data) -> Int {
        let lengthDifference = abs(count - other.count)

        let differingBytes = zip(self, other).reduce(0) { count, pair in
            count + (pair.0 == pair.1 ? 0 : 1)
        }

        return differingBytes + lengthDifference
    }
}
