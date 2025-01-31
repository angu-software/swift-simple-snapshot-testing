//
//  SnapshotDouble.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 31.01.25.
//

import Foundation

@testable import SimpleSnapshotTesting

extension Snapshot {

    static var dummy: Self {
        return fixture()
    }

    static func fixture(imageData: SnapshotImageData = .fixture(scale: 1),
                        scale: CGFloat = 1,
                        imageFilePath: FilePath = .dummy()) -> Self {
        Self(imageData: imageData,
             scale: scale,
             imageFilePath: imageFilePath)
    }
}
