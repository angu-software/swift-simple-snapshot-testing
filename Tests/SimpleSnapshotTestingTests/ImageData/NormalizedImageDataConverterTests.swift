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
        let pngData = try #require(converter.makePNGImageData(normalizedImageData: .fixture()))

        let decoded = try #require(converter.makeNormalizedImageData(pngImageData: pngData))
        #expect(decoded == .fixture())
    }

    @Test
    func whenGivenScaledPNGData_itConvertsToNormalizedImageData() async throws {
        let scale = 2
        let pngImageData = try #require(converter.makePNGImageData(normalizedImageData: .fixture(scale: scale)))

        let normalized = try #require(converter.makeNormalizedImageData(pngImageData: pngImageData))

        #expect(normalized == .fixture(scale: scale))
    }

    @Test
    func whenGivenScaledPNGData_itPreservesTheScaleInformation() async throws {
        let scale = 2
        let pngImageData = try #require(converter.makePNGImageData(normalizedImageData: .fixture(scale: scale)))

        let normalized = try #require(converter.makeNormalizedImageData(pngImageData: pngImageData))

        #expect(normalized.pixelBufferInfo.scale == scale)
    }

    @Test
    func whenGivenUIImage_itConvertsToNormalizedImageData() async throws {
        let normalized = try #require(converter.makeNormalizedImageData(uiImage: imageFixture()))

        #expect(normalized == .fixture())
    }

    @Test
    func whenGivenUIImage_whenImageIsScaled_itTakesImageScaleIntoAccount() async throws {
        let scale = 2
        let normalized = try #require(converter.makeNormalizedImageData(uiImage: imageFixture(scale: scale)))

        #expect(normalized == .fixture(scale: 2))
    }

    @Test
    func whenGivenUIView_itConvertsToNormalizedImageData() async throws {
        let rectView = UIView(frame: CGRect(origin: .zero,
                                            size: CGSize(width: 1,
                                                         height: 1)))
        rectView.backgroundColor = .red

        let normalized = converter.makeNormalizedImageData(view: rectView, scale: 2)

        #expect(normalized == .fixture(scale: 2))
    }

    @Test
    func whenGivenASwiftUIView_itConvertsToNormalizedImageData() async throws {
        let scale = 2
        let rectView = Rectangle()
            .fill(Color(red: 1, green: 0, blue: 0))
            .frame(width: 1, height: 1)

        let normalized = converter.makeNormalizedImageData(view: rectView, scale: scale)

        #expect(normalized == .fixture(scale: scale))
    }

    @Test
    func whenConvertingToUIView_itSizesUIImageCorrectly() async throws {
        let uiImage = try #require(converter.makeUIImage(normalizedImageData: .fixture(scale: 3)))

        #expect(uiImage.scale == 3)
        #expect(uiImage.size == CGSize(width: 1, height: 1))
    }

    // MARK: Test Support

    private func imageFixture(scale: Int = 1) -> UIImage {
        return .fixture(size: CGSize(width: 1, height: 1),
                        scale: CGFloat(scale),
                        color: .red)
    }
}
