---
name: brain-sync
description: Keep a Product Brain (or the project's docs) consistent after status changes — apply the sync table of governance §5 (indexes, roadmaps, architecture overview, component Current/Target state, initiative cards), run the project's doc checks, scan for stale or conflicting documents, and end with one status proposal table. Use after any ADR, plan or initiative status change, at the end of a work session, or when asked to sync or clean up the brain. Reports and proposes; writes statuses only after the engineer confirms.
metadata:
  revision: "rev 0"
---

# Brain sync

Read `core/07-workflow-governance.md` §4–§5 and the project's Docs layout
(`core/08-repo-layout-and-naming.md`) first. All paths below are Docs layout artifact names.

## Procedure

1. **Find what changed** since the last sync: `git diff --name-only <last sync commit>` in
   the brain (or the docs folder), plus the statuses the engineer confirmed in this session.
2. **Event sync** (governance §5, one change per event, propose → confirm → write):

   | Event | Do |
   | --- | --- |
   | ADR `Accepted` | One bullet in **Target state** of each component card it touches; architecture overview section; technical roadmap (and product roadmap when a feature depends on it); superseded ADRs marked; ADR index; initiative card |
   | ADR delivered (its master plan `done`, verification passed) | Move each bullet from **Target state** to **Current state** and rewrite *Current state* so it stays true, citing code; update interfaces; architecture overview if containers or global invariants changed; roadmaps; propose the initiative's next status |
   | ADR `Rejected` / `Superseded` | Remove its *Target state* bullets; fix every link to it; roadmaps; initiative card |
   | Plan `ready` / `done` | Master plan register; technical roadmap; product roadmap when a milestone completes |
   | Initiative status or horizon changed | Card status log; initiatives index; initiatives roadmap |

3. **Checks.** Run the project's doc checks if it lists any (lint, link check, index
   generator). Otherwise check by hand: every link in a changed file resolves; every index
   and roadmap row equals the status of its file; every ID cited by a plan exists in its
   owner (governance §5.1 consistency check).
4. **Staleness scan** (report only, never auto-fix):
   - initiatives `in-progress` with no ADR or plan activity, ADRs `Accepted` with no master
     plan, plans `in-progress` with no execution log entry in the last 30 days;
   - component *Target state* bullets whose ADR is already delivered, rejected or superseded;
   - documents still `draft` / `Proposed` after 60 days;
   - a plan whose pinned ADR revision or hash differs from the current ADR.
5. **Report** one table `artifact | old → new | evidence | missing` plus a short list of
   stale items. Write statuses only after the engineer confirms (governance §4); a status
   that needs an approval record gets it (governance §3).
6. **Commit** only when the engineer asks.

## Rules

- Stay in scope: sync the documents the events touch; no reformatting of unrelated files.
- Generated content (indexes or roadmap blocks a tool writes) is regenerated, never edited by hand.
- A document that disagrees with the code is reported with evidence (`path:line`); the fix
  is proposed, not applied.

## Revision history

- rev 0 (draft): created from a Product Brain's sync skill: event sync with component
  Current/Target state, checks, staleness scan, one proposal table.
