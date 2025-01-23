//
//  ErrorDummy.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 23.01.25.
//

import Foundation

extension Error where Self == NSError {

    static func dummy() -> Error {
        return NSError(domain: "TestingDummy", code: 1)
    }
}
