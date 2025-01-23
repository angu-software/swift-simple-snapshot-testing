# Work Log

## In Progress

## Backlog

- [ ] snapshot name from test function with parameters
- [ ] reliable root path for storing snapshot reference and diffs
- [ ] store recorded snapshot in repo
- [ ] load reference image (if exists)
- [ ] compare viewSnapshot with reference snapshot
- [ ] create a diff image
- [ ] store diff image in repo
- [ ] fail test viewSnapshot is not matching reference snapshot
- [ ] Image (snapshot) renderer type that can handle different platforms (iOS, MacOS, ...)

### PublicAPI

- [ ] should fail when ref image not found
- [ ] should succeed when ref image and view image is equal
- [ ] should fail when ref image and view image is different
- [ ] should create ref image when view image is set as reference
- [ ] should create diff image set when ref image and view image is different

## Done

- [x] Use #fileID to construct snapshot folder for the respective tests

