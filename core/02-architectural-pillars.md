# THE 9 ARCHITECTURAL PILLARS (MANDATORY EVALUATION MATRIX)

Whenever an Agent proposes an architecture, writes an Architecture Spec, or creates an ADR, it must evaluate the proposal against the **9 Architectural Pillars**.

A solution is **REJECTED** if it violates any pillar without an explicit mitigation and ADR trade-off approval.

---

## 1. HIGH AVAILABILITY (HA)
- **Zero Single Point of Failure (SPOF)**: Every component in the critical path must have redundant instances.
- **Multi-Zone Redundancy**: Workloads must be distributed across multiple Availability Zones (AZs) or distinct failure domains.
- **Automated Failover & Health Checks**: Workloads must support graceful restarts, liveness/readiness probes, and automated load balancer failover.
- **SLA Target**: Default design baseline is 99.9% uptime (< 8.76 hours downtime/year).

---

## 2. RESILIENCE & FAULT TOLERANCE
- **Timeouts & Circuit Breakers**: All synchronous out-of-process calls must have strict timeouts (p99 < 3s). Circuit breakers must trip when error rates exceed threshold (e.g., 50%).
- **Retries with Jitter**: Exponential backoff with random jitter to prevent "thundering herd" problems.
- **Graceful Degradation**: Fallback responses (e.g., cached stale data, degraded UI mode) when non-critical downstream services are unreachable.
- **Bulkheads & Dead-Letter Queues (DLQ)**: Failed asynchronous jobs must route to a DLQ with alerting; one failed queue must not starve system memory.

---

## 3. SCALABILITY & PERFORMANCE
- **Stateless Services**: Application instances must store no in-memory session state; state must reside in shared stores (e.g., Redis, DB).
- **Horizontal Elasticity**: Compute layer must scale out horizontally based on CPU/Memory or queue depth.
- **Caching Strategy**: Implement Cache-Aside or Write-Through with explicit Time-To-Live (TTL) and eviction policies. Never query the database repeatedly for immutable reference data.
- **Database Optimization**: All OLTP queries must utilize covering indexes. Explain plans must show zero sequential scans on large tables.

---

## 4. CONSISTENCY & DATA INTEGRITY
- **ACID vs. BASE Boundary**: Explicitly declare transactional boundaries. Within a single boundary, use ACID; across distributed boundaries, use Eventual Consistency.
- **Transactional Outbox Pattern**: When emitting events upon state changes, use the Outbox Pattern or Change Data Capture (CDC) to eliminate dual-write partial failures.
- **Idempotency**: All mutation APIs (POST/PATCH/DELETE) and asynchronous event handlers must be idempotent (using `Idempotency-Key` or unique transaction hashes).

---

## 5. SECURITY & ZERO TRUST
- **Least Privilege Access**: Services, users, and IAM roles must have the bare minimum permissions necessary.
- **Defense in Depth**: Security must exist at the network perimeter (WAF), transport layer (TLS 1.3 / mTLS), application layer (AuthN/AuthZ), and data layer.
- **Secrets Management**: Hardcoded credentials, API keys, or tokens in git are strictly prohibited. Use AWS Secrets Manager, Vault, or sealed secrets.
- **OWASP Top 10 Mitigation**: SQL injection, XSS, SSRF, CSRF, and broken access controls must have automated code-level defenses.

---

## 6. PRIVACY & COMPLIANCE
- **Data Minimization**: Collect and store only strictly necessary user data.
- **PII Protection**: Personally Identifiable Information (PII) must be encrypted at rest (AES-256) and masked in all application logs.
- **Audit Trails**: All reads and writes to sensitive financial, medical, or personal data must emit tamper-evident audit logs.
- **Right to Erasure**: Designs must accommodate customer deletion / anonymization requests.

---

## 7. OBSERVABILITY & TELEMETRY
- **Three Pillars of Observability**:
  - **Structured Logs**: JSON logs containing `timestamp`, `level`, `trace_id`, `span_id`, and contextual metadata.
  - **Metrics**: Standard Golden Signals (Latency, Traffic, Errors, Saturation) exported to Prometheus/Datadog/CloudWatch.
  - **Distributed Tracing**: OpenTelemetry trace context propagation across all HTTP and message queue boundaries.
- **Actionable Alerting**: Alerts must be routed on actionable symptoms (e.g., error rate > 1%), not vanity metrics.

---

## 8. EXTENSIBILITY & CUSTOMIZATION
- **Open for Extension**: Business logic must be modularized into pluggable components, middleware pipelines, or event subscribers.
- **Feature Flagging**: Risky architectural migrations or major features must be wrapped in dynamic feature flags for gradual canary rollouts and instant rollbacks.
- **Contract Versioning**: Public and internal APIs must have explicit semantic versioning (`/v1/`, `/v2/`) with deprecation policies.

---

## 9. PRAGMATISM & COST-EFFICIENCY
- **Right-Sizing**: Choose the simplest architecture that meets technical requirements. Avoid premature microservices or distributed systems when a clean Modular Monolith suffices.
- **Cloud Economics**: Minimize data egress costs, utilize auto-shutdown or spot instances for non-production environments, and optimize database provisioned IOPS.
- **Total Cost of Ownership (TCO)**: Factor developer cognitive load, operational complexity, and maintenance overhead into architectural choices.
