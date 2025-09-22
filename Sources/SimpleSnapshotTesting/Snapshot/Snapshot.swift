//
//  Snapshot.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 31.12.24.
//

import SwiftUI

typealias SnapshotImageData = Data

struct Snapshot: Equatable {

    let imageData: SnapshotImageData
    let scale: CGFloat
    let filePath: SnapshotFilePath
}

extension Snapshot {

    func matches(_ other: Self, precision: Double) -> Bool {
        return imageData.matches(other.imageData, precision: precision)
    }
}
