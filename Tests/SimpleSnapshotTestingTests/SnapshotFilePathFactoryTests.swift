//
//  SnapshotFilePathFactoryTests.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 22.01.25.
//

import Foundation
import Testing

@testable import SimpleSnapshotTesting

struct SnapshotFilePathFactoryTests {

    private let moduleName = "SimpleSnapshotTestingTests"
    private let testSourceFileName = "SnapshotFilePathFactoryTests"

    @Test(.tags(.acceptanceTest))
    func should_resolve_test_snapshot_reference_file() {
        let location = SnapshotTestLocation.fixture()
        let testName = location.testIdentifier

        let path = makePathFactory(testLocation: location)

        #expect(
            path.referenceSnapshotFilePath.fullPath
                .hasSuffix("swift-simple-snapshot-testing/Tests/\(moduleName)/__Snapshots__/iPhone-16-iOS-18.4/\(testSourceFileName)/\(testName)@2x.png")
        )
    }

    @Test
    func should_resolve_failure_diff_original_snapshot_file_path() {
        let location = SnapshotTestLocation.fixture()
        let testName = location.testIdentifier

        let path = makePathFactory(testLocation: location)

        #expect(
            path.failureOriginalSnapshotFilePath.fullPath
                .hasSuffix("swift-simple-snapshot-testing/Tests/\(moduleName)/__Snapshots__/iPhone-16-iOS-18.4/__FailureDiffs__/\(testSourceFileName)/ORIG_\(testName)@2x.png")
        )
    }

    @Test
    func should_resolve_failure_diff_failing_snapshot_file_path() {
        let location = SnapshotTestLocation.fixture()
        let testName = location.testIdentifier

        let path = makePathFactory(testLocation: location)

        #expect(
            path.failureFailedSnapshotFilePath.fullPath
                .hasSuffix("swift-simple-snapshot-testing/Tests/\(moduleName)/__Snapshots__/iPhone-16-iOS-18.4/__FailureDiffs__/\(testSourceFileName)/FAIL_\(testName)@2x.png")
        )
    }

    @Test
    func should_resolve_failure_diff_diffed_snapshot_file_path() {
        let location = SnapshotTestLocation.fixture()
        let testName = location.testIdentifier

        let path = makePathFactory(testLocation: location)

        #expect(
            path.failureDiffSnapshotFilePath.fullPath
                .hasSuffix("swift-simple-snapshot-testing/Tests/\(moduleName)/__Snapshots__/iPhone-16-iOS-18.4/__FailureDiffs__/\(testSourceFileName)/DIFF_\(testName)@2x.png")
        )
    }

    @Test
    func should_have_file_name_according_to_test_method_name() async throws {
        let path = makePathFactory(testLocation: .fixture())

        #expect(path.referenceSnapshotFilePath.fileName == "should_have_file_name_according_to_test_method_name@2x.png")
    }

    @Test
    func snapshot_should_append_identifier_to_filename_when_specified() async throws {
        let path = makePathFactory(testLocation: .fixture(testTag: "someIdentifier"))

        #expect(path.referenceSnapshotFilePath.fileName == "snapshot_should_append_identifier_to_filename_when_specified_someIdentifier@2x.png")
    }

    @Test
    func whenScaleIsOne_itOmitsTheScaleSuffixInTheFileName() {
        let path = makePathFactory(testLocation: .fixture(), scale: 1)

        #expect(path.referenceSnapshotFilePath.fileName == "whenScaleIsOne_itOmitsTheScaleSuffixInTheFileName.png")
    }

    private func makePathFactory(testLocation: SnapshotTestLocation,
                                 scale: CGFloat = 2) -> SnapshotFilePathFactory {
        SnapshotFilePathFactory(testLocation: testLocation,
                                deviceScale: scale)
    }
}

extension SnapshotFilePath {

    var fileName: String {
        return fileURL.lastPathComponent
    }
}
