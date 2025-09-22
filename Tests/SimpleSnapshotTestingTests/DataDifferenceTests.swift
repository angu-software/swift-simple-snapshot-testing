//
//  DataDifferenceTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import Testing

import Foundation

struct DataDifferenceTests {

    @Test
    func whenDataIsEqual_itReturnZero() async throws {
        #expect(dataDifferenceCount(lhs: Data([1, 1]),
                                    rhs: Data([1, 1])) == 0)
    }

    @Test
    func whenDataIsDifferent_itReturnsTheAmountOfDifferentBytes() async throws {
        #expect(dataDifferenceCount(lhs: Data([1, 2, 1]),
                                    rhs: Data([1, 1, 4])) == 2)
    }

    @Test
    func whenDataIsDifferentInSizeAndContent_itReturnsTheAmountOfDifferentBytes() async throws {
        #expect(dataDifferenceCount(lhs: Data([1, 2, 1]),
                                    rhs: Data([1, 1, 4, 1])) == 3)
    }
}

func dataDifferenceCount(lhs: Data, rhs: Data) -> Int {
    let lengthDifference = abs(lhs.count - rhs.count)

    let differingBytes = zip(lhs, rhs).reduce(0) { count, pair in
        count + (pair.0 == pair.1 ? 0 : 1)
    }

    return differingBytes + lengthDifference
}
