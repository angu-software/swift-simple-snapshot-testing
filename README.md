# SimpleSnapshotTesting

Snapshot and tests your views

## Goals

* Simple usage
* Only diff image on disc
* Concise
* Fast
* ~~Device agnostic; decoupled from running simulator device~~

## Abstract refactoring plan

### Record

```text
SwiftUI View / UIKit View
        ↓ render
   CGImage / UIImage
        ↓ normalize (scale = 1, fixed color space, RGBA8)
NormalizedImageData
        ↓ persist
 Reference File (.png on disk)
 ```

### Compare

```text
SwiftUI View / UIKit View
        ↓ render
   CGImage / UIImage
        ↓ normalize
NormalizedImageData (candidate)
        ↓
Load Reference PNG
        ↓ decode
   CGImage
        ↓ normalize
NormalizedImageData (reference)
        ↓ compare
  Equal? -> ✅ pass
  Diff?  -> ❌ generate Diff Image → save as PNG for inspection
```
