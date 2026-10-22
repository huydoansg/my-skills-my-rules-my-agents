---
name: requirement-discovery
description: Optional first step for a large or unclear requirement — clarify, research, challenge assumptions and agree scope with the engineer in chat; write REQ files only after the engineer confirms. Use before architecture-design. Do not use for small, clear tasks or bugs.
metadata:
  revision: "rev 0"
---

# Requirement Discovery (optional)

Turn a raw request into a structured analysis that is good enough to start design. Do
not implement. Read `core/07-workflow-governance.md` and `core/09-language-and-communication.md` first.

## Use when / do not use when

- Use: a new feature or idea that needs clarification, codebase research or debate.
- Do not use: an ADR is already Accepted (→ `implementation-planning`); a bug (→
  `investigate-bugfix`); a simple lookup (answer directly); a small, clear change.

## Principles

1. **Chat first.** Do the analysis in chat. Write `raw.md` / `analysis.md` only after the
   engineer is satisfied and asks for them.
2. **Debate, do not flatter.** Challenge assumptions when you have grounds. If the request
   conflicts with the current architecture (AGENTS.md, ADRs, SAD) say so and propose an
   alternative. Never confirm a wrong belief.
3. **Evidence-based.** Claims about the codebase cite file/line; external claims cite a
   source (URL + access date). No guessing.
4. **Production-ready mindset.** Consider edge cases, failure modes, security, performance
   budget and every supported platform.
5. **Clarify intent.** Restate the request in plain English and resolve slang or
   ambiguity before documenting (core/09).

## Procedure

1. **Understand (chat).** Restate the request; list unclear phrases with candidate readings.
2. **Research context.** Read `AGENTS.md` boundaries, grep related code (cite file/line),
   read related ADRs (check status) and the SAD; search external practice when needed.
3. **Analyze (chat).** Cover: goal (problem, who is affected, value); scope (in/out);
   assumptions and risks (mark those needing verification); constraints (boundaries,
   budgets, platforms, security); conflicts with existing ADRs; open questions (specific,
   not generic); ≥ 2 options with pros/cons; a recommendation with reasons; AC with stable
   IDs, inputs, expected results, priority and edge/failure cases; debate (strongest
   counter-argument, evidence for/against, what would change the decision).
4. **Clarify.** Ask only questions that change scope, AC or risk; continue independent
   work meanwhile. Present trade-offs and let the engineer decide. If the engineer insists
   on a direction that breaks a boundary, record the risk and get explicit confirmation;
   never bypass it yourself.
5. **Persist (only when asked).** Create `.docs/requirements/REQ-YYYYMMDD-slug/`:
   `raw.md` (optional, original wording verbatim — see core/09 section 2), `analysis.md`
   from `.agents/templates/requirement.md` (confirmed English), update
   `requirements/INDEX.md` with status `analyzed`.
6. **Exit.** All open questions answered or marked "waiting for engineer"; no ambiguity
   blocks design. Suggest `architecture-design`.

## Failure / fallback

- Missing information → ask, do not invent.
- No precedent in the codebase → say "no precedent", treat as greenfield.
- Too large → propose splitting into sub-requirements, one folder each.

## Example (edge case)

Request: "let extensions read the core database directly." → analysis notes the conflict
with the ADRs on out-of-process extensions and brokered capabilities, proposes a
capability-broker handle instead, marks "engineer must confirm the risk of bypassing the
boundary", and does not implement.

## Revision history

- rev 0: (draft) generic version; chat-first, REQ files optional.
