# ADR-NNN — Topic title

<!--
An ADR is the SAD for one specific topic. Create this file only after the engineer has
discussed the draft in chat and is satisfied (see .docs/workflow.md). Do not create an ADR
for an idea that is not finalized; keep research in .docs/research/.
Write in English (core/09-language-and-communication).
-->

| Property | Value |
| --- | --- |
| Status | Proposed → Accepted / Rejected / Deprecated / Superseded by ADR-XXX |
| Revision | rev 0 |
| Approval snapshot | None yet: who / when / confirmed content |
| Date | YYYY-MM-DD |
| Deciders | Engineer(s) |
| Requirement | (optional) `.docs/requirements/REQ-...` |
| Related ADRs | ADR-NNN (status) |
| SAD affected | SAD section to update on Accepted |
| Roadmap | Area / milestone |
| Read first | ADR that gives the bigger picture |
| Read next | More detailed / related ADRs |

## Decision summary

3–7 bullets: what is decided, scope, what is still pending.

## 1. Context and problem

What problem, why now, current state of the code (file/line), research done (link
`.docs/research/...`).

## 2. Requirements and constraints

- Goals, use cases, expected load, type of system.
- Measurable NFRs (security, performance, reliability, extensibility, consistency…); for
  each non-applicable one write the reason. Score against the 9 pillars
  (`02-architectural-pillars`) and list the drivers (e.g., latency < 50 ms → Scalability).
- Constraints: boundaries (AGENTS.md, existing ADRs), platforms, budgets.

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

**Diagrams first, text second.** Each main idea has one Mermaid diagram (title + one-line
purpose); text is short supporting bullets.

### 5.1 The component's own architecture

Internal component diagram + outward dependencies (which module, through which contract).

### 5.2 Principles / Expectations / Rules per module

| Module | Principles (design) | Expectations (measurable) | Rules (must not be broken) |
| --- | --- | --- | --- |
| … | … | … | … |

### 5.3 Flows, state, data

- Context / container (processes, data ownership).
- Components and main flows (sequence).
- Contract / data model / state, if any.
- Boundary check against AGENTS.md.
- Cross-platform considerations.
- Not doing (YAGNI).

### 5.4 Invariants (implementation must obey)

Laws this ADR **establishes**. Each has an ID `NNN-In` (NNN = ADR number) and a way to
check it (test, boundary check, grep). Project-wide laws live in the overview ADR; only
reference them. Changing an invariant of an Accepted ADR is a new decision and needs the
engineer's approval.

| ID | Invariant | Checked by |
| --- | --- | --- |
| NNN-I1 | … | … |

## 6. Rollout, rollback and verification

Migration, rollback, how to verify (tests, measurement), measurable AC.

## 7. Consequences and follow-up

- **Positive:** …
- **Negative and mitigations:** …
- Next work, SAD/other ADRs to update, remaining risks.

## 8. Open questions

Must be empty (or turned into owned follow-ups) before `Accepted`.

## Sources

URL + access date; primary sources first.

## Revision history

- rev 0: ADR created (YYYY-MM-DD). Only the engineer's confirmation bumps the revision.
