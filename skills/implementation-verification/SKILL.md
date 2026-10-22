---
name: implementation-verification
description: Verify an implementation or bugfix against its plan/ADR, acceptance criteria and TDD evidence, and write a pass/fail/blocked report in .docs/verifications/. Use before claiming done or fixed. Audit only — does not design or silently fix.
metadata:
  revision: "rev 0"
---

# Implementation verification

Read `core/07-workflow-governance.md`. Inputs: the PLAN or INV, the applicable ADR, the
AC, the current diff and the run environment. If AC are missing, draft a checklist from
the requirement and record blockers for unclear points; never invent results or accept a
design yourself.

## Procedure

1. Read the rules that match the changed files. Compare code to design/NFRs/UI journey;
   decide regression scope and platform matrix by risk.
2. Create `.docs/verifications/VER-YYYYMMDD-slug.md` from `.agents/templates/verification.md`.
   Pin the commit and dirty diff, versions, profile and data fixture. Use isolated fake
   or temporary data.
3. List AC → test/command → expected result **before** running. Confirm each command
   exists in the project's scripts/tooling; illustrative names are not verified commands.
4. Run targeted tests, then the plan's required checks. Format with check mode, never
   write mode. Match RED/GREEN evidence for the same test/input; missing RED cannot be
   claimed retroactively as TDD.
5. Store cwd, timestamp, exit code and redacted logs. E2E needs a running UI/packaged
   build; cross-compiling does not prove native runtime. Missing runner → `blocked`.
6. A required check that is fail/blocked/not-run is reported as such; open an INV if
   needed. Do not fix in audit-only mode. `N/A` needs a real reason, never used to hide a
   missing test.
7. `passed` only when AC and required checks pass. State residual risks; do not extend
   the result to "the whole product is ready".
8. Always end by proposing status updates (VER, PLAN/phase, INV, INDEX, roadmap) as a
   table `artifact | old → new | evidence | missing`; write only after the engineer
   confirms (governance section 4).

## Examples and edge cases

- Fix export: same regression test RED then GREEN, schema and journey pass → `passed`.
- Passes on one platform but another required platform has no runner → `blocked`; keep
  that platform's evidence separate; do not mark N/A or promise a pass.
- Offline, external docs unreachable → "unverified"; never send logs/secrets outward.
- Retry only with a new hypothesis or a fixed environment issue; keep failed runs; never
  retry until green and delete the failures.

## Revision history

- rev 0: (draft) generic version extracted from a production project.
