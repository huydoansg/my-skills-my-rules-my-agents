# EXECUTION ECONOMY

Spend effort, tokens and compute where they can change the result. Required checks stay; the
waste around them goes. Applies to research, planning, implementation, review and
verification, by the main agent and by any subagent.

## 1. Fix the output before running tools

- Before a batch of tool calls, name the output that ends it: "two equal recordings of case
  X", "RED logged for every mapped case", "root cause with a reproducing test".
- When the output is met, record it, report it and stop. The next batch or task is a
  separate step, started only when it is permitted.
- Widen the search, the test set or the evidence only when a result could change a decision
  or the plan asks for more.

## 2. Research that serves a decision

- Each research step answers a question whose answer can change what is done next.
- When the code path, the contract and the way to check a small change are known, start the
  change.
- Read by impact: the touched code, its callers and the checks the repo requires. Reuse a
  result that still holds instead of re-reading.

## 3. Failed setup

- Read the contract, validator or existing fixture before retrying a failed setup.
- A failure that repeats is fixed at its cause (seed, config, script), not by creating more
  databases, brokers, containers or stacks.
- After the cause is fixed, rerun only the failed case.

## 4. One runner for repeated work

- Steps that repeat with the same setup, action and assertion go through one small runner
  that takes the case as input. Shared infrastructure starts once per batch, not per case.
- Full logs go to a file in the run record. The tool call returns the exit code, the main
  result (one line per case) and the relevant error lines.
- Read only the failing part of a log.

## 5. Report on signal

- Report when a result changes the work: a checkpoint passed, a difference that changes the
  implementation, or a concrete blocker.
- Polling, waiting and runs of the same group get one summary at the end.

## 6. Notice drift

- When effort grows and no behavior has been proven yet, stop and revisit the approach;
  remove the supporting machinery that is not needed. A small helper is right when it lowers
  the total cost of checking.
- Progress is measured in requirements met with evidence, not in files, tools or tests
  written.
- Subagents get one bounded question, a read-only scope unless writing is the task, and a
  size limit for their report. Spawn them only when the work is independent and large enough
  to pay for the fresh context.

## 7. In plans

A plan that an agent executes states, per task or batch: its checkpoint output and stop, the
runner that repeated cases use, where full logs go and what the runner prints. The executor
rules of the plan carry §1–§5 once (`skills/implementation-planning`).

## Revision history

- rev 0 (draft): extracted from a Product Brain in use, after an executor over-ran setup,
  polling and log reads on a port plan.
