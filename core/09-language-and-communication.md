# LANGUAGE & COMMUNICATION

The engineer may speak any language (often Vietnamese) in the chat. Documents are always
English. The agent is responsible for turning loose spoken-style intent into precise
English before it is written down.

## 1. Rules

1. **Chat language follows the engineer.** Reply in the language the engineer is
   currently using. Code identifiers, commands and standard technical terms stay in English.
2. **Everything persisted is English.** ADR, PLAN, INV, VER, REQ analysis, research notes,
   rules, skills, templates, README/guides, code comments, commit messages, PR text.
   Diagram labels are English.
3. **Clarify before you document.** Before writing any document, restate the intent in
   plain English in the chat and resolve ambiguity with the engineer. Document only what
   the engineer has confirmed.
4. **No slang or half-translations in documents.** Colloquial, regional, or mixed-language
   phrases ("ship cái này", "deploy luôn", "làm nhanh gọn") must be asked about or
   replaced with an unambiguous technical statement. Translate meaning, not word for
   word. If a phrase can be read two ways, ask.
5. **Keep standard technical terms** in English (idempotency, backpressure, circuit
   breaker…). Do not invent translations for them.
6. **Explain new or hard terms briefly on first use** in chat; long documents get a
   glossary.
7. **Structure high level → detail:** what it is, what it is for, why it is needed, then
   technical detail. Prefer a Mermaid diagram (title + one-sentence purpose) over prose.
8. **When offering options,** state the practical consequence of each, a recommendation,
   and why. Numbers/thresholds you propose are references until the engineer confirms.

## 2. Raw capture (optional)

Saving the engineer's original wording is optional. When it is useful (a large
requirement whose intent must stay auditable):

- The document body uses the **English text the engineer confirmed**.
- If the original wording is kept, store it unmodified in a separate `raw*.md` file
  (see `08-repo-layout-and-naming`) and link it; do not translate or "clean up" raw.
- Never present an unconfirmed paraphrase as the engineer's words.

## 3. Clarification pattern

Use this short loop in chat before writing:

1. "My understanding in English: …" (2–5 bullets).
2. List the phrases you could not interpret unambiguously, each with 2 candidate readings.
3. Wait for confirmation, then write the document.

## 4. Revision history

- rev 0: (draft) generic language/communication rule added (chat in engineer's language, documents in English).
