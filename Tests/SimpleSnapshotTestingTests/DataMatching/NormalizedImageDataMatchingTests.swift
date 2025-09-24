//
//  NormalizedImageDataMatchingTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 24.09.25.
//

import Foundation
import Testing

@testable import SimpleSnapshotTesting

struct NormalizedImageDataMatchingTests {

    @Test
    func whenNormalizedImageDataIsIdentical_itMatches() async throws {
        let data1 = NormalizedImageData.fixture()

        #expect(data1.isMatching(data1, precision: 1.0))
    }

    @Test
    func whenDataIsEqual_whenBufferInfoDiffers_itDoesNotMatch() async throws {
        let data1 = NormalizedImageData.fixture()
        let data2 = NormalizedImageData.fixture(size: CGSize(width: 1, height: 2))

        #expect(data1.isMatching(data2, precision: 0.0) == false)
    }

    @Test
    @MainActor
    func whenDataHasDifferentScale_itDoesNotMatch() async throws {
        let data1 = try #require(NormalizedImageData.fixture(uiImage: .fixture(scale: 1)))
        let data2 = try #require(NormalizedImageData.fixture(uiImage: .fixture(scale: 2)))

        #expect(data1.isMatching(data2, precision: 0.0) == false)
    }
}

import UIKit

extension NormalizedImageData {

    @MainActor
    static func fixture(uiImage: UIImage) -> Self? {
        return NormalizedImageDataConverter().makeNormalizedImageData(uiImage: uiImage)
    }
}
