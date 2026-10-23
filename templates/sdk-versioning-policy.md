# <SDK name> versioning and support policy

<!--
The SDK's promise to consumers and the SDK profile agents load before classifying any
change (conventions/sdk-library §1). Location: .docs/sdk/versioning-policy.md; link it from
README.md and CHANGELOG.md. Values marked (ref) are reference values the engineer confirms.
Delete this comment.
-->

| Property | Value |
| --- | --- |
| **Audience** | `internal` / `public` |
| **Kind** | `library` / `ui-components` / `api-client` / `cli` |
| Packages | `<package>` |
| Owners | Team |
| Revision | rev 0 |
| Last reviewed | YYYY-MM-DD |

## 1. Versioning

[Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html): **MAJOR** breaking ·
**MINOR** compatible features and deprecations · **PATCH** compatible fixes.

- Tags `vX.Y.Z` (monorepo: `<pkg>/vX.Y.Z`); pre-releases `-alpha.N`, `-beta.N`, `-rc.N` carry no guarantee.
- Published versions are never modified; bad releases are yanked and superseded.

## 2. What is covered

| Surface | Covered | Notes |
| --- | --- | --- |
| Exported API in the API reference | Yes | Unless marked `experimental` / `internal` |
| Documented behavior and defaults | Yes | |
| Error types and codes | Yes | Messages are **not** covered |
| Wire formats, config keys, env vars | Yes | |
| Supported runtimes (section 4) | Yes | |
| `experimental` / `preview` | No | Changes are still listed in the changelog |
| Log text, debug output | No | |

<!-- ui-components only: keep these rows, delete otherwise -->

| UI surface | Covered | Notes |
| --- | --- | --- |
| Props, events, slots, subcomponents | Yes | |
| States, keyboard and focus behavior, ARIA | Yes | WCAG defect fixes may ship as PATCH (`a11y-impact`) |
| Published class names, `data-*`, `::part`, CSS variables, tokens | Yes | Listed in `<link>` |
| Visual output | By impact | Minor tweaks PATCH/MINOR with `visual-change`; layout/hierarchy breaks and token output changes MAJOR |
| Undocumented DOM structure | **No** | Pin the version if you style internal DOM |

## 3. Deprecation

- Ships in a MINOR, never a PATCH; names **since · replacement · removal target · migration link**.
- Removal only in a MAJOR after the window: **≥ 1 MINOR and 3 months** (internal, ref) /
  **6 months** (public, ref).

## 4. Supported runtimes

| Runtime | Supported | Policy |
| --- | --- | --- |
| Node.js | 20, 22, 24 | Upstream-supported LTS lines; EOL lines dropped in the next MAJOR |
| Browsers (UI) | Last 2 versions of evergreen browsers | |

## 5. Release lines

| Line | Status | Receives | Until |
| --- | --- | --- | --- |
| v3 | **Active** | Features, fixes, security | Next MAJOR + window |
| v2 | Maintenance | Security and critical fixes | YYYY-MM-DD |
| v1 | End of life | Nothing | — |

## 6. Security

Fixes ship as PATCH on every supported line. A fix that must break callers may ship outside
a MAJOR with a `**Breaking:**` entry and an advisory. Report via `SECURITY.md`.

## 7. Revision history

- rev 0: (draft) initial policy.
