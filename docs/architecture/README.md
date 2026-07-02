---
slug: docs/architecture/index
title: "FlexNetOS Meta Architecture Index"
type: architecture
status: active
source_task: tasks/meta-system-architecture-documentation
last_verified: 2026-07-02
related:
  - docs/architecture/glossary
  - docs/architecture/component-inventory
  - docs/architecture/automation-boundaries
  - docs/architecture/data-flows
  - docs/architecture/control-flows
  - docs/architecture/diagrams
  - docs/architecture/gitkb-generated-maps
  - docs/architecture/evidence
  - context/immutable/architecture
  - context/immutable/patterns
---

# FlexNetOS Meta Architecture Index

This directory is the durable architecture documentation set for the FlexNetOS
meta control plane. It mirrors the useful shape of `.kb` without replacing
GitKB: each document has frontmatter, stable slugs, `[[wikilinks]]`, related
documents, source evidence, and a focused responsibility.

## Map

| Document | Purpose |
| --- | --- |
| [[docs/architecture/glossary]] | Shared definitions for terms used by humans, agents, docs, and release scripts. |
| [[docs/architecture/component-inventory]] | Inventory of control-plane repos, release components, binaries, agent harnesses, hooks, and runtime surfaces. |
| [[docs/architecture/automation-boundaries]] | What is automated, semi-automated, approval-gated, manual, or intentionally not automated. |
| [[docs/architecture/data-flows]] | Data movement across Git, GitKB, Meta, Codex, release bundles, and runtime surfaces. |
| [[docs/architecture/control-flows]] | Command and execution flows from user/agent intent to repo actions and release output. |
| [[docs/architecture/diagrams]] | Real ASCII system diagrams with source evidence. |
| [[docs/architecture/gitkb-generated-maps]] | What GitKB/code intelligence already generates and should not be hand-maintained. |
| [[docs/architecture/evidence]] | Commands, outputs, and source files used to verify this architecture set. |

## Knowledge Graph

```
[[tasks/meta-system-architecture-documentation]]
    |
    +--> [[docs/architecture/index]]
    |       |
    |       +--> [[docs/architecture/component-inventory]]
    |       +--> [[docs/architecture/automation-boundaries]]
    |       +--> [[docs/architecture/data-flows]]
    |       +--> [[docs/architecture/control-flows]]
    |       +--> [[docs/architecture/diagrams]]
    |       +--> [[docs/architecture/gitkb-generated-maps]]
    |       +--> [[docs/architecture/evidence]]
    |
    +--> [[context/immutable/architecture]]
    +--> [[context/immutable/patterns]]
    +--> [[context/extensible/tech]]
```

## Scope

This docs KB covers:

- The `src/meta` meta-repo as a control-plane repository, not a monorepo.
- The 14 meta-managed peers declared by `.meta.yaml`.
- The wider FlexNetOS release catalog in `src/flexnetos_runner/release/catalog.tsv`.
- GitKB task/context/document/code-intelligence flows used by Codex sessions.
- Codex, MCP, plugin, release, runner, Yazelix, envctl, Beads, RTK, and Bun
  surfaces that are part of the portable local release state.

## Source Of Truth

Use GitKB for live task state, document graph, context bundles, and code maps.
Use these docs for durable human/agent orientation and architecture review. If a
map can be generated from GitKB or code intelligence, this docs set points to
the generating command instead of hand-maintaining a duplicate.

See [[docs/architecture/gitkb-generated-maps]] for those boundaries.
