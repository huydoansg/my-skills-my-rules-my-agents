# ADR-NNN — Topic title

<!--
An ADR is the design for one specific topic that a reader can follow: problem → solution →
how each part works → trade-offs (core/13-architecture-docs). File: ADR-NNN-slug.md in its
ADR folder (Docs layout).
Create it only after the engineer has discussed the draft in chat, every point is clear
(core/11) and the engineer is satisfied (see .agents/workflow.md). Research worth keeping
goes to the ADR's research folder; plans go to its plans folder.
Leave out a view that does not apply (say why in chat). Write in English (core/09).
-->

| Property | Value |
| --- | --- |
| Status | Proposed → Accepted / Rejected / Deprecated / Superseded by ADR-XXX |
| Revision | rev 0 |
| Approval snapshot | None yet. Format (core/07 §3): `Approved by · <who> · YYYY-MM-DD · "<verbatim>" · rev N · <hash>` |
| Date | YYYY-MM-DD |
| Deciders | Engineer(s) |
| Initiative | Initiative folder `NNN-DDMMYYYY-slug` this ADR serves (link), or `none` |
| Related ADRs | ADR-NNN (status) |
| Architecture affected | Architecture overview section to update on Accepted |
| Roadmap | Technical roadmap entry; product roadmap feature (if any) |
| Components | Component cards touched |
| Read first | ADR that gives the bigger picture |
| Read next | More detailed / related ADRs |

## Decision summary

3–7 bullets: what is decided, scope, what is still pending.

## 1. Problem

What hurts, in product language first (users, customers, the business), then the technical
cause. Current state of the code (file/line); research done (link the research folder,
references).

| Challenge | User / customer impact | Technical cause |
| --- | --- | --- |
| … | … | … (`path:line`) |

## 2. Goals, requirements and constraints

- **Goals:** what must be true after. **Non-goals:** what is deliberately out (name the
  tempting adjacent work).
- Use cases, expected load, type of system.
- Measurable NFRs (security, performance, reliability, extensibility, consistency…); for
  each non-applicable one write the reason. Score against the 9 pillars
  (`02-architectural-pillars`) and list the drivers (e.g., latency < 50 ms → Scalability).
- Constraints: boundaries (AGENTS.md, existing ADRs), platforms, budgets.

| Quality goal | Measure | Driver |
| --- | --- | --- |
| … | … | … |

## 3. Options considered

| Option | Pros | Cons | Fits when |
| --- | --- | --- | --- |
| A (chosen) | | | |
| B | | | |

## 4. Decision and reasons

The concrete decision, reasons grounded in evidence, accepted trade-offs.

| Metric / pillar | Option A (chosen) | Option B |
| --- | --- | --- |
| Performance / latency | | |
| Operational complexity | | |
| Cost | | |
| Resilience / HA | | |

## 5. Design

**Diagrams first, text second.** Each part has one Mermaid diagram (title + one-line
purpose), then a callout of the 3–5 points a reader must not miss, then short bullets.

### 5.1 Solution strategy

| Key idea | Solves (§1 challenge) |
| --- | --- |
| … | … |

### 5.2 Building block view

**Level 1 — black boxes**, named by product responsibility:

| Block | Responsibility | Never | Depends on |
| --- | --- | --- | --- |
| … | … | … | … |

**Level 2 — white boxes**, one diagram per block that changes:

| Block → component | Technology / runs where | Data owned | Detail doc |
| --- | --- | --- | --- |
| … | … | … | contract file · child ADR · none |

### 5.3 Principles / Expectations / Rules per module

| Module | Principles (design) | Expectations (measurable) | Rules (must not be broken) |
| --- | --- | --- | --- |
| … | … | … | … |

### 5.4 Context, containers and team integration

- C4 context or container diagram, grouped by owning team; trust boundaries.
- Per team boundary: sequence diagram + contract table + key guarantees.

| Call | Owner | Inputs | Outputs | Failure |
| --- | --- | --- | --- | --- |
| … | … | … | … | … |

### 5.5 Runtime flows

One sequence diagram per key flow, each with `alt` failure paths.

### 5.6 Data and storage

Schema (kept / added / removed), storage layout, correspondence between stores.

### 5.7 Crosscutting

Security · consistency · observability · privacy: one short subsection each. Boundary check
against AGENTS.md; cross-platform considerations; not doing (YAGNI).

### 5.8 Invariants (implementation must obey)

Laws this ADR **establishes**. Each has an ID `NNN-In` (NNN = ADR number) and a way to
check it (test, boundary check, grep). Project-wide laws live in the overview ADR; only
reference them. Changing an invariant of an Accepted ADR is a new decision and needs the
engineer's approval.

| ID | Invariant | Checked by |
| --- | --- | --- |
| NNN-I1 | … | … |

## 6. Migration, rollout, rollback and verification

Phase diagram from today to the target; approach per phase; rollback; how to verify
(tests, measurement); measurable AC.

## 7. Trade-offs, consequences and follow-up

| Trade-off | Impact | Mitigation |
| --- | --- | --- |
| … | … | … |

- **Positive:** …
- Next work, architecture overview/other ADRs to update, remaining risks.

## 8. Open questions

Must be empty before `Accepted` (core/11): every question is resolved, or split out as a
discovery plan that no decision in this ADR depends on.

## Sources

URL + access date; primary sources first.

## Revision history

- rev 0: ADR created (YYYY-MM-DD). Only the engineer's confirmation bumps the revision.
