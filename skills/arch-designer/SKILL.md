---
name: arch-designer
description: >-
  System architecture design workflow. Activates when designing systems, microservices,
  modular monoliths, data flows, or infrastructure boundaries. Enforces the 9 Architectural
  Pillars, C4 model diagrams, and generates Architecture Specs and ADRs.
---

# SYSTEM ARCHITECTURE DESIGN WORKFLOW

Activate this skill when requested to design a new software architecture, component boundary, or major technical migration.

## STEP-BY-STEP EXECUTION PROTOCOL

### Step 1: Requirements & Sizing Clarification
Before drawing diagrams, clarify or determine:
- **Traffic & Scale**: Expected Requests Per Second (RPS), data volume growth per month.
- **Latency & Availability Targets**: Target p95/p99 latency (e.g., < 100ms) and SLA (99.9% vs 99.99%).
- **Pragmatism Check**: Can this be satisfied by a clean Modular Monolith? Avoid premature distributed microservices unless organizational or scaling boundaries demand it.

### Step 2: Validate Against the 9 Architectural Pillars
Fill the Pillar Scorecard (rule `02-architectural-pillars`):
1. **HA**: Is there any Single Point of Failure (SPOF)? Are services multi-AZ?
2. **Resilience**: Are circuit breakers, retries with jitter, and DLQs planned?
3. **Scalability**: Are services stateless? Is caching (Cache-Aside) planned?
4. **Consistency**: Are distributed mutations backed by Outbox Pattern or Sagas? Are APIs idempotent?
5. **Security**: Is Zero Trust and Least Privilege applied?
6. **Privacy**: Is PII masked in logs and encrypted at rest?
7. **Observability**: Are Structured JSON logs, Metrics, and Distributed Tracing included?
8. **Extensibility**: Are feature flags and plugin/hook boundaries specified?
9. **Cost**: Is this cost-effective and right-sized for the organization?

### Step 3: Generate the 4 Standard Mermaid Diagrams
1. **Static View**: System Context & Containers (C4 L1/L2).
2. **Dynamic View**: Sequence Diagram with Happy Path AND Timeout/Failure branches.
3. **Integration View**: Event Bus, Asynchronous Queues, Outbox CDC, and DLQ flows.
4. **Deployment View**: VPC, Subnets, Kubernetes Pods / Serverless, Multi-AZ data tier.

### Step 4: Output Architecture Specification
Follow the `architecture-design` skill and `.docs/workflow.md` when they are installed: keep
the draft in the chat until the engineer is satisfied, then write the ADR (the architecture
spec for one topic) from `templates/adr.md` with status `Proposed`. Use
`templates/architecture-spec.md` only for a system-level overview, and place files per
`08-repo-layout-and-naming`; never invent a `docs/architecture/` tree.
