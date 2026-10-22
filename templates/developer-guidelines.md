# Developer Guidelines — <project name>

Skeleton for a project's runbook. Fill every section with the project's **real, verified**
commands; delete sections that do not apply. Agents read the commands here and in
`AGENTS.md` ("Quick commands") when a rule says "the project's check commands".

## 1. Prerequisites

| Tool | Version | Check command |
| --- | --- | --- |
| `<runtime>` | `>= x.y` | `<tool> --version` |

Platform-specific setup (per OS / architecture).

## 2. Project structure

Directory tree with one line of purpose per module, then the **layering rules** (who may
depend on whom) and the command that enforces them.

## 3. Local development

First-time setup, environment variables, dev profiles, run commands, and how to verify
that local development works (what you should see).

## 4. Build

Debug and release builds, per-platform builds, output locations, cross-platform notes,
code generation steps.

## 5. Test

Unit, integration, end-to-end, architecture/schema checks, and the **single full
verification command**. Say what each command proves. Do not record historical test
counts as evidence.

## 6. Code quality

Format, lint, typecheck commands (check mode and write mode separately) and the coding
conventions (link `.agents/rules/conventions/`).

## 7. Troubleshooting

| Symptom | Likely cause | Fix / how to confirm |
| --- | --- | --- |
| … | … | … |

Include where logs live and how to raise verbosity; how to inspect local data safely.

## 8. Performance

Budgets as a table so every claim is measurable:

| Metric | Budget | How to measure |
| --- | --- | --- |
| … | … | `<command or metric name>` |

Profiling tools per OS and project-specific optimization guidelines.

## 9. Architecture checks

Commands that verify boundaries and schemas, plus short numbered recipes with a
verification command per step:

### Adding a new `<module type>`
1. Create … 2. Register in … 3. Implement … 4. Add tests … 5. Run `<check>`.

## 10. CI/CD

Workflows, what each gate runs, and how to simulate them locally.

## 11. Key decisions

Links to the ADRs a newcomer must read first, in reading order.

## Revision history

- rev 0: created (YYYY-MM-DD)
