# Migrating from vN to vM

<!--
One guide per MAJOR upgrade path. Location: .docs/sdk/migrations/vN-to-vM.md.
Written for humans and for agents applying the upgrade mechanically: every change has a
stable anchor, a search pattern, a diff and a verify step.
Order is fixed (conventions/sdk-library §8.2). Emphasis: core/10-visual-communication.
Delete this comment.
-->

| From → to | Action required | Effort | Breaking | Automated help |
| --- | --- | --- | --- | --- |
| vN.x → vM.0.0 | **Yes** | Low / Medium / High | N | Codemod `npx <pkg>-codemod vM` / none |

## Action required

> [!IMPORTANT]
> Upgrade to the **latest vN.x** first and clear every deprecation warning: most vM breaks
> are removals of APIs deprecated in vN.

1. Upgrade to the latest vN.x; fix deprecation warnings.
2. Bump to `vM.0.0` (runtime minimum: …).
3. Work through the table below; each row links to its fix.
4. Run your tests.

## Breaking changes at a glance

| | Change | Detection | Search pattern | Fix |
| --- | --- | --- | --- | --- |
| − | **`fetchPage()`** removed | Build error | `fetchPage\(` | [Paging](#paging) |
| ~ | **Retry default** ~~3~~ → <ins>5</ins> | Silent | `new Client\(` | [Retry](#retry-defaults) |

<!--
OPTIONAL: upgrade-path diagram — only if the path is not linear (branches by usage,
multiple packages, ordered steps across services). See core/10 §1.
-->

## Paging

- **What:** `Client.fetchPage()` is removed.
- **Who:** code that pages manually with cursors.
- **Why:** manual cursors skipped pages on concurrent writes (ADR-NNN).
- **Detect:** build error `fetchPage does not exist`.

```diff
- let cursor: string | undefined;
- do {
-   const page = await client.fetchPage({ cursor });
-   handle(page.items);
-   cursor = page.next;
- } while (cursor);
+ for await (const item of client.stream()) {
+   handle(item);
+ }
```

**Verify:** `grep -rn "fetchPage(" src/` returns nothing; paging tests pass.

## Retry defaults

- **What:** default `maxAttempts` ~~3~~ → <ins>5</ins>, with jittered backoff.
- **Who:** callers with strict latency budgets.
- **Why:** fewer failures under transient throttling.
- **Detect:** silent; worst-case latency grows.

```diff
- const client = new Client();
+ const client = new Client({ retry: { maxAttempts: 3, jitter: false } }); // keep vN behavior
```

**Verify:** latency-sensitive tests meet their budget.

## Removed deprecated APIs

| | Removed | Deprecated since | Replacement |
| --- | --- | --- | --- |
| − | `Client.fetchPage()` | 2.4.0 | `Client.stream()` |

## Troubleshooting

| Symptom | Cause | Fix |
| --- | --- | --- |

## Links

[Release notes vM.0.0](../releases/vM.0.0.md) · [Changelog](../../../CHANGELOG.md) · ADR-NNN · support channel
