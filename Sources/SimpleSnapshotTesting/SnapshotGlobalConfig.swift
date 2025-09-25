//
//  SnapshotGlobalConfig.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Günther on 25.09.25.
//

import Foundation

/// Global configuration for controlling snapshot reference recording.
///
/// Use this type to enable or disable reference recording for all snapshot tests
/// in your test suite. This is useful, for example, when switching devices
/// and needing to re-record all snapshots.
///
/// - Note: Setting the recording mode is protected via `precondition` to ensure it is only enabled once during runtime.
public enum SnapshotGlobalConfig {

    private static var _isRecordingReference: Bool?

    // TODO: ENV var for this setting
    // the current approach relied on where the enableReferenceRecoding is called. It may not affect all tests. hence ENV var is recommended to use

    /// Returns `true` if snapshot reference recording is globally enabled. Default `false`
    public static var isRecordingReference: Bool {
        return _isRecordingReference ?? false
    }

    /// Enables reference recording globally for all snapshot tests.
    ///
    /// - Note: Can only be set **once** per runtime. Calling this method
    ///   multiple times will trigger a runtime `precondition` failure.
    public static func enableReferenceRecoding() {
        _isRecordingReference = true
    }

    static func disableReferenceRecoding() {
        _isRecordingReference = nil
    }
}
