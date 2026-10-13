---
name: desktop-app-hardening
description: >-
  Electron and Tauri security auditing and IPC hardening workflow. Activates when building,
  auditing, or reviewing cross-platform desktop applications for security vulnerabilities,
  sandbox escapes, or memory leaks.
---

# DESKTOP APPLICATION HARDENING WORKFLOW

Activate this skill when reviewing Electron or Tauri codebases for security, IPC leaks, and resource efficiency.

## PROTOCOL

1. **Security Audit Checklist**:
   - **For Electron**:
     - [ ] `contextIsolation: true` in all WebPreferences.
     - [ ] `nodeIntegration: false` and `nodeIntegrationInWorker: false`.
     - [ ] `sandbox: true` enabled across all renderer windows.
     - [ ] All external URLs intercepted and opened with `shell.openExternal()`.
     - [ ] Preload script exposes only explicit typed methods via `contextBridge.exposeInMainWorld()`.
     - [ ] Content Security Policy (CSP) headers properly defined in HTML/HTTP headers.
   - **For Tauri**:
     - [ ] Capability configurations in `src-tauri/capabilities/` scoped to exact paths.
     - [ ] No wildcard filesystem permissions (`$HOME/**` forbidden).
     - [ ] Strict HTTP client allowed domains.
     - [ ] All command inputs validated in Rust before execution.

2. **IPC Channel Lockdown**:
   - Check every IPC listener (`ipcMain.on`, `ipcMain.handle`, `tauri::command`).
   - Ensure arguments are strongly validated (Zod schemas on frontend, serde/typed structs on backend).
   - Ensure no raw shell execution (`child_process.exec`, `std::process::Command`) accepts unsanitized user inputs.

3. **Memory & Lifecycle Audit**:
   - Verify that event listeners attached to windows are unregistered upon window closure.
   - Verify that background windows throttle timers (`backgroundThrottling: true`).
