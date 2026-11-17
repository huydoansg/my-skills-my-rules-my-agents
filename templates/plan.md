# NN — <imperative title>

<!--
File: NN-<component>-<slug>.md in the ADR's plans folder (Docs layout; discovery: NN-spike-<slug>.md).
Links below assume the Product Brain layout; adjust them to the project's Docs layout.
One component, one outcome. Follows the Accepted ADR; makes no new decision.
Written for an executor that has never seen the repo. Short and plain (core/06 §7);
Mermaid for flows and order (core/10). Delete every comment and unused row before use.
-->

| Property | Value |
| --- | --- |
| ADR | [ADR-NNN-slug](../ADR-NNN-slug.md) · rev N · `<hash>` · sections §… |
| Master plan | [01-<slug>-master-plan](01-<slug>-master-plan.md) · rev N |
| Component | [<name>](<component card link>) |
| Type | delivery · discovery |
| Status | draft · ready · in-progress · blocked · done · abandoned |
| Revision | rev 0 |
| Executor | <model tier / person> · Autonomy: attended · unattended |

> **Executor rules**
> 1. Read §1–§6, then one task at a time, in the order of §8.
> 2. Edit only the files listed in the task. Never change §1–§6.
> 3. After each step, run `Run` and compare with `Expect`. Paste the decisive output line into §10.
> 4. **Stop** when the output is not `Expect`, a file outside the list must change, a tool,
>    harness, script or dependency that no task lists is needed, the code contradicts the
>    plan or the ADR, or anything is unclear. Add a question to §6 and report.
>    Never guess. Outside these cases, continue without asking.
> 5. Never delete or weaken a test or an AC. End each session clean and update Handoff.

## 1. Goal

<One sentence: the observable result.>

Demo: `cwd: <dir>` `$ <command>` → `<expected>`

## 2. Scope

- **In:** …
- **Out:** … (name the tempting adjacent work)
- **Do not touch:** `<paths>`
- **Keep working** (existing behavior → guard): … → `<test>`

## 3. Context

<2–3 sentences: where this component sits and what changes.>

```mermaid
---
title: <flow touched by this plan> (purpose - …)
---
flowchart LR
  A[…] --> B[…]
```

| Read first (path : symbol) | Why |
| --- | --- |
| Component card of `<name>` | Role, interfaces, commands |
| `…` | … |

Example to follow: `path : symbol`. Glossary: *term*: meaning.

## 4. From the ADR and master plan (fixed)

Copied from the owner so this file can be executed alone. The owner wins on a conflict
(governance §5.1).

| Item | What it means for this plan |
| --- | --- |
| Intent | <goal and agreed approach, copied from master plan §1> |
| Rejected | <approach> — do not use it, because <reason> |
| S-01 | … |
| D-01 | … |
| I-03 | … — checked by `<command>` |
| INV-001…INV-012 | <units this plan carries over; parity check per row in the master plan> |

Interfaces (exact):

    Consumes: <signature / schema> (from plan NN, existing code or the contract file)
    Produces: <signature / schema> (used by plan NN)

## 5. Acceptance

| ID | WHEN … THEN … SHALL … | Check |
| --- | --- | --- |
| AC-1 | … | `<command> <test>` |
| AC-G | Project checks pass, 0 warnings; boundary check 0 violations | `<check>` · `<arch>` |

Review focus (the most likely missed failures, most likely first):

1. <input/failure class> → expected behavior → covered by T…

## 6. Clarity register

| ID | Question | Type | Blocks | Resolution · evidence | Status |
| --- | --- | --- | --- | --- | --- |

`ready` requires no `open` row (core/11).

## 7. Tasks

### T1 — <imperative title>

- **Serves:** D-01, I-03, S-01 · **AC:** AC-1 · **Depends:** — · **Freedom:** low · medium · high
- **Why:** <the need this task serves, one line>
- **Do not:** <the tempting wrong approach or extra work for this task>
- **Files:** edit `path` (`symbol`) · create `path` · test `path`
- **File responsibility:** one line per created or edited file; a new concept gets a new file (`core/12-modularity`).
- **Consumes / Produces:** see §4 (or the exact signature)
- **Steps:**
  - [ ] Write test `<name>` asserting `<exact values>`.
        Run `<cmd>` → fails with `<message>` because the behavior is missing.
  - [ ] Implement `<signature>` in `path`. Approach: <one line>.
  - [ ] Run `<cmd>` → `<expected pass line>`.
- **Wrong if:** `<output>` → means … → stop.
- **Undo:** `<command>`
- **Done when:** <state on disk> and the check above passes.

<!-- Task boundary: a reviewer could accept this task and reject the next one.
     Freedom low = exact commands, no variation; high = goal + constraints only.
     An executor of a lower tier than the planner gets Freedom low on every task.
     A task that builds a tool, harness, generator, script or adds a dependency also states:
     the failure it detects, why the project's existing checks cannot detect it, a
     size estimate, and where it lives: local → `.agents/tools/` or `.agents/scripts/`,
     never committed; shared → a project folder (governance §7).
     Repeated units (the same change on many endpoints or files): write the recipe once
     on one unit, then a table `unit | file | test | expected`; no prose per unit. -->

## 8. Order

```mermaid
---
title: Task order (purpose - dependencies and parallel tasks)
---
flowchart LR
  T1 --> T2
  T1 --> T3
```

Tasks that share no file and have no dependency on each other may run in parallel.

## 9. Risks

| Risk | Signal | Mitigation / rollback |
| --- | --- | --- |

## 10. Execution log

- **Baseline** (before T1): `$ <check>` → `<result>`
- **Progress:** `- [x] T1 (YYYY-MM-DD HH:MM) — <result> · <cmd> → <line>`
- **Surprises:** … with evidence
- **Decisions / proposals:** … (proposals that touch §1–§6 wait for the planner)
- **Handoff:** last done · next step · blockers · workspace clean?

## 11. Outcome

Demo result · AC result (link the verification report) · what the plan missed →
feedback for this template.

## 12. Ready gate (planner self-review)

- [ ] Every item in §4 maps to a task; every task cites a §4 item and an AC, and has Why and Do not.
- [ ] Each step allows exactly one reasonable action; no banned vague word, no check verb
      without a command, no scope word without a count or list (core/06 §7).
- [ ] Consistency check (governance §5.1) reports no finding; the header pins the current
      ADR and master plan revisions.
- [ ] No task builds tooling beyond master plan §1 "Tooling needed"; no task uses a rejected approach.
- [ ] Names and signatures match across tasks, §4 and the ADR.
- [ ] Every Review focus item has a test in some task.
- [ ] Each new concept has its own file; no task adds a second responsibility to an existing file or grows a file over its limit.
- [ ] Every path exists (or is marked create); every command has a cwd and an expected output.
- [ ] §6 has no open question; the plan covers one component and one outcome.
- [ ] Builder check: a fresh subagent on the executor's model tier, reading only this file,
      restates the goal, T1 (files, command, expected output) and one Do not correctly;
      its questions (if any) are answered in one round. Checked with: <model>.

Approved by · when · reference · revision + hash.

## Revision history

- rev 0: created.
