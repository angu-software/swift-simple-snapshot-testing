//
//  Snapshot+SnapshotFilePath.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 22.09.25.
//


extension Snapshot {

    func with(filePath: SnapshotFilePath) -> Self {
        return Self(imageData: imageData,
                    filePath: filePath)
    }
}
