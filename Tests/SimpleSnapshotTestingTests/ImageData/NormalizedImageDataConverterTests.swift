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

        #expect(normalized == expectedNormalizedImageData())
    }

    @Test
    func whenGivenUIImage_itConvertsToNormalizedImageData() async throws {
        let normalized = try #require(converter.makeNormalizedImageData(from: imageFixture()))

        #expect(normalized == expectedNormalizedImageData())
    }

    @Test
    func whenGivenUIImage_whenImageIsScaled_itTakesImageScaleIntoAccount() async throws {
        let scale: CGFloat = 2
        let normalized = try #require(converter.makeNormalizedImageData(from: imageFixture(scale: scale)))

        #expect(normalized == expectedNormalizedImageData(scale: 2))
    }

    @Test
    func whenGivenAUIView_itConvertsToNormalizedImageData() async throws {
        let rectView = UIView(frame: CGRect(origin: .zero,
                                            size: CGSize(width: 1,
                                                         height: 1)))
        rectView.backgroundColor = .red

        let normalized = converter.makeNormalizedImageData(from: rectView, imageScale: 2)

        #expect(normalized == expectedNormalizedImageData(scale: 2))
    }

    @Test
    func whenGivenASwiftUIView_itConvertsToNormalizedImageData() async throws {
        let scale: CGFloat = 2
        let rectView = Rectangle()
            .fill(Color(red: 1, green: 0, blue: 0))
            .frame(width: 1, height: 1)

        let normalized = converter.makeNormalizedImageData(from: rectView, scale: scale)

        #expect(normalized == expectedNormalizedImageData(scale: scale))
    }

    // MARK: Test Support

    private func imageFixture(scale: CGFloat = 1) -> UIImage {
        return .fixture(size: CGSize(width: 1, height: 1),
                        scale: scale,
                        color: .red)
    }

    private func makeExpectedImageData(scale: CGFloat = 1) -> Data {
        let rgbaColorPixel: [UInt8] = [255, 0, 0, 255]

        let pixel = Array(repeating: rgbaColorPixel, count: Int(scale * scale)).flatMap { $0 }

        return Data(pixel)
    }

    private func expectedNormalizedImageData(scale: CGFloat = 1) -> NormalizedImageData {
        return NormalizedImageData(data: makeExpectedImageData(scale: scale),
                                   width: 1 * Int(scale),
                                   height: 1 * Int(scale))
    }
}
