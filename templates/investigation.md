# INV-YYYYMMDD-slug

| Property | Value |
| --- | --- |
| ID | INV-YYYYMMDD-slug |
| Created | YYYY-MM-DD |
| Revision | rev 0 |
| Status | open |
| Bug summary | one sentence |
| Severity | high / medium / low |
| Related | commit / ADR / REQ if any |

## Reproduction

### Environment

- OS / architecture:
- Runtime and tool versions:
- Profile / configuration:
- Data directory (isolated, fake data):
- Model / external service (if relevant):

### Steps

1. …
2. …

### Expected

…

### Actual

```
(paste the log; redact secrets/PII with [REDACTED: type], keep everything else verbatim)
```

### Reproduced?

- [ ] yes (log above)
- [ ] no (see "Cannot reproduce")

## Cannot reproduce (if applicable)

- Collected: …
- Needed from the engineer: …
- Do NOT fix until it reproduces.

## Hypothesis log

Record every hypothesis, including wrong ones, to avoid repeating work.

| # | Hypothesis | Verification method | Result | Evidence |
| --- | --- | --- | --- | --- |
| H1 | … | test / log / bisect | right / wrong | … |

## Root cause

(Write only when proven.)

**Root cause:** … (mechanism, not only the symptom)
**Evidence:** file + lines, log or test
**Layer:** (per the project's architecture boundaries)

## Fix plan (TDD)

Write the reproduction test first, then the fix.

1. Reproduction test → FAILS (red), proving the bug reproduces.
2. Implement the fix → test PASSES (green).
3. Refactor while it stays green.

- **Fix at layer:** …
- **Reproduction test:** (name; must FAIL before the fix)
- **Regression test:** (goes into the main suite)
- **Side effects:** modules / schema / migration impact
- **Risk:** low / medium / high — reason
- **Verification:** the project's test, lint, boundary and schema commands

## Acceptance criteria and evidence

| AC | Input / expected | Test + cwd | RED / GREEN log + exit code | Status |
| --- | --- | --- | --- | --- |
| AC1 | fill | fill | not run yet | not-run |

Pin commit + dirty diff, time and fixture. Severity and fix risk are separate. Medium/high
risk: migration, boundary, credentials or large blast radius.

## Gating the fix

Execute the fix only when:

- [ ] Root cause is proven (evidence above)
- [ ] Reproduction test is written and FAILS
- [ ] Engineer approved the fix plan (if risk is medium/high)

## Fix log

| Time | Action | Result |
| --- | --- | --- |
| | | |

## Post-fix checklist

Each applicable item needs pass + evidence; N/A needs a reason; blocked/not-run items are
not ticked before claiming "fixed".

### Test
- [ ] Reproduction test PASSES after the fix
- [ ] Full test suite passes
- [ ] End-to-end tests pass (if UI touched)
- [ ] TDD: reproduction test FAILED before the fix, PASSED after

### Code quality
- [ ] format check, lint, typecheck/compile pass with zero warnings

### Architecture & schema
- [ ] boundary check: 0 violations
- [ ] schema check valid (if a schema was touched)

### Non-functional (if the bug touches NFRs)
- [ ] Security / Performance / Reliability as relevant

### Cross-platform (if relevant)
- [ ] Every required platform passes

### Docs
- [ ] Status → `fixed`, commit linked; changelog entry
- [ ] Revision unchanged unless the engineer confirmed a bump
- [ ] If architecture was touched: ADR accepted before the fix, with an evidence link

## Approval and evidence snapshot

- Approval: none yet; fill only when the engineer confirms this exact content.
- Who / when / message reference: none yet.
- Applies to: artifact + revision + commit or snapshot hash.
- Unapproved changes: `(draft): …`; downstream needs re-review if scope/AC/NFR changes.

## Revision history

- rev 0: created (YYYY-MM-DD)
