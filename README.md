# SimpleSnapshotTesting

Snapshot and tests your views

## Goals

* Simple usage
* Only diff image on disc
* Concise
* Fast
* ~~Device agnostic; decoupled from running simulator device~~

## Planed features

* ~~By default record in current device scale~~
* Global configuration settings using ENV
* GlobalConfig to delete all ref images (before recording them again)
* ~~Better error message reporting~~
* Provide additional information about the test in the error reporting
* Grouping Reference images per device/os
* Make public API for XCTest.Issue (may include snapshot images)
