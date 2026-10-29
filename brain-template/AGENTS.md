# <Product> — Product Brain (agent entry)

This repository is the Product Brain of <Product>: the technical source of truth.
It holds documents only. Source code lives in the code repositories listed below.

## Code repositories

| Repo | Local path | Components |
| --- | --- | --- |
| <name> | `../<repo>` | <component>, <component> |

## Docs layout

| Artifact | Path |
| --- | --- |
| Product Brain root | `.` |
| ADR index | `decisions/README.md` |
| ADR folder | `decisions/ADR-NNN-slug/` (ADR file: `ADR-NNN-slug.md`) |
| Research folder | `<ADR folder>/.researchs/` |
| ADR docs folder | `<ADR folder>/.docs/` (contracts, verification reports) |
| Plans folder | `<ADR folder>/.plans/` |
| Architecture overview | `architecture.md` |
| Technical roadmap | `technical-roadmap.md` |
| Product roadmap | `product-roadmap.md` |
| Component cards | `components/<name>/README.md` |
| References | `references/` |

## Brain rules

- **Nothing before it is clear.** Research and design stay in chat until settled
  (`.agents/rules/11-clarity-first.md`); then create the ADR folder.
- **One ADR folder per decision.** Its research, contracts, plans and verification
  reports live inside it; nothing about a decision lives elsewhere.
- **Component names** in plan file names are folder names under `components/`.
- **No PRD, business documents or source code** in this repository.
- **Sync on every status change:** plan → master plan register → `technical-roadmap.md`
  (→ `product-roadmap.md` when a milestone changes), in one change.
