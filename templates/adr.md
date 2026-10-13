# ADR-[NNNN]: [Short Title of Architectural Decision]

- **Status:** [Proposed | Accepted | Rejected | Deprecated | Superseded by ADR-xxxx]
- **Date:** [YYYY-MM-DD]
- **Deciders:** [Architects / Engineers involved]
- **Relevant Spec:** [Spec Link](docs/architecture/specs/spec-name.md)

---

## 1. CONTEXT & PROBLEM STATEMENT
[Describe the context, technical challenges, and business forces driving this decision. Why is a decision required now?]

---

## 2. DECISION DRIVERS & 9 PILLARS IMPACT
- Driver 1: [e.g., Latency requirement < 50ms (Scalability)]
- Driver 2: [e.g., Zero downtime requirement (High Availability)]
- Driver 3: [e.g., Infrastructure cost constraint (Pragmatism & Cost)]

---

## 3. CONSIDERED OPTIONS
1. **Option 1:** [Name & summary]
2. **Option 2:** [Name & summary]
3. **Option 3:** [Name & summary]

---

## 4. DECISION OUTCOME
Chosen Option: **[Option N]**, because:
- [Key justification 1]
- [Key justification 2]

### Trade-Off Scorecard
| Metric / Pillar | Option 1 | Option 2 (Chosen) | Option 3 |
|---|---|---|---|
| **Performance / Latency** | Moderate | High | Very High |
| **Operational Complexity** | Low | Moderate | High |
| **Infrastructure Cost** | Low | Moderate | High |
| **Resilience & HA** | Moderate | High | High |

---

## 5. CONSEQUENCES
- **Positive Consequences:**
  - ...
- **Negative Consequences & Mitigations:**
  - **Negative:** [e.g., Increased memory usage on worker nodes]
  - **Mitigation:** [e.g., Enforce explicit Kubernetes memory limits and HPA triggers]
