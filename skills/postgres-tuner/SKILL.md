---
name: postgres-tuner
description: >-
  PostgreSQL query performance tuning and schema migration safety. Activates when authoring
  database migrations, analyzing slow queries, or designing indexing and table partitioning schemes.
---

# POSTGRESQL TUNER & MIGRATION WORKFLOW

Activate this skill when optimizing SQL queries, adding indexes, or planning zero-downtime database migrations.

## PROTOCOL

1. **Slow Query Analysis with `EXPLAIN (ANALYZE, BUFFERS)`**:
   - Run `EXPLAIN (ANALYZE, BUFFERS, COSTS, VERBOSE)` on target queries.
   - Look for:
     - Sequential Scans (`Seq Scan`) on large tables -> Add targeted B-Tree, GIN, or BRIN indexes.
     - High Shared Hit Buffers / High Temp Spills to Disk -> Increase `work_mem` or adjust join strategies.
     - High Cost Hash Joins / Nested Loops without index lookups.

2. **Index Strategy Design**:
   - Always verify if a **Covering Index** (`INCLUDE (col1, col2)`) allows an **Index Only Scan**, avoiding heap table access completely.
   - Use **Partial Indexes** for skewed data (e.g., `CREATE INDEX ON orders (created_at) WHERE status = 'PENDING'`).
   - Remember that multi-column indexes `(A, B)` only support queries filtering on `(A)` or `(A, B)`, not on `(B)` alone.

3. **Zero-Downtime Migration Execution**:
   - Create all production indexes using `CREATE INDEX CONCURRENTLY`.
   - Never add a column with a non-constant `DEFAULT` on tables without PostgreSQL 11+ fast default support.
   - Set migration lock timeouts:
     ```sql
     SET lock_timeout = '2s';
     SET statement_timeout = '30s';
     ```
   - For column drops/renames, always execute via the Expand/Contract phased rollout.
