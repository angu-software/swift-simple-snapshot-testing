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

    static func url(forResourceFileNamed fileName: String, withExtension fileExtension: String?) -> URL? {
        return Bundle.module.url(forResource: fileName, withExtension: fileExtension)
    }

    static func url(forResourceDirectory dirName: String) -> URL? {
        return Bundle.module.resourceURL?.appending(component: dirName)
    }
}
