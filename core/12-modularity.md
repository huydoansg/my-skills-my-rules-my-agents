# MODULARITY: ONE RESPONSIBILITY PER FILE

Applies to every language and framework. Agents maintain a codebase over many sessions;
without this rule each session appends to the nearest file and God files appear.
The Single Responsibility Principle (`01-solid-dry-clean-code` §S) is enforced here at file level.

> [!IMPORTANT]
> **A file holds one responsibility. Never put several modules, classes, components,
> services or use cases in one file. A new module gets a new file.**
> Line count is only an indicator; the cause is mixed responsibilities.

## 1. Rules

1. **New concept → new file.** Add a class, component, service, handler, use case or
   adapter in its own file, named after it. Never append it to an existing file because that
   file is "nearby".
2. **Small companions may share a file** only when they exist solely to support the one primary
   type: its DTOs, error type, enum, private helpers.
3. **Entrypoints are thin.** `main`/bootstrap files only read config, wire dependencies and
   start. Logic goes to modules (limit 100 warn / 200 block).
4. **Check before you edit.** If your change would push a file past 80% of its limit, or adds a
   second responsibility, split first (skill `split-module`), then add the new code.
5. **Ratchet.** A file already over the limit may not grow. When you touch it, extract what you
   change; do not add "just one more function".
6. **Plan the files.** A plan lists, per task, the file to create or edit and its single
   responsibility (`implementation-planning`).
7. **No silent exceptions.** Exemptions live in `.agents/limits` with a reason and the
   engineer's approval. Never raise a limit or edit the baseline to make a check pass.

## 2. Limits (defaults; the project may tune them in `.agents/limits`)

| File kind | Lines: warn / block | Top-level types: warn / block | Top-level functions: warn / block |
| --- | --- | --- | --- |
| Source | 300 / 500 | 3 / 5 | 15 / 25 |
| Test | 500 / 800 | 3 / 5 | 15 / 25 |
| Entrypoint (`main.*`) | 100 / 200 | 3 / 5 | 15 / 25 |
| Generated, lockfiles, migrations, fixtures, docs, data | exempt | exempt | exempt |

Types and functions are counted heuristically (declarations at column 0), so several
modules in one short file are caught too.

## 3. Enforcement (agent-independent)

The check is a plain script, so every agent and every human passes through it:

```sh
.agents/tools/check-modularity.sh            # files changed vs HEAD
.agents/tools/check-modularity.sh --staged   # pre-commit (installed by install.sh)
.agents/tools/check-modularity.sh --base origin/main   # CI
```

- Silent and exit 0 when clean; one line per offender, at most 10; exit 1 on a block.
- Run it in the verification loop (`03-verification-loop`) and before reporting done.
- **Adoption in an existing project:** run `--init` once to baseline current offenders in
  `.agents/size-baseline`, commit it. From then on the baseline only shrinks (`--shrink`).
- Language linters (ESLint `max-lines`, pylint `too-many-lines`, clippy `too_many_lines`)
  may complement it; the script is the common floor.

## 4. When a check fails

Do not negotiate with the number. Load skill `split-module`, split by responsibility, rerun.
If a split is genuinely wrong (cohesive table, state machine), stop and ask the engineer for
an exemption with a reason.
