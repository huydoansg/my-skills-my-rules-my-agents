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
- **Initiatives may be ambiguous; nothing else may.** An idea the engineer wants to keep
  (product or technology) gets an initiative folder `NNN-DDMMYYYY-slug/` in the
  initiatives folder, with one shared initiatives roadmap. It may hold open questions,
  never authorizes work, and links to the ADRs created for it; the first ADR moves it to
  `planning` and adds that ADR to the technical roadmap (and the product roadmap for type
  `product`) ([`11-clarity-first`](.agents/rules/11-clarity-first.md) §6, skill
  `initiative-shaping`).
- **Plans follow the ADR.** One plan per component and outcome, tracked by the master plan;
  every task cites an ADR decision or invariant; a plan never makes a new decision.
- **Fit the need.** Restate the intent brief (goal, agreed approach, rejected approaches,
  non-goals, done measure, tooling needed) and get the engineer's confirmation before
  planning; read it again each session. Build tooling only as a planned task; a missing
  runner is proposed, not built. Local check tooling lives in `.agents/tools/` or
  `.agents/scripts/` (git-ignored) and is never committed or pushed. An edit to a plan or
  the master plan updates the other in the same change ([`11-clarity-first`](.agents/rules/11-clarity-first.md) §3.1,
  [`07-workflow-governance`](.agents/rules/07-workflow-governance.md) §5.1, §7).
- **Execution economy.** Name the output of each batch of work before running tools and
  stop when it is met. Fix a repeated setup failure at its cause; repeated cases go through
  one runner with logs to files; report only a checkpoint pass, a difference that changes
  the work, or a blocker ([`14-execution-economy`](.agents/rules/14-execution-economy.md)).
- **Documents people can read.** An ADR is a design a reader can follow: problem in product
  language, building blocks, flows with failure paths, trade-offs; reader test before saving
  ([`13-architecture-docs`](.agents/rules/13-architecture-docs.md)). Every document is one
  complete version (no patches, no Q&A), self-contained (no links to agent-only files), split
  instead of compressed ([`06`](.agents/rules/06-technical-writing-and-evidence-grounding.md) §8).
  Explain the fundamentals before asking the engineer to choose.
- **Plans keep behavior.** A plan states what consumers observe today, traced by reading the
  code; any difference not listed with an ADR reason is a defect (skill `implementation-planning`).
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
| Capture / grow an idea | `initiative-shaping` | Initiative folder, initiatives roadmap (Docs layout) |
| Evidence for an idea or a decision | `research` | Chat; saved to the initiative or ADR research folder when asked |
| Research + design → ADR | `architecture-design` | ADR folder (Docs layout) |
| Master plan + plans | `implementation-planning` | Plans folder (Docs layout) |
| Bug / crash / regression | `investigate-bugfix` | Regression test + fix commit/PR body |
| Verify implementation / fix | `implementation-verification` | ADR docs folder, or PR evidence |
| File too big / mixed responsibilities | `split-module` | Single-responsibility files, same behavior |
| After status changes / end of session | `brain-sync` | Indexes, roadmaps, component Current/Target state, one proposal table |

Flow: [`.agents/workflow.md`](.agents/workflow.md). Project-specific sections (commands,
architecture boundaries, conventions, **Docs layout**) belong in this file above this block.
