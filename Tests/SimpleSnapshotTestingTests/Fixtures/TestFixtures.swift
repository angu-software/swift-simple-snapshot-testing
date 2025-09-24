//
//  TestFixtures.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 31.01.25.
//

import Foundation
import UIKit

@testable import SimpleSnapshotTesting

enum TestFixtures {

    static func image(named fileName: String) -> UIImage? {
        guard let url = Bundle.module.url(forResource: fileName, withExtension: "png"),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data, scale: DiffImageFactory.defaultImageScale) else {
            return nil
        }

        return image
    }

    static func url(forResourceFileNamed fileName: String, withExtension fileExtension: String?) -> URL? {
        return Bundle.module.url(forResource: fileName, withExtension: fileExtension)
    }

    static func url(forResourceDirectory dirName: String) -> URL? {
        return Bundle.module.resourceURL?.appending(component: dirName)
    }
}
