# Changelog

<!--
Format: Keep a Changelog 2.0.0 (https://keepachangelog.com/en/2.0.0/).
Versioning: Semantic Versioning 2.0.0; covered surface defined in .docs/sdk/versioning-policy.md.
Rules (conventions/sdk-library):
- Place this file at the package/repo root as CHANGELOG.md.
- Add entries to [Unreleased] in the same PR as the change.
- Types, in this order only: Added, Changed, Deprecated, Removed, Fixed, Security. Omit empty types.
- One entry per user-visible change, written for the consumer. Use the API name in backticks.
- Breaking changes: prefix with **Breaking:**, say what breaks, link the migration guide.
- Deprecations: replacement + removal target.
- UI component libraries: append labels to entries: [visual-change], [a11y-impact].
- Dates: YYYY-MM-DD. Yanked releases stay listed with [YANKED].
Delete this comment block.
-->

All notable changes to this project are documented in this file. This project follows
[Semantic Versioning](https://semver.org/spec/v2.0.0.html); the covered API surface is
defined in the [versioning policy](.docs/sdk/versioning-policy.md).

## [Unreleased]

## [3.0.0] - 2026-10-20

### Added

- `Client.stream()` returns an async iterator over paged results.

### Changed

- **Breaking:** `RetryPolicy` now defaults to 5 attempts with jittered backoff (was 3,
  fixed delay). Callers relying on the old worst-case latency must set
  `maxAttempts: 3`. See [migration guide](.docs/sdk/migrations/v2-to-v3.md#retry-defaults).

### Removed

- **Breaking:** `Client.fetchPage()`, deprecated since 2.4.0. Use `Client.stream()`.
  See [migration guide](.docs/sdk/migrations/v2-to-v3.md#paging).
- **Breaking:** Support for Node.js 18 (end of life upstream).

## [2.4.0] - 2026-06-02

### Added

- `RetryPolicy.jitter` option (opt-in; becomes the default in 3.0.0).

### Deprecated

- `Client.fetchPage()`. Use `Client.stream()`. Removal in 3.0.0.

### Fixed

- `Client.get()` no longer drops the `Retry-After` header on 429 responses.
- `Button` focus ring meets 3:1 contrast. [visual-change] [a11y-impact]

## [2.3.2] - 2026-05-11 [YANKED]

### Fixed

- `Client.get()` timeout handling (yanked: broke proxies; superseded by 2.4.0).

[Unreleased]: https://github.com/org/sdk/compare/v3.0.0...HEAD
[3.0.0]: https://github.com/org/sdk/compare/v2.4.0...v3.0.0
[2.4.0]: https://github.com/org/sdk/compare/v2.3.2...v2.4.0
[2.3.2]: https://github.com/org/sdk/releases/tag/v2.3.2
