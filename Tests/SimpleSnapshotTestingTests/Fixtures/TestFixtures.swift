//
//  TestFixtures.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 31.01.25.
//

import Foundation
import UIKit

enum TestFixtures {

    static func image(named fileName: String) -> UIImage? {
        return UIImage(named: fileName,
                       in: .module,
                       with: nil)
    }
}
