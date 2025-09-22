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
        #expect(Data([1, 1]).countDifferences(to: Data([1, 1])) == 0)
    }

    @Test
    func whenDataIsDifferent_itReturnsTheAmountOfDifferentBytes() async throws {
        #expect(Data([1, 2, 1]).countDifferences(to: Data([1, 1, 4])) == 2)
    }

    @Test
    func whenDataIsDifferentInSizeAndContent_itReturnsTheAmountOfDifferentBytes() async throws {
        #expect(Data([1, 2, 1]).countDifferences(to: Data([1, 1, 4, 1])) == 3)
    }
}

extension Data {

    func countDifferences(to other: Data) -> Int {
        let lengthDifference = abs(count - other.count)

        let differingBytes = zip(self, other).reduce(0) { count, pair in
            count + (pair.0 == pair.1 ? 0 : 1)
        }

        return differingBytes + lengthDifference
    }
}

struct DataComparisonTests {

    @Test
    func whenDataIsEqual_itReturnsTrue() {
        let data1 = Data([1])
        let data2 = Data([1])

        #expect(data1.matches(data2, precision: 1.0))
    }

    @Test
    func whenDataIsDiffersWithinPrecision_itReturnsTrue() {
        let data1 = Data([1, 2])
        let data2 = Data([1, 1])

        #expect(data1.matches(data2, precision: 0.5))
    }

    @Test
    func whenDataIsDiffersBeyondPrecision_itReturnsFalse() {
        let data1 = Data([1, 2, 2, 2])
        let data2 = Data([1, 1, 1, 1])

        #expect(data1.matches(data2, precision: 0.5) == false)
    }

    @Test
    func whenDataIsDifferentInSize_itReturnsFalse() {
        let data1 = Data([1, 2, 2, 2])
        let data2 = Data([1, 1])

        #expect(data1.matches(data2, precision: 0.0) == false)
    }
}

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
