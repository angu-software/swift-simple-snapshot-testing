//
//  RectangleView.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 19.08.25.
//

import UIKit

final class RectangleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        if frame == .zero {
            self.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        }

        self.backgroundColor = .green
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
