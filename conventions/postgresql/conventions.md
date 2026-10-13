# POSTGRESQL ARCHITECTURE & RELATIONAL DATA CONVENTIONS

## 1. SCHEMA DESIGN & DATA MODELING
- **Primary Keys**: Use UUIDv7 or `BIGINT GENERATED ALWAYS AS IDENTITY`. Avoid UUIDv4 as primary keys in high-insert tables due to B-Tree page fragmentation.
- **Naming Conventions**:
  - Tables: snake_case, plural (e.g., `users`, `order_items`).
  - Columns: snake_case, explicit (e.g., `created_at`, `is_active`, `user_id`).
  - Foreign Keys: `<singular_table>_id` (e.g., `customer_id`).
- **Enforce Constraints in the DB**:
  - Always declare `NOT NULL`, `CHECK`, and `FOREIGN KEY` constraints in PostgreSQL. Application-level validation is never a substitute for relational database integrity.
  - Timestamps: Always use `TIMESTAMPTZ` (timestamp with time zone). Never use `TIMESTAMP` without time zone.

## 2. INDEXING STRATEGIES & QUERY OPTIMIZATION
- **Foreign Key Indexing**: Always add explicit indexes to foreign key columns; PostgreSQL does not create foreign key indexes automatically.
- **Partial & Covering Indexes**:
  - Use partial indexes for queries targeting specific flags (e.g., `WHERE is_deleted = false` or `WHERE status = 'PENDING'`).
  - Use `INCLUDE` columns for covering indexes to achieve Index-Only Scans.
- **No Sequential Scans in OLTP**:
  - Every production query must have an `EXPLAIN (ANALYZE, BUFFERS)` execution plan with zero un-indexed sequential scans on tables with > 1,000 rows.
  - Avoid `SELECT *`. Explicitly project only needed columns.

## 3. TRANSACTIONS & CONCURRENCY CONTROL
- **Short Transaction Lifecycles**:
  - Keep transactions as brief as possible (< 50ms). Never make external HTTP or third-party API calls inside an open SQL transaction.
- **Pessimistic vs. Optimistic Locking**:
  - For financial or inventory balance updates, use `SELECT ... FOR UPDATE` with deterministic ordering to prevent deadlocks, or use optimistic concurrency with a `version` column.
- **Connection Pooling**: Always place a connection pooler (e.g., **PgBouncer** or **AWS RDS Proxy**) between application instances and PostgreSQL to manage server process overhead.

## 4. DATABASE MIGRATIONS (ZERO-DOWNTIME)
- **The Expand / Contract Pattern**:
  - **Step 1 (Expand)**: Add new column as nullable or with a default. Deploy code that writes to both old and new columns.
  - **Step 2 (Backfill)**: Backfill data in small asynchronous batches.
  - **Step 3 (Switch)**: Deploy code that reads only from new column.
  - **Step 4 (Contract)**: Drop old column in a subsequent release.
- **Safe DDL Operations**:
  - Always create indexes concurrently: `CREATE INDEX CONCURRENTLY`.
  - Set a `statement_timeout` and `lock_timeout` before executing DDL migrations to avoid blocking table locks.
