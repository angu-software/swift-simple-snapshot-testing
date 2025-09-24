//
//  Snapshot+SnapshotFilePath.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//


extension Snapshot {

    func with(filePath: SnapshotFilePath) -> Self {
        return Self(pngData: pngData,
                    scale: scale,
                    filePath: filePath)!
    }
}
