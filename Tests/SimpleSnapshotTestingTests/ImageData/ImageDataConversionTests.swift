//
//  Test.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import Testing
import UIKit

@testable import SimpleSnapshotTesting

struct ImageDataConversionTests {

    private let sourceImage = UIImage.fixture(size: CGSize(width: 1, height: 1),
                                              scale: 1,
                                              color: .red)

    @Test
    func whenGivenNormalizedImageData_itConvertsToPNGDataAndBack() async throws {
        let normalized = NormalizedImageData(data: Data([255, 0, 0, 255]),
                                             width: 1,
                                             height: 1)

        // When
        let pngData = try #require(normalized.pngData())

        // Then
        // 1. Should not be empty
        #expect(!pngData.isEmpty)

        // 2. Decoding back to normalized should match original
        let decoded = try #require(NormalizedImageData.from(pngData: pngData))
        #expect(decoded.data == normalized.data)

        let image = UIImage(data: pngData)
        #expect(image != nil)
    }

    @Test
    func whenGivenPNGData_itConvertsToNormalizedImageData() async throws {
        let pngData = try #require(sourceImage.pngData())

        let normalized = try #require(NormalizedImageData.from(pngData: pngData))

        #expect(normalized == NormalizedImageData(data: Data([255, 0, 0, 255]),
                                                  width: 1,
                                                  height: 1))
    }
}
