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
   - Check Single Responsibility: Are there functions over 30 lines, or files holding several modules/classes/components? Run `.agents/tools/check-modularity.sh --all` and list offenders. For hotspots rank by size × recent churn: `git log --since=6.months --name-only --format= | sort | uniq -c | sort -rn | head -20`. Remediate with skill `split-module`.
   - Check Clean Boundaries: Does the Domain layer import external libraries, HTTP frameworks, or ORMs? (If yes, flag as boundary violation).
   - Check Dependency Inversion: Are database clients or network services instantiated directly inside business entities instead of being injected?

2. **DRY & Over-Abstraction Check**:
   - Are there duplicated business rules that should be consolidated?
   - Are there premature abstractions coupling unrelated domains?
   - **Over-engineering review** (`07-workflow-governance` §7). Applies to a master plan,
     a plan or a diff. Input: the intent brief and the plan or diff only. For each task,
     new file, tool, dependency and abstraction, answer:
     1. Which ID (`D-`, `I-`, `S-`, `INV-`, `AC-`) does it serve? None → `remove`.
     2. Does the project's existing test runner, linter, typechecker or an existing module already do it?
     3. Which failure does it detect, or which decision does it change? Unnamed → `remove`.
     4. Is it more general than the listed scope needs: an abstraction with one
        implementation, configuration nobody asked for, a unit outside the inventory?
     5. Does it bring back an approach the intent brief rejected?
     6. Who maintains it after the work is done, and when is it deleted?
   - Output for this review: `item | ID | keep · simplify · remove | reason | cheaper
     alternative`. Change nothing; the engineer decides each row.

3. **Defensive Coding & Type Safety**:
   - Check for `any` (TypeScript), untyped dicts (Python), `_ = err` (Go), or `.unwrap()` (Rust).
   - Are edge cases (null, empty list, network timeout, rate limiting) covered by explicit tests?

4. **Verify Each Finding**:
   - Record base and head commit and the target branch; read the whole diff and follow the
     callers and callees it touches. For a changed shared type, constant or facade, find its
     consumers.
   - Every suspected issue needs a concrete scenario and evidence. Drop it when the code or a
     test disproves it; keep unverified suspicions apart from confirmed findings.
   - Label how each finding was confirmed: **traced** (followed through the code path) or
     **reproduced** (run and observed, naming the layer). A passing build or unrelated test
     does not make a finding reproduced.
   - A review changes no code or commit on the reviewed branch. Temporary tests run in a
     separate worktree and are removed afterwards.

5. **Output Findings**:
   - Output structured findings table: File | Line | Issue | Severity (High / Med / Low) | Confirmed (traced · reproduced) | Recommended Remediation.
   - Priority is separate from verification level. Each issue is described in one place. A
     suggested fix is optional and must follow the target architecture; a finding stands
     without one.
