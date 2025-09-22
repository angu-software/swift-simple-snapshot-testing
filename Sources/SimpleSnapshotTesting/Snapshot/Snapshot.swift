//
//  Snapshot.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 31.12.24.
//

import SwiftUI

typealias SnapshotImageData = Data

struct Snapshot: Equatable {

    let pngData: SnapshotImageData
    let scale: CGFloat
    let filePath: SnapshotFilePath
}

extension Snapshot {

    func matches(_ other: Self, precision: Double) -> Bool {
        return pngData.matches(other.pngData, precision: precision)
    }
}
