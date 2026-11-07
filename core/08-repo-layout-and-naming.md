# REPO LAYOUT & NAMING

Read this **before creating or moving any document**. It defines *which* documents exist
and how they are named. *Where* they live is declared per project in the **Docs layout**
table of its `AGENTS.md`, so the same rules and skills work in every project.

## 1. Two kinds of content

| Content | Location |
| --- | --- |
| Agent tooling: rules, skills, templates, workflow | `.agents/` in every repo (installed by `install.sh`) |
| Product knowledge: ADRs, plans, research, architecture, roadmaps, component cards, references | Where the project's **Docs layout** says: usually a separate **Product Brain** repo (see `guides/product-brain.md` in the kit), or a folder inside the repo |
| Published-package docs (`README.md`, `CHANGELOG.md`, `LICENSE`, `SECURITY.md`) and SDK release docs | Package root and the paths in `conventions/sdk-library` |

Requirements (PRD) and bug investigations are not stored as artifacts: requirements live
outside the technical docs; bugs are settled in chat and recorded in the fix commit/PR
(`07-workflow-governance` §2).

## 2. Docs layout (required in each project's `AGENTS.md`)

Skills and rules refer to the artifact names in the left column. The project fills the
right column. The values shown are the Product Brain defaults.

```markdown
## Docs layout

| Artifact | Path |
| --- | --- |
| Product Brain root | `../<product>-brain/` (or `.` when this repo is the brain) |
| ADR index | `decisions/README.md` |
| ADR folder | `decisions/ADR-NNN-slug/` (ADR file: `ADR-NNN-slug.md`) |
| Research folder | `<ADR folder>/.researchs/` |
| ADR docs folder | `<ADR folder>/.docs/` (contracts, verification reports) |
| Plans folder | `<ADR folder>/.plans/` |
| Architecture overview | `architecture.md` |
| Technical roadmap | `technical-roadmap.md` |
| Product roadmap | `product-roadmap.md` |
| Component cards | `components/<name>/README.md` |
| References | `references/` |
```

- Paths are relative to the Product Brain root.
- A project with an older layout (for example `.docs/adr/`, `.docs/plans/`) declares those
  paths instead; nothing has to move.
- **No Docs layout table → ask the engineer before creating any document** (`11-clarity-first`).

## 3. Naming (kit defaults; a Docs layout may override a row)

| Artifact | Pattern | Example |
| --- | --- | --- |
| ADR | `ADR-NNN-slug` (NNN unique in the ADR index; check the index **and** the folder list) | `ADR-012-auth` |
| Master plan | `01-<slug>-master-plan.md` (always 01, one per ADR) | `01-auth-master-plan.md` |
| Delivery plan | `NN-<component>-<slug>.md` (NN counted per ADR, from 02) | `02-backend-token-refresh.md` |
| Discovery plan | `NN-spike-<slug>.md` or `NN-research-<slug>.md` | `04-spike-token-store.md` |
| Contract | `contract-<name>.md` in the ADR docs folder | `contract-auth-api.md` |
| Verification report | `verify-NN-<slug>.md` in the ADR docs folder (NN = plan number) | `verify-02-token-refresh.md` |
| Research, reference | `<subject>.md` | `token-storage-options.md` |

- `<component>` is a component card name; a single-component product omits it.
- Plan numbers are never reused, even for abandoned plans.
- Slugs: lowercase kebab-case, ASCII, descriptive. No dates in file names.
- `README.md` and `INDEX.md` are fixed names.

## 4. When files are created

- Research, brainstorm and design stay **in the chat** until the engineer settles them.
- On settlement: create the ADR folder and the ADR, move worth-keeping research into the
  research folder, add the ADR to the ADR index and the technical roadmap.
- Plans are created only after the ADR is Accepted and the work is clear (`11-clarity-first`).

## 5. Mistakes to avoid

- Creating an ADR, plan or research file while the point is still ambiguous.
- Hard-coding a path in a rule or skill instead of using the Docs layout artifact name.
- A second copy of a contract: plans and component cards link to the ADR or the contract file.
- An index or roadmap disagreeing with the file's status: change both in one change.
- Reusing a number: check the index **and** the folder list.

## 6. Moving files

- Use `git mv` to keep history; update the Docs layout table if a path changes.
- Fix relative links and in-text paths; grep to confirm no old path remains.

## 7. Pre-completion checklist

- [ ] File is where the Docs layout says; name follows §3.
- [ ] No other file overwritten.
- [ ] Index, roadmap and links point to the right files.
- [ ] Revision unchanged unless the engineer confirmed a bump.

## 8. Revision history

- rev 0: (draft) generic layout and naming rules extracted from a production project.
- rev 0 (draft): added SDK release documentation locations and the root-docs exception for published packages.
- rev 0 (draft): layout-agnostic: artifacts are named here, paths come from the project's
  Docs layout table (Product Brain defaults); plan naming `01-<slug>-master-plan.md`,
  `NN-<component>-<slug>.md`; no requirement or investigation artifacts.
