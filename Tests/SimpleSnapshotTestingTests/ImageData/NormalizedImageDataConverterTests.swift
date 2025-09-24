//
//  Test.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//

import SwiftUI
import Testing
import UIKit

@testable import SimpleSnapshotTesting

@MainActor
struct NormalizedImageDataConverterTests {

    private let converter = NormalizedImageDataConverter()

    @Test
    func whenGivenNormalizedImageData_itConvertsToPNGDataAndBack() async throws {
        let normalized = NormalizedImageData(data: Data([255, 0, 0, 255]),
                                             width: 1,
                                             height: 1)

        let pngData = try #require(converter.makePNGData(from: normalized))

        let decoded = try #require(converter.makeNormalizedImageData(from: pngData))
        #expect(decoded == normalized)
    }

    @Test
    func whenGivenPNGData_itConvertsToNormalizedImageData() async throws {
        let pngData = try #require(imageFixture().pngData())

        let normalized = try #require(converter.makeNormalizedImageData(from: pngData))

        #expect(normalized == NormalizedImageData(data: Data([255, 0, 0, 255]),
                                                  width: 1,
                                                  height: 1))
    }

    @Test
    func whenGivenUIImage_itConvertsToNormalizedImageData() async throws {
        let normalized = try #require(converter.makeNormalizedImageData(from: imageFixture()))

        #expect(normalized == NormalizedImageData(data: Data([255, 0, 0, 255]),
                                                  width: 1,
                                                  height: 1))
    }

    // Comparing 1x with 2x image should not be equal
    @Test
    func whenGivenUIImage_whenImageIsScaled_itConvertsToNormalizedImageData() async throws {
        let normalized = try #require(converter.makeNormalizedImageData(from: imageFixture(scale: 3)))

        #expect(normalized == NormalizedImageData(data: Data([255, 0, 0, 255]),
                                                  width: 1,
                                                  height: 1))
    }

    @Test
    func whenGivenAUIView_itConvertsToNormalizedImageData() async throws {
        let rectView = UIView(frame: CGRect(origin: .zero,
                                            size: CGSize(width: 1,
                                                         height: 1)))
        rectView.backgroundColor = .red

        let normalized = converter.makeNormalizedImageData(from: rectView)

        #expect(normalized == NormalizedImageData(data: Data([255, 0, 0, 255]),
                                                  width: 1,
                                                  height: 1))
    }

    @Test
    func whenGivenASwiftUIView_itConvertsToNormalizedImageData() async throws {
        let rectView = Rectangle()
            .fill(Color(red: 1, green: 0, blue: 0))
            .frame(width: 1, height: 1)

        let normalized = converter.makeNormalizedImageData(from: rectView)

        #expect(normalized == NormalizedImageData(data: Data([255, 0, 0, 255]),
                                                  width: 1,
                                                  height: 1))
    }

    private func imageFixture(scale: CGFloat = 1) -> UIImage {
        return .fixture(size: CGSize(width: 1, height: 1),
                        scale: scale,
                        color: .red)
    }
}
