# RUST PROGRAMMING & ARCHITECTURE CONVENTIONS

## 1. IDIOMATIC RUST & TYPE SAFETY
- **Newtype Pattern**: Wrap primitive types in single-field tuple structs (e.g., `struct UserId(Uuid);`) to enforce domain invariants and prevent parameter mismatch bugs at compile-time.
- **Zero-Cost Abstractions**: Leverage Rust's trait system and generics. Avoid dynamic dispatch (`dyn Trait`) in hot loops unless heterogeneous collections are strictly required.
- **Strict Clippy Enforced**: Treat all warnings as errors in CI:
  ```bash
  cargo clippy --all-targets --all-features -- -D warnings
  ```

## 2. ERROR HANDLING EXCELLENCE
- **Libraries vs. Applications**:
  - In **libraries/modules**: Use `thiserror` to define strongly typed, domain-specific enum errors. Never return generic error strings.
  - In **applications/binaries**: Use `anyhow::Result` with `.context("...")` to provide clear stack trace contexts for logging.
- **Never Panic in Production Code**:
  - Never call `.unwrap()` or `.expect()` in production paths.
  - Use pattern matching (`match`, `if let`), `?` operator, or `.unwrap_or_default()` / `.ok_or_else()`.
  - The only acceptable place for `.unwrap()` is in unit tests or when an invariant is mathematically guaranteed and documented.

```rust
use thiserror::Error;

#[derive(Error, Debug)]
pub enum DatabaseError {
    #[error("connection to database timed out after {timeout_secs}s")]
    Timeout { timeout_secs: u64 },
    #[error("entity with id {0} not found")]
    NotFound(String),
    #[error("underlying sql error: {0}")]
    Sql(#[from] sqlx::Error),
}
```

## 3. OWNERSHIP, BORROWING & MEMORY
- **Borrowing Preferences**: Prefer passing borrowed slices (`&str`, `&[T]`) over owned types (`String`, `Vec<T>`) in function arguments unless ownership transfer is strictly required.
- **Avoid Unnecessary Cloning**:
  - Do not use `.clone()` blindly to satisfy the borrow checker.
  - Re-evaluate lifetimes or design with references, `Rc`/`Arc`, or interior mutability (`RwLock`/`Mutex`) where appropriate.
- **Zero-Unsafe Policy**: Do not write `unsafe` code unless doing FFI or writing audited low-level primitives. Mark unsafe blocks with clear safety documentation comments (`// SAFETY: ...`).

## 4. CONCURRENCY & ASYNC (TOKIO)
- **Non-blocking Async**:
  - Never run CPU-bound blocking operations (e.g., crypto, file I/O, heavy parsing) directly inside async tasks on Tokio threads.
  - Offload blocking work via `tokio::task::spawn_blocking`.
- **Cancellation Safety**: Ensure all async loops, channels, and `select!` branches are cancellation-safe and do not leak resources upon cancellation.
- **Graceful Shutdown**: Implement clean shutdown loops listening for `tokio::signal::ctrl_c()`, closing channels, and waiting for worker threads to finish.

## 5. LOGGING, TESTS, NAMING & PERFORMANCE
- **Logging**: Use `tracing` macros (`info!`, `warn!`, `error!`, `debug!`); never `println!`/`eprintln!` in library code. Never log secrets or PII.
- **Async runtime & locks**: Use one runtime (`tokio`). Use `std::sync::Mutex` for short critical sections that never hold the guard across `.await`; use `tokio::sync::Mutex` only when the guard must cross `.await`. Use `Arc<T>` (not `Rc<T>`) for shared state in async code.
- **Tests**: Unit tests in `#[cfg(test)] mod tests`, integration tests in `tests/`. Use `#[tokio::test]` for async (`flavor = "multi_thread"` when `block_in_place` is needed). Name tests by behavior (`it_<does_x>_when_<condition>`) and assert concrete values, not `assert!(result.is_ok())`.
- **Docs**: Public APIs have `///` doc comments; keep comments accurate and update them when behavior changes.
- **Naming**: `snake_case` fn/var/module/file, `SCREAMING_SNAKE_CASE` const/static, `PascalCase` type/trait/enum/variant, `kebab-case` crate names.
- **Hot paths**: Avoid allocations in hot paths; prefer `&str` over `&String`; batch database writes in transactions.
