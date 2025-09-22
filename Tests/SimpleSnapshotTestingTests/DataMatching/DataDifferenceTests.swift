//
//  DataDifferenceTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import Foundation
import Testing

@testable import SimpleSnapshotTesting

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
