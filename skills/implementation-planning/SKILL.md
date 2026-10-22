---
name: implementation-planning
description: Turn an Accepted ADR into an implementation plan — tasks, acceptance criteria, verification plan, risks, sequencing — written for an executor that has not seen the repo. Output in .docs/plans/. Plans only; never implements.
metadata:
  revision: "rev 0"
---

# Implementation planning

Convert an Accepted ADR into a plan precise enough to execute without ambiguity. Do not
write production code here. Read `core/07-workflow-governance.md` first.

## Gate (hard)

1. The topic's ADR is `Accepted` (or N/A per governance, pointing to the governing ADR).
2. You may draft a plan while approval is missing, but it cannot become `ready` or be executed.
3. Approval matches the snapshot; AC/NFR in the ADR have not drifted.

Chat first: agree the task breakdown with the engineer in chat, then write the file.

## Use / do not use

- Use: ADR Accepted and a plan is needed before coding.
- No ADR Accepted → `architecture-design`. A bug → `investigate-bugfix`.
- Docs/rules/format only: use a review checklist, no full plan.

## Principles

1. **TDD first.** Phase 0 (RED tests) precedes implementation (GREEN). In planning,
   only describe tests, fixtures, commands and the expected RED failure; do not write or
   run them or claim they failed.
2. **Traceability.** Each task points to the ADR section and requirement.
3. **Verifiable.** Each task has exit criteria checkable by test/command/output.
4. **Acceptance criteria.** Measurable, in EARS form: `WHEN <condition> THEN <component>
   SHALL <measurable behavior>` (or `<component> SHALL ALWAYS …` for unconditional laws);
   each AC points to ≥ 1 test or command.
5. **Sequenced.** Tasks follow dependencies; no task starts before its dependency is done.
6. **Risk-aware.** Mark high-risk tasks (migration, security, cross-platform).
7. **Revision.** `rev 0`; only the engineer's confirmation bumps it.
8. **Respect the ADR.** The plan lists the applicable invariants (`NNN-In`) and how each is
   checked; no task may require violating one — if unavoidable, stop and ask.

## Procedure

1. **Load context:** the ADR (requirements, NFRs, design), related Accepted ADRs, the
   requirement analysis, and grep existing code for exact touch points (file/line).
2. **Describe Phase 0 tests** (cases, fixtures, command, expected RED reason).
3. **Break down tasks** with `.agents/templates/plan.md`. Typical phases: 0 tests (RED) →
   1 schema/contract → 2 core logic (GREEN) → 3 integration → 4 UI → 5 regression/coverage →
   6 docs. Drop phases that do not apply. Each task: ID, title, depends, touches, boundary,
   verification, exit criteria, **expected outcome**, risk.
4. **Verification plan and checklist** from the project's own check commands (listed in
   its `AGENTS.md`): code quality, tests, architecture/schema checks, NFRs, platforms, docs.
5. **Risk register** with mitigations (migrations: backup + forward-only; security:
   review; cross-platform: matrix; performance: before/after benchmark).
6. **Executor brief** so a smaller model that has never seen the repo can execute: full
   paths, fixed interfaces, commands + expected output, stop conditions, safe re-run and
   rollback. Unknowns become `[NEEDS CLARIFICATION: …]` and stop that task; never guess.
7. **Exit condition:** every task has verification + exit criteria; AC measurable; checklist
   complete; dependency graph acyclic (Mermaid); risks mitigated; executor brief present;
   `plans/INDEX.md` updated; status → `ready` only after the engineer confirms; roadmap
   synced (governance section 5).
8. **During execution:** the plan carries a task/phase status table. Propose
   `ready → in-progress`, per-task status with evidence, and `done` only when all AC and VER
   pass; write only after confirmation, updating plan, INDEX and roadmap together
   (governance section 4).

## Failure / fallback

- ADR lacks detail → back to `architecture-design`, do not guess.
- ADR still `Proposed` → blocked until accepted.
- Plan too large → split into sub-plans, one file each; execute in INDEX order.

## Revision history

- rev 0: (draft) generic version extracted from a production project.
