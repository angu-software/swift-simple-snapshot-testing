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

    static func fixture(imageData: NormalizedImageData = .fixture(),
                        filePath: SnapshotFilePath = .dummy()) -> Self {
        Self(imageData: imageData,
             filePath: filePath)
    }
}
