---
name: split-module
description: Split a file that holds several responsibilities or exceeds the modularity limits into single-responsibility files without changing behavior. Use when check-modularity reports a violation, before adding code to a large file, or when asked to refactor a God file. Any language.
metadata:
  revision: "rev 0"
---

# Split module

Read `core/12-modularity.md` first. Goal: one responsibility per file, behavior unchanged.
Token rule: never read a large file whole; get the outline, then read slices.

## 1. Map (cheap)

1. Outline without reading bodies: `grep -nE '^(export |pub |public )?(class|struct|enum|interface|trait|type|fn|func|def|function)\b' <file>` (adapt per language), or the language's symbol tool.
2. Group symbols by **responsibility** (what changes for the same reason), not by size or position. Draw the dependency direction between groups.
3. Propose the target files in chat: `new file | symbols | responsibility`. Name each after its one responsibility. Wait for the engineer only if the grouping is ambiguous (`11-clarity-first`).

## 2. Protect

- Run the existing tests for the file. None → write a characterization test for the public surface first and show it passes.
- Keep the public import path stable: leave the original file as a thin re-export (or barrel/`mod.rs`/`__init__.py`) until callers are migrated.

## 3. Move (one extraction per step)

For each group: create the new file → move the code unchanged (no rename, no logic edit) → fix imports → run tests and the project linter/typecheck → commit `refactor(<area>): extract <responsibility>`.
Shared helpers used by several groups go to their own file; break cycles by moving the shared piece, never by duplicating it.

## 4. Verify

- `.agents/tools/check-modularity.sh` passes (or the file shrank; update `--shrink` for baselined files).
- Tests, lint and typecheck green; public API unchanged (diff of exports).
- Report: `old file → new files`, lines before/after, test evidence.

## Do not

- Split by line count (`part1`, `utils2`). A split without a single responsibility per file is not a fix.
- Mix a refactor with a behavior change in one commit.
- Add exemptions or edit the baseline to pass the check.
