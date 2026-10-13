---
name: code-auditor
description: >-
  Rigorous code quality and architecture compliance audit workflow. Activates when performing
  code reviews, refactoring assessments, or pre-merge audits against SOLID, DRY, and Clean Code standards.
---

# RIGOROUS CODE AUDIT WORKFLOW

Activate this skill when reviewing code, conducting PR assessments, or auditing technical debt.

## PROTOCOL

1. **SOLID & Clean Architecture Review**:
   - Check Single Responsibility: Are there functions over 30 lines or classes over 300 lines doing multiple jobs?
   - Check Clean Boundaries: Does the Domain layer import external libraries, HTTP frameworks, or ORMs? (If yes, flag as boundary violation).
   - Check Dependency Inversion: Are database clients or network services instantiated directly inside business entities instead of being injected?

2. **DRY & Over-Abstraction Check**:
   - Are there duplicated business rules that should be consolidated?
   - Are there premature abstractions coupling unrelated domains?

3. **Defensive Coding & Type Safety**:
   - Check for `any` (TypeScript), untyped dicts (Python), `_ = err` (Go), or `.unwrap()` (Rust).
   - Are edge cases (null, empty list, network timeout, rate limiting) covered by explicit tests?

4. **Output Findings**:
   - Output structured findings table: File | Line | Issue | Severity (High / Med / Low) | Recommended Remediation.
