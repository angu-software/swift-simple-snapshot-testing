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
        let data1 = NormalizedImageData.fixture(imageData: makeImageDataFixture())

        #expect(data1.isMatching(data1, precession: 1.0))
    }

    @Test
    func whenDataIsEqual_whenBufferInfoDiffers_itDoesNotMatch() async throws {
        let imageData = makeImageDataFixture()
        let data1 = NormalizedImageData.fixture(imageData: imageData)
        let data2 = NormalizedImageData.fixture(imageData: imageData,
                                                height: 2)

        #expect(data1.isMatching(data2, precession: 0.0) == false)
    }

    @Test
    @MainActor
    func whenDataHasDifferentScale_itDoesNotMatch() async throws {
        let data1 = try #require(NormalizedImageData.fixture(uiImage: .fixture(scale: 1)))
        let data2 = try #require(NormalizedImageData.fixture(uiImage: .fixture(scale: 2)))

        #expect(data1.isMatching(data2, precession: 0.0) == false)
    }

    private func makeImageDataFixture() -> Data {
        return Data([0, 255, 0, 255])
    }
}

import UIKit

extension NormalizedImageData {

    static func fixture(imageData: Data,
                        width: Int = 1,
                        height: Int = 1) -> Self {
        return NormalizedImageData(data: imageData,
                                   pixelBufferInfo: PixelBufferInfo(width: width,
                                                                    height: height))
    }

    @MainActor
    static func fixture(uiImage: UIImage) -> Self? {
        return NormalizedImageDataConverter().makeNormalizedImageData(from: uiImage)
    }
}

extension NormalizedImageData {

    func isMatching(_ other: Self, precession: Double) -> Bool {
        guard pixelBufferInfo == other.pixelBufferInfo else {
            return false
        }

        return data.isMatching(other.data,
                               precision: precession)
    }
}
