---
name: implementation-planning
description: Turn an Accepted ADR into a master plan and per-component plans that an executor who has never seen the repo can follow — tasks, acceptance criteria, checks, risks, order. Output in the ADR's plans folder (Docs layout). Plans only; never implements.
metadata:
  revision: "rev 0"
---

# Implementation planning

Convert an Accepted ADR into plans precise enough to execute without guessing. Do not
write production code here. Read `core/07-workflow-governance.md` and
`core/11-clarity-first.md` first.

## Gate (hard)

1. The topic's ADR is `Accepted` (or N/A per governance, pointing to the governing ADR,
   whose plans folder then holds the plan).
2. Every point the plan depends on is clear (`core/11` C1–C4). Ambiguous parts become
   discovery plans or engineer questions; never plan around a guess.
3. Chat first: agree the split into plans with the engineer in chat, then write files.

## Use / do not use

- Use: ADR Accepted and work must be planned before coding.
- No ADR Accepted → `architecture-design`. A bug → `investigate-bugfix`.
- Docs/rules/format only: use a review checklist, no plan.

## Procedure

1. **Load context:** the Docs layout in `AGENTS.md`; the ADR (decisions D-xx, invariants
   I-xx, NFRs, contracts, rejected options), related Accepted ADRs, component cards, and the code at the exact touch points
   (`path:line`).
2. **Confirm the intent brief** (`core/11` §3.1) in chat. Name the work type and propose
   its default approach from "Approach by work type" below; the engineer confirms or
   replaces it. Record the confirmed brief in the master plan §1.
3. **Split** (record in the master plan, template `.agents/templates/master-plan.md` →
   `01-<slug>-master-plan.md` in the plans folder):
   - one plan per component, one outcome per plan;
   - each ambiguous part → a discovery plan `NN-spike-<slug>.md` that runs first;
   - a large contract → `contract-<name>.md` in the ADR docs folder, owned by the ADR;
   - only plans that are clear get a file; the rest stay one line (`outline`);
   - the first delivery plan is the pilot: one unit from start to passing check. Write the
     later plans in detail after the pilot checkpoint.
4. **Review the master plan** before asking for approval: consistency check (governance
   §5.1) and over-engineering review (governance §7, skill `code-auditor` §2).
5. **Write each plan** from `.agents/templates/plan.md` →
   `NN-<component>-<slug>.md` in the plans folder, following "Writing the plan" below.
6. **Self-review** with the plan's ready gate, the consistency check, then the builder check.
7. **Ready:** status `ready` only after the engineer confirms; update the master plan
   register and the technical roadmap in the same change (governance §5).
8. **During execution:** propose `ready → in-progress`, per-task status with evidence, and
   `done` only when every AC and the verification pass; write after confirmation
   (governance §4). Hold the checkpoint after the pilot and after each plan `done`.
9. **Editing a plan or the master plan:** follow governance §5.1 (changed IDs → every
   citing document in the same change), then rerun the consistency check.

## Approach by work type

Propose the default; the engineer decides. A different approach is recorded in the master
plan §1 with the engineer's reason.

| Work type | Default approach | Done measure |
| --- | --- | --- |
| Port or migration 1:1 | Inventory each unit (endpoint, service, worker, topic, table) as an `INV-` row and mark dropped scope. Record the old behavior with characterization tests: same request → same response, DB rows and messages. Port unit by unit against those tests. | Every `INV-` row passes the same test on the new code; lint and typecheck pass |
| Refactor (no behavior change) | Run the existing tests first. Add characterization tests only where the touched code has none. Change in small steps. | The same tests pass before and after; no public interface diff |
| New feature | AC from the ADR; TDD per AC | AC tests and the project checks pass |
| Bulk mechanical change | One recipe proven on one unit, then a table of units | The recipe's check passes on each row |
| Bugfix | Skill `investigate-bugfix` | Regression test fails before, passes after |

The project's test runner, linter and typechecker are the default tools. Anything built
beyond them is listed in the brief under "Tooling needed" (governance §7).

## Writing the plan

1. **Follow the Accepted ADR and the master plan.** Pin the ADR revision + hash and the
   master plan revision in the header. Every task cites ≥ 1 item of the plan's §4 (D-xx,
   I-xx, S-xx, INV-xxx). The plan makes no new decision; a missing one is an open
   question → back to the ADR. An ADR change returns the plan to `draft`.
   The plan's §4 copies the intent, the rejected approaches and the cited items, so the
   executor needs no other file. Each task states Why and Do not.
2. **Short and plain.** Only what the executor lacks; no general knowledge. The plan is
   not longer than the code it describes; no pasted code beyond signatures and test
   assertions. No banned vague word (`core/06` §7); one term per concept.
3. **Task boundary:** a reviewer could accept this task and reject the next one. Each task
   has its own test cycle and ends with a checkable deliverable.
4. **One step = one action with a checkable result** (`Run` → `Expect`), plus how a wrong
   result looks.
5. **Freedom by risk and executor:** `low` = exact commands, no variation (migration,
   security, data); `high` = goal + constraints only (local, reversible change). When the
   executor (plan header) is a lower model tier than the planner, every task is `low`.
6. **Interfaces exact:** each task states what it Consumes and Produces (signature/schema);
   later tasks point to them instead of repeating them.
7. **Examples over description:** point to a canonical example in the repo (`path:symbol`).
8. **Mermaid** for the touched flow and the task order (title + one-sentence purpose, `core/10`).
9. **Builder check:** a fresh subagent on the executor's model tier reads only the plan and
   restates the goal, T1 (files, command, expected output) and one Do not; its questions
   are answered in one round with the engineer before `ready`. If that tier cannot be
   started here, use the lowest tier available, or the engineer runs the check in the
   executor's tool. Record the model used in the ready gate.
10. **Repeated units:** write the recipe once on one unit, then a table
    `unit | file | test | expected`. No prose per unit.

## Failure / fallback

- ADR lacks a decision or detail → open question, back to `architecture-design`; do not guess.
- ADR still `Proposed` → blocked until accepted.
- A plan covers more than one component or outcome → split it in the master plan.

## Revision history

- rev 0: (draft) generic version extracted from a production project.
- rev 0 (draft): master plan + per-component plans (paths from the Docs layout); clarity gate;
  writing rules (ADR traceability, freedom levels, task boundary, builder check).
- rev 0 (draft): intent brief step; approach by work type; pilot and checkpoint; master plan
  review; consistency on edits; freedom by executor; builder check on the executor's tier.
