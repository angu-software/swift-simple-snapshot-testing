//
//  UIImage+Double.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 23.01.25.
//

import UIKit

@testable import SimpleSnapshotTesting

extension UIImage {

    static func fixture(size: CGSize = CGSize(width: 100, height: 100),
                        scale: CGFloat = 1.0,
                        color: UIColor = .white) -> UIImage {
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
