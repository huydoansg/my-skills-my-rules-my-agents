---
name: rust-optimizer
description: >-
  Rust performance, memory profiling, and safety auditing workflow. Activates when writing,
  benchmarking, or refactoring Rust code for high performance, zero allocations, or safety.
---

# RUST OPTIMIZER & AUDITOR WORKFLOW

Activate this skill when optimizing hot loops, eliminating memory allocations, auditing `unsafe` blocks, or profiling Rust applications.

## PROTOCOL

1. **Safety & Clippy Audit**:
   - Run `cargo clippy --all-targets --all-features -- -D warnings`.
   - Audit all instances of `unsafe`: verify that safety invariants are clearly documented with `// SAFETY:` comments.
   - Replace any `.unwrap()` or `.expect()` in non-test paths with proper error propagation (`?`, `thiserror`, or `anyhow`).

2. **Allocation & Lifetime Analysis**:
   - Inspect cloning: find unnecessary `.clone()` calls and convert them to borrowed references (`&str`, `&[T]`), `Cow<'a, T>`, or shared ownership (`Arc<T>`).
   - Use small-string or small-vector optimizations (`smallvec`, `compact_str`) if dealing with millions of short strings.
   - Pre-allocate collection capacities with `Vec::with_capacity(n)` and `HashMap::with_capacity(n)` when size is known or estimable.

3. **Concurrency & Tokio Audit**:
   - Ensure long-running synchronous or CPU-intensive operations are dispatched via `tokio::task::spawn_blocking`.
   - Verify that channels (`mpsc`, `broadcast`) have bounded buffers (`channel(buffer_size)`) to prevent unbounded memory growth under load.
