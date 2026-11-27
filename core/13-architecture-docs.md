# ARCHITECTURE DOCUMENTS: A DESIGN A READER CAN FOLLOW

Applies to every ADR and architecture spec. An ADR is a **complete design that a reader can
understand and act on**, not a list of decisions. It answers the reader's questions in order,
with a picture for every idea that has structure or motion. Used by skill
`architecture-design` and `templates/adr.md`; format rules live in
`06-technical-writing-and-evidence-grounding`, `04-documentation-and-diagrams` and
`10-visual-communication`.

Grounded in [arc42](https://docs.arc42.org/home/) (building block, runtime and crosscutting
views), the [C4 model](https://c4model.com/) (zoom levels),
[ISO/IEC/IEEE 42010](https://en.wikipedia.org/wiki/IEEE_1471) (stakeholders, concerns, views),
[Design Docs at Google](https://www.industrialempathy.com/posts/design-docs-at-google/)
(goals/non-goals, alternatives, cross-cutting concerns) and
[Azure Well-Architected ADR](https://learn.microsoft.com/en-ca/azure/well-architected/architect-role/architecture-decision-record)
(all accessed 2026-10-26).

> [!IMPORTANT]
> **Problem → solution → how each part works → trade-offs.** Every section answers a reader
> question. A reader who skims headings, diagrams and callouts understands the design.

## 1. Anti-patterns (learned from reviews)

| Anti-pattern | Instead |
| --- | --- |
| **A list of decisions** ("X lives in Y", "Z is chosen") with no story | Problem → solution → how each part works → trade-offs |
| Problem stated in technical terms only | Product language first (what users, customers and the business feel), then the technical cause; evidence goes to research and Sources |
| Mixing levels: strategy, API contracts and transaction steps in one doc | Overview views in the ADR; contracts and internals in a child ADR, a contract file or the plan |
| Missing views: no building blocks, no load or render flow, no storage layout, no migration | Every view in §2 that applies to the change |
| Compressing text to fit a length limit | Split into research, a contract file or a child ADR, or ask the engineer |
| Copying agent guidance into the doc (a heading "product → tech"), or a graph mapping capabilities to components | Use the guidance to think; the doc shows real blocks, responsibilities and dependencies |
| Writing the file before the reader has seen the shape | Draft the outline and key diagrams in chat; write after the engineer agrees |
| A patch on earlier text ("changed to…", "update:"), or question → answer headings | One complete version of the design (`06` §8); reader questions guide the author in chat, never become headings |
| One topic spread over several files, or the same content in two files | The ADR holds the overview; each detail file holds one part; link, never copy |

## 2. Views

| View | Reader question it answers | Form |
| --- | --- | --- |
| **Problem** | Why change? What hurts users and the business? | Table: challenge · user/customer impact · technical cause |
| **Goals / non-goals** | What must be true after? What is deliberately out? | Bullets + quality goals table |
| **Solution strategy** | What is the idea in one minute? | 5–8 key ideas, each mapped to the problem it solves |
| **Building block view** | What are the parts, what is each responsible for, what is inside? | Level 1: black boxes (diagram + table: responsibility, never, depends on). Level 2: white boxes (diagram + table: components, technology / runs where, data owned, detail doc) |
| **Context / container** | Who talks to whom; where are the trust boundaries? | C4 context or container diagram, grouped by owning team |
| **Team integration** | What crosses each team boundary, and who guarantees what? | Per boundary: sequence diagram + contract table (call, owner, inputs, outputs, failure) + key guarantees + glossary rows |
| **Runtime** | How do the main scenarios work, including failure? | One sequence diagram per key flow, with `alt` failure paths |
| **Data and storage** | What is stored where; how do the pieces relate? | Schema (kept / added / removed), storage layout, correspondence between stores |
| **Crosscutting** | Security, consistency, observability, privacy | One short subsection each |
| **Migration / transition** | How do we get from today to the target safely? | Phase diagram + approach table + rollback |
| **Trade-offs and risks** | What do we give up and how do we contain it? | Table: trade-off · impact · mitigation |
| **Options and decision** | Why this design over the alternatives? | Options table + decision |

- A view that does not apply is left out; the chat says why. A single-component change with
  no team boundary has no team integration view.
- An **overview ADR** (one that frames several child ADRs) shows every view at overview
  level and links to the child ADR for detail; a child ADR goes deeper on its own blocks and flows.

## 3. Method

1. **Map readers first.** List stakeholder → concern → question → section, in chat only (it
   is a check, not doc structure). Every question has a section and, where structure or
   motion is involved, a diagram.
2. **Derive the building blocks from product to tech** (how to think, not a heading):
   - **Level 1, black boxes:** split the system by product responsibility, named so a product
     manager recognizes each block ("Offline Store", not "SQLite adapter"). Each block has one
     responsibility, a "never" rule and dependencies on other blocks.
   - **Level 2, white boxes:** open each block into its technical components: what runs where,
     which technology, which data or store it owns, which detail doc holds more.
   - Do **not** draw a "capabilities → components" mapping graph; draw the blocks and their
     dependencies. Draw both levels before writing prose.
3. **Diagram first, then highlights.** Each part has one diagram, then a callout of the 3–5
   points a reader must not miss, then short prose only if needed.
4. **Draft in chat, then write** (`07-workflow-governance` §1).
5. **Reader test before saving.** A new engineer answers every question from step 1 within
   30 seconds per question, from headings, diagrams and callouts alone. If not, fix the doc.
6. **Mark new content.** Anything that refines a decision the engineer has not seen is
   labeled `[Proposed]` and listed in chat for review.

## 4. Revision history

- rev 0 (draft): created from a Product Brain's architecture-document rule (reader-driven
  ADR, anti-patterns, views, method, reader test).
