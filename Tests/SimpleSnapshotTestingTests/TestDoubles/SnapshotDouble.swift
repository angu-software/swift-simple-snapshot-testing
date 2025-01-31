//
//  SnapshotDouble.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 31.01.25.
//

@testable import SimpleSnapshotTesting

extension Snapshot {

    static var dummy: Self {
        return fixture(image: .dummy(),
                       imageFilePath: .dummy())
    }

    static func fixture(image: SnapshotImage = .fixture(),
                        imageFilePath: FilePath = .dummy()) -> Self {
        Self(image: image,
             imageFilePath: imageFilePath)
    }
}
