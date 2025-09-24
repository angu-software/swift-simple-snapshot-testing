//
//  Test.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 24.09.25.
//

import Foundation
import Testing

@testable import SimpleSnapshotTesting

struct Test {

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

        #expect(data1.isMatching(data2, precession: 1.0) == false)
    }

    private func makeImageDataFixture() -> Data {
        return Data([255, 255, 255, 255])
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
