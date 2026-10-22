---
name: investigate-bugfix
description: Investigate a bug, crash or regression from reproducible evidence — never guess. Produces an investigation report (reproduction, hypotheses, root cause, fix plan) in .docs/investigations/. Refuses to fix until reproduction and root-cause evidence exist.
metadata:
  revision: "rev 0"
---

# Investigate & bugfix

Find the root cause from evidence you can reproduce; do not speculate. Fix only after the
root cause is proven. Read `core/07-workflow-governance.md` first.

## Gate (hard)

Before any fix:

1. Clear reproduction steps (command/input, expected vs actual).
2. Root cause isolated with evidence (file/line/log/failing test).
3. A fix plan with verification (the reproduction test fails before and passes after).

Missing any of these → refuse to fix and keep investigating. You may write and run a
reproduction test in an isolated environment, but not change production logic.

## Use / do not use

- Use: bug, crash, regression, failing test, wrong behavior.
- New feature → `requirement-discovery`/`architecture-design`. Refactor without a bug →
  `implementation-planning`.

## Principles

1. **Reproduce first.** If you cannot, say "cannot reproduce", gather more information and
   ask the engineer. Never fix blind.
2. **Evidence, not intuition.** Every claim cites a snippet/log/test. No "probably X".
3. **Isolate the root cause:** `git bisect` (in a clean worktree), binary search, minimal
   reproduction. Do not fix the symptom.
4. **TDD.** Reproduction test first (RED), minimal fix (GREEN), refactor. The reproduction
   test becomes the regression test; never delete it.
5. **Production-ready fix** at the correct layer, no hacks, within project boundaries.
6. **Checklist** before claiming fixed; required checks must pass with evidence; N/A
   needs a reason.
7. `rev 0`; the engineer's confirmation bumps it.

## Procedure

1. **Record the report.** Create `.docs/investigations/INV-YYYYMMDD-slug/` with `report.md`
   from `.agents/templates/investigation.md` and (optionally) `raw.md` with the original
   report; update `investigations/INV INDEX`. Record the reproduction: exact commands,
   environment (OS/arch, runtime versions, profile, data dir), expected vs actual output
   verbatim (redact secrets/PII).
2. **Reproduce.** If it does not reproduce: collect environment, ask the engineer, record
   "cannot reproduce". If it does: paste verbatim logs.
3. **Isolate.** Trace from the entry point along the call chain to the failure; cite
   snippets. Bisect for regressions. Build the smallest reproduction. Hypothesis →
   verification by test/log; record every hypothesis, including wrong ones, in the log.
4. **Root cause and fix plan (TDD).** State the root cause with file/line and mechanism.
   Plan: reproduction test (RED) → fix (GREEN) → refactor; layer of the fix; regression
   test; side effects (other modules, schema, migrations); verification commands.
5. **Gate the fix.** Execute only when the root cause is proven, the reproduction test
   has been written and fails, and the engineer approved the plan (medium/high risk). If
   the fix changes architecture, an Accepted ADR comes first.
6. **Post-fix checklist** (template): tests, code quality, architecture/schema checks,
   NFRs, platforms, docs. Use `implementation-verification` to store evidence; do not claim
   `fixed` while a required check is unrun.

## Failure / fallback

- Cannot reproduce → record it, ask for information, no blind fix.
- Root cause unclear → keep investigating, no symptom fix.
- Fix crosses a boundary → stop; propose `architecture-design` + ADR.
- Third-party dependency bug → check the pinned version, audit tooling, upstream issues.

## Example (happy path)

"Export crashes on large runs." → reproduce with 10k events → `capacity overflow` panic at
`export.rs:42` → hypothesis 1 (buffer grows unbounded) verified by logging → root cause:
whole result collected before serializing → fix: stream the output; test with 100k events
fails before and passes after.

## Revision history

- rev 0: (draft) generic version extracted from a production project.
