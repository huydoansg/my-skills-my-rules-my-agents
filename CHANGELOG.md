# Changelog

Changes to the agent kit that installed projects need to know about. Format based on
Keep a Changelog; **Breaking** entries list the migration.

## [Unreleased]

### Added

- **Initiatives**: an idea the engineer wants to keep (product or technology) gets a folder
  `NNN-DDMMYYYY-slug/` (card `README.md`, `context.md`, `.researchs/`), an index and one
  shared roadmap for all initiatives. Status `idea → exploring → planning → in-progress →
  done`, `parked`, `dropped`. Ambiguity is allowed (`core/11` §6) but an initiative never
  authorizes work. ADRs stay in the ADR folder and link both ways (ADR `Initiative`
  property); the first ADR moves the initiative to `planning` and adds the ADR to the
  technical roadmap, and to the product roadmap for type `product` (`core/07` §5).
  Templates `initiative.md`, `initiative-context.md`, `initiatives-roadmap.md`; skill
  `initiative-shaping`; `brain-template/initiatives/`; Docs layout rows and naming in
  `core/08` (creation date allowed in initiative folder names only); Initiative column in
  both roadmaps. Existing projects: add the three Initiatives rows to the Docs layout
  table to use them; nothing has to move.

- `core/12-modularity`: one responsibility per file, no several modules in one file, thin
  `main`, ratchet for over-limit files, limits by file kind.
- `tools/check-modularity.sh`: agent-independent (POSIX sh) check of lines, top-level types
  and functions; baseline ratchet (`--init`, `--shrink`); silent when clean. `limits.default`,
  `pre-commit-hook.sh`, `ci-example.yml`. `install.sh` installs them to `.agents/tools/`,
  creates `.agents/limits` and a git pre-commit hook.
- Skill `split-module`: split God files by responsibility without behavior change.
- `tests/check-modularity.test.sh`: regression tests for the check (kit only, not installed).
- `plan.md` task field **File responsibility** and ready-gate item; code-auditor hotspot check.

- `core/11-clarity-first`: clear → act; ambiguous → resolve until clear; never guess.
- `core/06` §7 Precision: banned vague words, one term per concept.
- Templates `master-plan.md` and `component.md`; `plan.md` rewritten as one component,
  one outcome, executor-ready task cards that cite the Accepted ADR.
- Skill `implementation-planning`: master plan + per-component plans, writing rules,
  builder check.
- Product Brain: `brain-template/`, `guides/product-brain.md`, `install.sh --brain`.
- `install.sh` removes symlinks left dangling by deleted rules, skills or templates.

### Changed

- `core/01` file-size rule now points to `core/12`; `core/03` verification loop runs the check.
- `core/08`: rules and skills use artifact names; paths come from a **Docs layout** table
  in each project's `AGENTS.md`.
- `core/07`: bugfix evidence lives in chat, the fix commit/PR body and a regression test.
- Workflow installed at `.agents/workflow.md`.

### Removed — Breaking

- Skill `requirement-discovery`; templates `investigation.md`, `requirement.md`,
  `developer-guidelines.md`. **Migration:** requirements live outside the technical docs;
  bugs follow `investigate-bugfix` (evidence in chat + PR); existing files may stay.
- `install.sh --with-docs`. **Migration:** add a Docs layout table to `AGENTS.md`
  (existing `.docs/` paths are valid values), or scaffold a brain with `--brain`.
- `.docs/workflow.md` is no longer written. **Migration:** delete it; use `.agents/workflow.md`.
- Projects with the policy block already in `AGENTS.md`: delete the block between
  `<!-- BEGIN/END my-skills-policy -->` and re-run `install.sh` to receive the new policy.
