# Changelog

Changes to the agent kit that installed projects need to know about. Format based on
Keep a Changelog; **Breaking** entries list the migration.

## [Unreleased]

### Added

- `core/11-clarity-first`: clear → act; ambiguous → resolve until clear; never guess.
- `core/06` §7 Precision: banned vague words, one term per concept.
- Templates `master-plan.md` and `component.md`; `plan.md` rewritten as one component,
  one outcome, executor-ready task cards that cite the Accepted ADR.
- Skill `implementation-planning`: master plan + per-component plans, writing rules,
  builder check.
- Product Brain: `brain-template/`, `guides/product-brain.md`, `install.sh --brain`.
- `install.sh` removes symlinks left dangling by deleted rules, skills or templates.

### Changed

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
