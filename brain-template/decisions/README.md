# Decisions (ADR index)

| ADR | Title | Status | Components | Master plan |
| --- | --- | --- | --- | --- |
| ADR-NNN | … | Proposed · Accepted · Rejected · Superseded by ADR-XXX | <name> | link |

## One folder per decision

```text
ADR-NNN-slug/
├── ADR-NNN-slug.md          # the decision (template: .agents/templates/adr.md)
├── .researchs/<subject>.md  # research kept from the chat
├── .docs/                   # contract-<name>.md, verify-NN-<slug>.md
└── .plans/
    ├── 01-<slug>-master-plan.md       # template: .agents/templates/master-plan.md
    ├── NN-<component>-<slug>.md       # template: .agents/templates/plan.md
    └── NN-spike-<slug>.md             # discovery plan
```

- NNN: next free number; check this table **and** the folder list. Never reuse a number.
- Create the folder only when the design is settled in chat.
