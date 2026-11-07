# <Product> — Architecture overview

System-level view. Each section summarizes and links the Accepted ADRs that decide it;
detail lives in the ADRs. Update when an ADR is Accepted or an implementation differs
from its ADR. Full outline: `.agents/templates/architecture-spec.md`.

## 1. Context

```mermaid
---
title: <Product> in its environment (purpose - users, external systems, trust boundary)
---
flowchart LR
  U([User]) --> S[<Product>]
  S --> E([External system])
```

## 2. Components

| Component | Role | Code repo | Card | ADRs |
| --- | --- | --- | --- | --- |
| <name> | … | `<repo>` | [card](components/<name>/README.md) | ADR-NNN |

## 3. Cross-cutting concerns

| Concern | Decision | ADR |
| --- | --- | --- |
| Security | … | ADR-NNN |
| Observability | … | ADR-NNN |

## 4. Invariants (system-wide)

| ID | Invariant | ADR |
| --- | --- | --- |
