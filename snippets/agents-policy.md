## Agent workflow policy (managed by my-skills-my-rules-my-agents)

- **Clarity first.** Clear → act. Ambiguous → brainstorm, research or investigate until it
  is clear; if it cannot be resolved in scope, stop and ask. Never guess, never document or
  implement an unresolved point
  ([`11-clarity-first`](.agents/rules/11-clarity-first.md)).
- **Language.** The engineer may chat in any language; reply in the language they use.
  Everything written to files (docs, comments, commits) is English. Restate the intent in
  English and resolve slang or ambiguity in chat before documenting
  ([`09-language-and-communication`](.agents/rules/09-language-and-communication.md)).
- **Chat first, document later.** Research, brainstorm and draft the design with the
  engineer in the chat window. Create ADR/plan files only when the engineer is satisfied
  and asks for them; never spend tokens on documents for unsettled ideas.
- **Gated execution (hard block).** Do not implement or fix until the gate is met:
  - New feature / behavior or architecture change → the topic's ADR is `Accepted` (or N/A
    with a reason and a pointer to the governing ADR) **and** its plan is `ready`.
  - Bug fix → reproduction + root-cause evidence settled in chat, recorded in the fix
    commit/PR body, with a regression test that fails before the fix. No blind fixes.
  - Research, drafts and safe reproductions are always allowed. Line count never waives a gate.
  - Docs/rules/formatting-only changes use a review checklist, not app tests.
- **Plans follow the ADR.** One plan per component and outcome, tracked by the master plan;
  every task cites an ADR decision or invariant; a plan never makes a new decision.
- **Evidence-based.** Claims about the codebase cite file/line; external claims cite a
  source (URL, access date, version). Never conclude without proof.
- **Latest information.** For models, runtimes, libraries and best practices, check current
  primary sources instead of memory or old repo docs.
- **Respect boundaries and invariants.** Follow the architecture boundaries in this file and
  the ADR invariants (`NNN-In`). If a task needs a violation, stop and ask; fix the ADR first.
- **Update status after completing work.** Propose `artifact | old → new | evidence |
  missing`, wait for the engineer's confirmation, then update the plan, the master plan and
  the roadmaps together.
- **Put documents in the right place.** Paths for ADRs, plans, research, roadmaps and
  component cards come from the **Docs layout** table in this file (usually pointing to
  the product's Product Brain repo). No table → ask before creating any document
  ([`08-repo-layout-and-naming`](.agents/rules/08-repo-layout-and-naming.md)).
- **SDKs and libraries.** If this repository publishes a package, every public-surface
  change is classified with SemVer, kept backward compatible where possible and recorded
  in `CHANGELOG.md`; tags and publishes need explicit authorization
  ([`sdk-library`](.agents/rules/conventions/sdk-library.md), skills `sdk-api-evolution`,
  `sdk-release`).
- **One responsibility per file.** Never put several modules, classes or components in one
  file; a new concept gets a new file; `main` stays thin; a file over its limit may not grow.
  Run `.agents/tools/check-modularity.sh` before reporting done; on a block, split with skill
  `split-module`, never raise a limit or edit the baseline
  ([`12-modularity`](.agents/rules/12-modularity.md)).
- **Governance first.** Read [`07-workflow-governance`](.agents/rules/07-workflow-governance.md)
  before any workflow skill.

| Stage | Skill | Output |
| --- | --- | --- |
| Research + design → ADR | `architecture-design` | ADR folder (Docs layout) |
| Master plan + plans | `implementation-planning` | Plans folder (Docs layout) |
| Bug / crash / regression | `investigate-bugfix` | Regression test + fix commit/PR body |
| Verify implementation / fix | `implementation-verification` | ADR docs folder, or PR evidence |
| File too big / mixed responsibilities | `split-module` | Single-responsibility files, same behavior |

Flow: [`.agents/workflow.md`](.agents/workflow.md). Project-specific sections (commands,
architecture boundaries, conventions, **Docs layout**) belong in this file above this block.
