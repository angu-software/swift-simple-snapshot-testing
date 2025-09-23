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
    func whenGivenPNGData_itConvertsToNormalizedImageData() async throws {
        let pngData = try #require(sourceImage.pngData())

        let normalized = try #require(NormalizedImageData.from(pngData: pngData))

        #expect(normalized == NormalizedImageData(data: Data([255, 0, 0, 255]),
                                                  width: 1,
                                                  height: 1))
    }
}
