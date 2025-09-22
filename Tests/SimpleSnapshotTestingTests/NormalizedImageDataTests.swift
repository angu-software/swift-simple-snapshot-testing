//
//  NormalizedImageDataTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import Foundation
import Testing
import UIKit

@testable import SimpleSnapshotTesting

struct NormalizedImageDataTests {

    @Test
    func whenCreatingFromSolidColorImage_itHasExpectedBytes() async throws {
        let cgImage = try #require(UIImage.fixture(size: CGSize(width: 1, height: 1),
                                                   scale: 1,
                                                   color: .red)
            .cgImage)

        let normalized = NormalizedImageData.from(cgImage: cgImage)

        let expected = Data([255, 0, 0, 255])
        #expect(normalized.data == expected)
    }
}
