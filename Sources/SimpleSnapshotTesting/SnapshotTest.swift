//
//  SnapshotTest.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

struct SnapshotTest {

    var id: String {
        return [name,
                tag]
            .filter { !$0.isEmpty }
            .joined(separator: idSeparator)
    }

    var name: String {
        return "\(methodSignature)".replacingOccurrences(of: "()",
                                                         with: "")
    }

    let methodSignature: StaticString
    let sourcePath: StaticString
    let tag: String

    private let idSeparator = "_"
}
