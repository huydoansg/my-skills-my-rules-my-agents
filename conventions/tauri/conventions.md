# TAURI DESKTOP ENGINEERING & SECURITY CONVENTIONS

## 1. TAURI ARCHITECTURE & BOUNDARIES
- **Clear Separation of Concerns**:
  - The Web Frontend (React, TypeScript) handles UI rendering and user interactions.
  - The Rust Backend handles all OS interactions, filesystem access, native networking, cryptography, and heavy compute.
  - Never attempt to perform unvalidated OS-level mutations from JavaScript.

## 2. TAURI V2 CAPABILITIES & PERMISSION SECURITY
- **Principle of Least Privilege**:
  - Tauri v2 introduces a granular capability and permission model in `src-tauri/capabilities/`.
  - Never enable wildcard permissions (e.g., `fs:default` with access to the entire root filesystem `$HOME/**`).
  - Restrict filesystem access specifically to `$APPDATA` or `$RESOURCE` directories.
  - Only whitelist exact URLs in the HTTP client permissions.

```json
{
  "$schema": "../gen/schemas/desktop-schema.json",
  "identifier": "main-capability",
  "description": "Capability for the main window",
  "windows": ["main"],
  "permissions": [
    "core:default",
    {
      "identifier": "fs:allow-read-text-file",
      "allow": [{ "path": "$APPDATA/**" }]
    }
  ]
}
```

## 3. IDIOMATIC TAURI IPC COMMANDS
- **Strongly Typed Commands**:
  - Always type command arguments and return values using Rust structs that implement `serde::Deserialize` and `serde::Serialize`.
  - Handle errors cleanly with Rust `Result<T, AppError>` where `AppError` implements `serde::Serialize`. Never panic inside Tauri command handlers.

```rust
use serde::{Deserialize, Serialize};

#[derive(Serialize)]
pub struct FileMetadata {
    pub name: String,
    pub size_bytes: u64,
}

#[tauri::command]
pub async fn read_file_meta(path: String) -> Result<FileMetadata, String> {
    // Validate path and fetch metadata
    let metadata = std::fs::metadata(&path).map_err(|e| e.to_string())?;
    Ok(FileMetadata {
        name: path,
        size_bytes: metadata.len(),
    })
}
```

## 4. ASYNC STATE & MANAGED RUNTIME
- Use `tauri::State` for shared backend state (e.g., database connection pool, API clients).
- Protect mutable state with Tokio `Mutex` or `RwLock` when accessed across async command invocations.
- Keep binary size optimal: strip debug symbols in release builds (`[profile.release] lto = true, strip = true, opt-level = "z"`).
