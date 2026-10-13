# BLAMELESS POSTMORTEM: [Incident Title]

- **Date:** [YYYY-MM-DD]
- **Incident Commander:** [Name]
- **Severity Level:** [SEV-1 | SEV-2 | SEV-3]
- **Impact Duration:** [e.g., 42 minutes]
- **User Impact:** [e.g., ~1,200 users experienced 504 errors on checkout]

---

## 1. INCIDENT SUMMARY
[High-level summary of what happened, root cause, and how it was resolved]

---

## 2. TIMELINE (UTC)
- `14:02` - Deployment of version v1.2.4 initiated.
- `14:08` - PagerDuty alert triggered: Checkout 5xx rate > 2%.
- `14:15` - Incident Commander declared SEV-1; rollback started.
- `14:22` - Rollback to v1.2.3 completed; traffic stabilized.
- `14:44` - Incident closed; monitoring confirmed normal latency.

---

## 3. ROOT CAUSE ANALYSIS (5 WHYS)
1. **Why did checkouts fail?** Connection pool exhausted on database.
2. **Why was the pool exhausted?** A new unindexed query ran sequential scans on the 10M-row orders table.
3. **Why was the query slow?** Missing composite index on `(user_id, status)`.
4. **Why wasn't this caught in CI?** CI tests ran against empty sqlite/in-memory database without scale datasets.
5. **Why was deployment not caught in canary?** Canary health check only tested `/healthz`, not database query latency.

---

## 4. ACTION ITEMS & PREVENTATIVE MEASURES
| Action Item | Type | Owner | Deadline |
|---|---|---|---|
| Add composite index `(user_id, status)` concurrently | Fix | DBA / Backend | 2026-10-15 |
| Add synthetic database query latency tests in staging | Prevention | QA / DevOps | 2026-10-20 |
| Configure RDS connection pool saturation alarm | Detection | SRE | 2026-10-16 |
