---
name: investigate-bugfix
description: Investigate a bug, crash or regression from reproducible evidence — never guess. Reproduction and root cause are settled in chat; the fix commit/PR body records them and a regression test proves the fix. Refuses to fix until reproduction and root-cause evidence exist.
metadata:
  revision: "rev 0"
---

# Investigate & bugfix

Find the root cause from evidence you can reproduce; do not speculate. Fix only after the
root cause is proven. Read `core/07-workflow-governance.md` and `core/11-clarity-first.md`
first. No investigation file is written: evidence lives in the chat, the regression test
and the fix commit/PR body.

## Gate (hard)

Before any fix:

1. Clear reproduction steps (command/input, expected vs actual), shown in chat with output.
2. Root cause isolated with evidence (`path:line`, log, failing test).
3. A fix approach with verification: the reproduction test fails before and passes after.

Missing any of these → refuse to fix and keep investigating. You may write and run a
reproduction test in an isolated environment, but not change production logic.

## Use / do not use

- Use: bug, crash, regression, failing test, wrong behavior.
- New feature → `architecture-design`. Refactor without a bug → `implementation-planning`.

## Principles

1. **Reproduce first.** If you cannot, say "cannot reproduce", gather more information and
   ask the engineer. Never fix blind.
2. **Evidence, not intuition.** Every claim cites a snippet/log/test. No "probably X".
3. **Isolate the root cause:** `git bisect` (in a clean worktree), binary search, minimal
   reproduction. Do not fix the symptom.
4. **TDD.** Reproduction test first (RED), minimal fix (GREEN), refactor. The reproduction
   test becomes the regression test; never delete it.
5. **Production-ready fix** at the correct layer, no hacks, within project boundaries.

## Procedure

1. **Reproduce in chat.** Exact commands, environment (OS/arch, runtime versions, profile,
   data dir), expected vs actual output verbatim (redact secrets/PII).
2. **Isolate.** Trace from the entry point along the call chain to the failure; cite
   snippets. Bisect for regressions. State each hypothesis and how it was confirmed or
   rejected.
3. **Root cause and approach.** State the root cause with `path:line` and mechanism; the
   layer of the fix; side effects (other modules, schema, migrations); verification commands.
   Medium/high risk: the engineer approves the approach.
4. **Fix with TDD.** RED reproduction test → fix → GREEN → refactor → project checks. If the
   fix changes architecture, an Accepted ADR comes first.
5. **Record.** The fix commit/PR body contains: reproduction, root cause, fix, regression
   test name, checks run with results (see `.agents/templates/pr-description.md`).
6. **Verify** with `implementation-verification`; do not claim `fixed` while a required
   check is unrun.

## Failure / fallback

- Cannot reproduce → say so, ask for information, no blind fix.
- Root cause unclear → keep investigating, no symptom fix.
- Fix crosses a boundary → stop; propose `architecture-design` + ADR.
- Third-party dependency bug → check the pinned version, audit tooling, upstream issues.

## Example (happy path)

"Export crashes on large runs." → reproduce with 10k events → `capacity overflow` panic at
`export.rs:42` → hypothesis (buffer grows unbounded) confirmed by logging → root cause:
whole result collected before serializing → fix: stream the output; test with 100k events
fails before and passes after; PR body records all of it.

## Revision history

- rev 0: (draft) generic version extracted from a production project.
- rev 0 (draft): evidence in chat + regression test + commit/PR body; no INV file.
