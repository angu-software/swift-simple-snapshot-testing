//
//  SnapshotTest.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

struct SnapshotTest: Equatable, Identifiable {

    // MARK: Identifiable

    var id: String {
        return [name,
                tag]
            .filter { !$0.isEmpty }
            .joined(separator: idSeparator)
    }

    var name: String {
        return methodSignature.replacingOccurrences(of: "()",
                                                         with: "")
    }

    let methodSignature: String
    let sourcePath: String
    let tag: String

    private let idSeparator = "_"
}

extension SnapshotTest {

    init(methodSignature: StaticString = #function,
         sourcePath: StaticString = #filePath,
         tag: String = "") {
        self.init(methodSignature: "\(methodSignature)",
                  sourcePath: "\(sourcePath)",
                  tag: tag)
    }
}
