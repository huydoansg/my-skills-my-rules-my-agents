# REPO LAYOUT & DOCUMENT NAMING

Read this **before creating or moving any document**. A project may override the
defaults below in its own `AGENTS.md`; if it does, the project wins and the override
must be listed there.

## 1. Two roots, two purposes

| Root | Holds | Examples |
| --- | --- | --- |
| `.agents/` | Agent-tooling only: how agents work in this repo | `rules/`, `skills/`, `templates/`, `requests/` |
| `.docs/` | Everything about the product and its architecture | ADR, SAD, plans, research, requirements, guides, verifications |

Both are committed. Do not create `docs/` or `.agents/docs/`.

## 2. Where each artifact goes

| Artifact | Location |
| --- | --- |
| ADR (= the SAD for one topic; created only after the engineer is satisfied with the chat draft) | `.docs/adr/ADR-NNN-slug.md` + `.docs/adr/README.md` (index) |
| System-level design overview (SAD) | `.docs/sad/` (updated when an ADR is Accepted) |
| Requirement (optional) | `.docs/requirements/REQ-YYYYMMDD-slug/{raw*.md,analysis.md}` + `INDEX.md` |
| Plan, roadmap | `.docs/plans/PLAN-NNN-slug.md`, `.docs/plans/roadmap-*.md` + `INDEX.md` |
| Investigation | `.docs/investigations/INV-YYYYMMDD-slug/{raw.md,report.md}` + `INDEX.md` |
| Verification | `.docs/verifications/VER-YYYYMMDD-slug.md` + `INDEX.md` |
| Research, spikes | `.docs/research/subject-YYYYMMDD.md`, `.docs/research/spikes/` |
| Guides, standards | `.docs/guides/`, `.docs/standards/` |
| SDK versioning policy, release notes, migration guides | `.docs/sdk/versioning-policy.md`, `.docs/sdk/releases/vX.Y.Z.md`, `.docs/sdk/migrations/vN-to-vM.md` |
| `README.md`, `CHANGELOG.md`, `LICENSE`, `SECURITY.md` of a published package | Package/repo root (registry convention; the only root docs allowed) |
| Workflow description | `.docs/workflow.md` |
| Templates | `.agents/templates/` |
| Rules, skills | `.agents/rules/`, `.agents/skills/` |
| Engineer requests about agent behavior | `.agents/requests/` |

Pick the next free `NNN` by checking **both** the index and the file list. `YYYYMMDD` is
the working-session date.

## 3. Naming free-form documents

Applies to research, reports and requests that have no artifact ID. Does not apply to
REQ / PLAN-NNN / INV / VER / ADR.

- Format: `subject-YYYYMMDD.md`; the subject is descriptive, lowercase kebab-case, ASCII.
  Example: `review-agent-workflows-20260912.md`.
- Never name a file after an ID (`REQ-...md`). IDs belong in metadata and the INDEX.
- Raw capture is separate: `subject-raw-YYYYMMDD.md`; follow-ups `subject-raw-02-YYYYMMDD.md`.
  Never overwrite or reformat raw content.
- Same subject and date for the same request: update the existing file. A different
  request: make the subject distinguishable; never overwrite another file.
- Editing content does not change the date in the filename. A rename must update the
  INDEX and all links in scope.
- `README.md` and `INDEX.md` are fixed names.
- Do not mass-rename legacy documents unless asked.

## 4. Mistakes to avoid

- Mixing product docs with agent tooling (everything product-related goes to `.docs/`).
- Reusing a number across documents: always check the index and the file list.
- A DESIGN file plus an ADR for one topic: only the ADR exists. No `designs/` folder.
- Creating an ADR/design while the engineer is not yet satisfied: the draft stays in chat.
- Treating early numbered research notes as the source of truth: the source of truth is
  the SAD plus Accepted ADRs.
- Index disagreeing with the file (index says Proposed, file says Accepted): change both
  in the same change.

## 5. Moving files

- Use `git mv` to keep history.
- Fix relative links and in-text paths; grep to confirm no old path remains and every
  link resolves.
- Do not edit raw files (`raw*.md`); old links inside them may stay.
- Update the INDEX and this rule if the convention changes.

## 6. Pre-completion checklist

- [ ] File name has a descriptive subject and a valid date, not an ID.
- [ ] No other file overwritten; raw content untouched.
- [ ] INDEX and links point to the right files.
- [ ] Revision unchanged unless the engineer confirmed a bump.

## 7. Revision history

- rev 0: (draft) generic layout and naming rules extracted from a production project.
- rev 0 (draft): added SDK release documentation locations and the root-docs exception for published packages.
