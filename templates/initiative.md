# NNN — Initiative title

<!--
Initiative card. File: README.md in the initiative folder `NNN-DDMMYYYY-slug/` (Docs layout).
An initiative is an idea the engineer wants to keep and grow: a product idea or a
technology idea. It is NOT a decision (ADR) and NOT a plan.
- Ambiguity is allowed here (core/11 §6): list every unresolved point under "Open questions".
- Nothing here authorizes implementation. Only an Accepted ADR + a ready plan does.
- Content an ADR depends on is resolved in chat and restated in the ADR; the ADR never
  cites this card as a decision.
Write in English (core/09-language-and-communication).
-->

| Property | Value |
| --- | --- |
| Number | NNN (global, never reused) |
| Created | DD-MM-YYYY (same date as the folder name) |
| Type | product · technology |
| Status | idea · exploring · planning · in-progress · done · parked · dropped |
| Horizon | now · next · later · someday (same value as the initiatives roadmap) |
| Owner | Engineer(s) |
| Related initiatives | NNN-DDMMYYYY-slug |

## Summary

Two or three sentences: what the idea is and why it might be worth doing.

## Problem or opportunity

What hurts today, or what becomes possible. Who is affected. Evidence if any
(link `context.md`, `.researchs/`).

## Hypothesis and expected outcome

"If we do X, we expect Y, observable by Z." A rough measure is acceptable at this stage.

## Directions

Candidate approaches, rough options, sketches. Not decisions. Each direction that becomes
a decision moves to an ADR.

| Direction | Notes | Becomes |
| --- | --- | --- |
| … | … | ADR-NNN · not yet · dropped (reason) |

## Open questions

Every unresolved point lives here. A question that blocks an ADR is resolved in chat
before that ADR is written (core/11).

| ID | Question | Blocks | Status |
| --- | --- | --- | --- |
| Q1 | … | ADR for … · nothing yet | open · resolved (answer, date) · dropped |

## ADRs

Filled from status `planning` onwards. ADRs live in the ADR folder (Docs layout); link
only. Each linked ADR names this initiative in its `Initiative` property.

| ADR | Decides | ADR status | Master plan |
| --- | --- | --- | --- |
| [ADR-NNN-slug](<path from Docs layout>) | … | Proposed · Accepted · Rejected · Superseded | link · none |

## Status log

Status and horizon changes, each confirmed by the engineer (core/07 §4).

- DD-MM-YYYY: created, status `idea`, horizon `someday`.
