# Work Log

## In Progress

- [ ] create a diff image

## Backlog

- [ ] take the scale of the rendered/stored image into consideration
- [ ] snapshot name from test function with parameters
- [ ] store diff image in repo
- [ ] fail test viewSnapshot is not matching reference snapshot
- [ ] Image (snapshot) renderer type that can handle different platforms (iOS, MacOS, ...)
- [ ] Config to define stored/compared image format

### PublicAPI Acceptance tests

- [ ] should fail when ref image not found
- [ ] should succeed when ref image and view image is equal
- [ ] should fail when ref image and view image is different
- [ ] should create ref image when view image is set as reference
- [ ] should create diff image set when ref image and view image is different

## Done

- [x] Use #fileID to construct snapshot folder for the respective tests
- [x] store recorded snapshot in repo
- [x] reliable root path for storing snapshot reference and diffs
- [x] load reference image (if exists)
- [x] compare viewSnapshot with reference snapshot

