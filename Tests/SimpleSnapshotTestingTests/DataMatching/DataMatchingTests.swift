//
//  DataMatchingTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import Foundation
import Testing

@testable import SimpleSnapshotTesting

struct DataMatchingTests {

    @Test
    func whenDataIsEqual_itReturnsTrue() {
        let data1 = Data([1])
        let data2 = Data([1])

        #expect(data1.isMatching(data2, precision: 1.0))
    }

    @Test
    func whenDataIsDiffersWithinPrecision_itReturnsTrue() {
        let data1 = Data([1, 2])
        let data2 = Data([1, 1])

        #expect(data1.isMatching(data2, precision: 0.5))
    }

    @Test
    func whenDataIsDiffersBeyondPrecision_itReturnsFalse() {
        let data1 = Data([1, 2, 2, 2])
        let data2 = Data([1, 1, 1, 1])

        #expect(data1.isMatching(data2, precision: 0.5) == false)
    }

    @Test
    func whenDataIsDifferentInSize_itReturnsFalse() {
        let data1 = Data([1, 2, 2, 2])
        let data2 = Data([1, 1])

        #expect(data1.isMatching(data2, precision: 0.0) == false)
    }
}
