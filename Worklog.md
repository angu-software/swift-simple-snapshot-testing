# Work Log

## In Progress

- [ ] should create ref image when view image is set as reference

## Backlog

- [ ] snapshot name from test function with parameters
- [ ] Image (snapshot) renderer type that can handle different platforms (iOS, MacOS, ...)

### PublicAPI Acceptance tests

- [ ] should fail when ref image not found
- [ ] should succeed when ref image and view image is equal
- [ ] should fail when ref image and view image is different
- [ ] should create diff image set when ref image and view image is different

## Done

- [x] Use #fileID to construct snapshot folder for the respective tests
- [x] store recorded snapshot in repo
- [x] reliable root path for storing snapshot reference and diffs
- [x] load reference image (if exists)
- [x] compare viewSnapshot with reference snapshot
- [x] create a diff image
- [x] take the scale of the rendered/stored image into consideration
- [x] make and store FailureSnapshot containing diff, original and failed Snapshot
- [x] Ensure we always use png data
- [x] Base Snapshot on ImageData (Conformance to Equatable)
- [x] store diff image in repo
