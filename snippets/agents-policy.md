## Agent workflow policy (managed by my-skills-my-rules-my-agents)

- **Language.** The engineer may chat in any language; reply in the language they use.
  Everything written to files (docs, comments, commits) is English. Restate the intent in
  English and resolve slang or ambiguity in chat before documenting
  ([`09-language-and-communication`](.agents/rules/09-language-and-communication.md)).
- **Chat first, document later.** Research, brainstorm and draft the design with the
  engineer in the chat window. Create ADR/plan files only when the engineer is satisfied
  and asks for them; never spend tokens on documents for unsettled ideas.
- **Gated execution (hard block).** Do not implement or fix until the gate is met:
  - New feature / behavior or architecture change → the topic's ADR is `Accepted` (or N/A
    with a reason and a pointer to the governing ADR) **and** a PLAN is `ready`.
  - Bug fix → reproduction + root-cause evidence in an `INV-*` report. No blind fixes.
  - Research, drafts and safe reproductions are always allowed. Line count never waives a gate.
  - Docs/rules/formatting-only changes use a review checklist, not app tests.
- **Evidence-based.** Claims about the codebase cite file/line; external claims cite a
  source (URL, access date, version). Never conclude without proof.
- **Latest information.** For models, runtimes, libraries and best practices, check current
  primary sources instead of memory or old repo docs.
- **Respect boundaries and invariants.** Follow the architecture boundaries in this file and
  the ADR invariants (`NNN-In`). If a task needs a violation, stop and ask; fix the ADR first.
- **Update status after completing work.** Propose `artifact | old → new | evidence |
  missing`, wait for the engineer's confirmation, then update the artifact, INDEX, plan and
  roadmap together.
- **Put documents in the right place.** `.agents/` = agent tooling, `.docs/` = product and
  architecture ([`08-repo-layout-and-naming`](.agents/rules/08-repo-layout-and-naming.md)).
- **SDKs and libraries.** If this repository publishes a package, every public-surface
  change is classified with SemVer, kept backward compatible where possible and recorded
  in `CHANGELOG.md`; tags and publishes need explicit authorization
  ([`sdk-library`](.agents/rules/conventions/sdk-library.md), skills `sdk-api-evolution`,
  `sdk-release`).
- **Governance first.** Read [`07-workflow-governance`](.agents/rules/07-workflow-governance.md)
  before any workflow skill.

| Stage | Skill | Output |
| --- | --- | --- |
| Large requirement (optional) | `requirement-discovery` | `.docs/requirements/REQ-*` |
| Research + design → ADR | `architecture-design` | `.docs/research/*`, then `.docs/adr/ADR-*` |
| Implementation plan | `implementation-planning` | `.docs/plans/PLAN-*` |
| Bug / crash / regression | `investigate-bugfix` | `.docs/investigations/INV-*` |
| Verify implementation / fix | `implementation-verification` | `.docs/verifications/VER-*` |

Flow: [`.docs/workflow.md`](.docs/workflow.md). Project-specific sections (commands,
architecture boundaries, conventions) belong in this file above this block.
