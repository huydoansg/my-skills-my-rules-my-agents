## 📌 SUMMARY OF CHANGES
- [Concise explanation of the changes and motivation]

## 🎯 ARCHITECTURAL & PILLARS COMPLIANCE
- [ ] **High Availability & Resilience**: No SPOF introduced; timeouts and retries calibrated.
- [ ] **Security & Privacy**: No hardcoded secrets; inputs validated at boundaries; no PII logged.
- [ ] **Data Consistency**: Transactions are atomic; mutations are idempotent.
- [ ] **Observability**: Structured logs and telemetry intact; no noisy debug prints left behind.

## 🔌 PUBLIC API & VERSIONING (SDKs / libraries only)
- **SemVer impact**: none / PATCH / MINOR / MAJOR — reason: [...]
- [ ] API diff tool run against the last release (command + result linked).
- [ ] `CHANGELOG.md` `Unreleased` updated; breaking entries marked `**Breaking:**` with migration link.
- [ ] Deprecations state since / replacement / removal target / migration link.
- [ ] Breaking change: ADR [link] `Accepted`; commit uses `!` / `BREAKING CHANGE:`.

## 🧪 VERIFICATION CHECKLIST
- [ ] Code formatted and linted (0 warnings).
- [ ] Typecheck passed (strict mode, 0 errors).
- [ ] Unit tests added / updated and passing.
- [ ] Integration / E2E tests verified.
- [ ] Migration backward-compatible (if database or schema modified).

## 📸 SCREENSHOTS / DIAGRAMS (If applicable)
[Add UI screenshots or Mermaid diagrams here]
