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
   I-xx, NFRs, contracts), related Accepted ADRs, component cards, and the code at the exact touch points
   (`path:line`).
2. **Split** (record in the master plan, template `.agents/templates/master-plan.md` →
   `01-<slug>-master-plan.md` in the plans folder):
   - one plan per component, one outcome per plan;
   - each ambiguous part → a discovery plan `NN-spike-<slug>.md` that runs first;
   - a large contract → `contract-<name>.md` in the ADR docs folder, owned by the ADR;
   - only plans that are clear get a file; the rest stay one line (`outline`).
3. **Write each plan** from `.agents/templates/plan.md` →
   `NN-<component>-<slug>.md` in the plans folder, following "Writing the plan" below.
4. **Self-review** with the plan's ready gate, then the builder check (fresh subagent).
5. **Ready:** status `ready` only after the engineer confirms; update the master plan
   register and the technical roadmap in the same change (governance §5).
6. **During execution:** propose `ready → in-progress`, per-task status with evidence, and
   `done` only when every AC and the verification pass; write after confirmation
   (governance §4).

## Writing the plan

1. **Follow the Accepted ADR.** Pin ADR revision + hash in the header. Every task cites
   ≥ 1 ADR decision (D-xx) or invariant (I-xx). The plan makes no new decision; a missing
   one is an open question → back to the ADR. An ADR change returns the plan to `draft`.
2. **Short and plain.** Only what the executor lacks; no general knowledge. The plan is
   not longer than the code it describes; no pasted code beyond signatures and test
   assertions. No banned vague word (`core/06` §7); one term per concept.
3. **Task boundary:** a reviewer could accept this task and reject the next one. Each task
   has its own test cycle and ends with a checkable deliverable.
4. **One step = one action with a checkable result** (`Run` → `Expect`), plus how a wrong
   result looks.
5. **Freedom by risk:** `low` = exact commands, no variation (migration, security, data);
   `high` = goal + constraints only (local, reversible change).
6. **Interfaces exact:** each task states what it Consumes and Produces (signature/schema);
   later tasks point to them instead of repeating them.
7. **Examples over description:** point to a canonical example in the repo (`path:symbol`).
8. **Mermaid** for the touched flow and the task order (title + one-sentence purpose, `core/10`).
9. **Builder check:** a fresh subagent reads only the plan and restates T1 (files, command,
   expected output); its questions are answered in one round with the engineer before `ready`.

## Failure / fallback

- ADR lacks a decision or detail → open question, back to `architecture-design`; do not guess.
- ADR still `Proposed` → blocked until accepted.
- A plan covers more than one component or outcome → split it in the master plan.

## Revision history

- rev 0: (draft) generic version extracted from a production project.
- rev 0 (draft): master plan + per-component plans (paths from the Docs layout); clarity gate;
  writing rules (ADR traceability, freedom levels, task boundary, builder check).
