//
//  ByteDifferenceTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import Testing

struct ByteDifferenceTests {

    @Test
    func whenBytesAreNotDifferent_itReturnZero() async throws {
        #expect(byteDifferenceCount(lhs: [1, 1],
                                     rhs: [1, 1]) == 0)
    }

    @Test
    func whenByteArraysAreDifferent_itReturnsTheAmountOfDifferentBytes() async throws {
        #expect(byteDifferenceCount(lhs: [1, 2, 1],
                                     rhs: [1, 1, 4]) == 2)
    }

    @Test
    func whenByteArraysAreDifferentInSize_itReturnsTheAmountOfDifferentBytes() async throws {
        #expect(byteDifferenceCount(lhs: [1, 2, 1],
                                     rhs: [1, 1, 4, 1]) == 3)
    }
}

func byteDifferenceCount(lhs: [UInt8], rhs: [UInt8]) -> Int {
    let sizeDiff = abs(lhs.count - rhs.count)

    return zip(lhs, rhs).reduce(into: sizeDiff) { diffCount, pair in
        if pair.0 != pair.1 {
            diffCount += 1
        }
    }
}
