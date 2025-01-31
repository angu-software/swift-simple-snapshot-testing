//
//  SnapshotImageDouble.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 23.01.25.
//

import UIKit

@testable import SimpleSnapshotTesting

extension SnapshotImage {

    static func dummy() -> SnapshotImage {
        return fixture()
    }

    static func fixture(size: CGSize = CGSize(width: 100, height: 100),
                        scale: CGFloat = 1.0,
                        color: UIColor = .white) -> SnapshotImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: size,
                                               format: format)
        return renderer.image { ctx in
            color.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension SnapshotImageData {

    static func dummy() -> SnapshotImageData {
        return fixture()
    }

    static func fixture(size: CGSize = CGSize(width: 100, height: 100),
                        scale: CGFloat = 1.0,
                        color: UIColor = .white) -> SnapshotImageData {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: size,
                                               format: format)
        return renderer.pngData { ctx in
            color.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
        }
    }
}
