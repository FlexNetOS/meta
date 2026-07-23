---
id: 019f2344-f759-7191-b85c-35d59970dadd
slug: tasks/meta-system-architecture-documentation
title: "Document FlexNetOS meta system architecture"
type: task
status: completed
priority: high
tags: [docs, architecture, gitkb, release]
---

## Overview

Create the detailed architecture documentation set for the FlexNetOS/meta control plane and its peer repositories. The output must be source-derived, diagram-heavy, and usable as the canonical map for future release, GitKB, Codex, meta-plugin, runner, and Yazelix work.

This task extends the existing architecture context in [[context/immutable/architecture]] and must cross-check existing docs and tasks before writing new final docs. Related work includes [[context/immutable/patterns]], [[context/extensible/tech]], [[tasks/meta-release-catalog-portable-tools]], [[tasks/meta-local-ubuntu-release-runner]], [[tasks/meta-gitkb-code-intel-meta-proof-suite]], [[tasks/meta-gitkb-document-graph-view-policy]], [[tasks/meta-live-test-cli-loop-lib]], [[tasks/meta-plugin-gitkb-harness-generation]], [[tasks/meta-plugin-mcp-single-owner-policy]], and [[tasks/meta-unified-agent-plugin-control-plane]].

## Save Location Decision

Primary target: `docs/` inside the meta repo, starting with `docs/flexnetos-system-architecture.md` unless the required source walk proves an existing narrower path is the correct canonical location.

Do not create a new top-level docs system. Do not move repository structure. If a multi-file layout is justified, keep it under `docs/architecture/` and record the reason in this task before writing.

The output docs should become a durable docs knowledge base that mirrors the useful structure of `.kb` without replacing GitKB. Use Markdown files with YAML frontmatter, stable slugs/ids where useful, `[[wikilinks]]`, backlinks/related-doc sections, explicit source evidence, and an index document so humans and agents can traverse the docs without loading the whole KB.

Suggested docs layout, subject to source-walk confirmation:

- `docs/architecture/README.md` as the map/index and entrypoint
- `docs/architecture/glossary.md`
- `docs/architecture/component-inventory.md`
- `docs/architecture/automation-boundaries.md`
- `docs/architecture/data-flows.md`
- `docs/architecture/control-flows.md`
- `docs/architecture/diagrams.md`
- `docs/architecture/gitkb-generated-maps.md`
- `docs/architecture/evidence.md`

## Required Source Walk

Read these sources before authoring the final docs:

- `.kb/AGENTS.md`
- `.kb/` source docs, skills, context, and task workflow documents needed to understand what GitKB already produces
- `.codex/`
- `.context/`
- `docs/`
- `README.md`, `CLAUDE.md`, `.meta.yaml`, `.gitignore`, and release scripts/catalogs
- Peer repo READMEs and source entrypoints for every current meta peer
- Release catalog and local release runner surfaces that identify portable components
- Live command surfaces for `meta`, `git-kb`, `codex`, `envctl`, `flexnetos_runner`, `yazelix`, and related tools when available locally

## GitKB And Code Intelligence Map

The final docs must identify what GitKB already produces so we do not hand-build stale maps when the tool can generate them:

- Document graph: `git-kb graph`, wikilinks, parent edges, code references, and saved views
- Task state: `git-kb board`, `git-kb ready`, assignments, blockers, and status lifecycle
- Context bundles: `git-kb context`, `git-kb ready --context`, and smart code context
- Code maps: `git-kb code symbols`, `callers`, `callees`, `impact`, `dead`, `entrypoints`, `flows`, `query hotspots`, `refs`, `stats`, and `doctor`
- MCP surface: 49 documented tools and how they map to CLI/code-intelligence operations
- Limits or gaps proven by live commands, especially unresolved call graph health or missing peer coverage

## Deliverables

- Source-derived architecture docs under the chosen `docs/` path, organized as a durable linked documentation set rather than one disconnected prose file.
- A docs index that mirrors the `.kb` mental model: context, tasks/workflows, specs/architecture, component inventory, graph/relationships, and evidence.
- Definitions and glossary for FlexNetOS, meta, peer repo, control plane, GitKB, task workflow, Codex, MCP, meta-plugin, release catalog, runner, Yazelix, envctl, and other discovered components.
- Component inventory that includes every meta peer, release component, runtime binary/tool, agent harness, hook surface, and automation entrypoint.
- Automation boundary matrix showing what is fully automated, semi-automated, manual, approval-gated, or intentionally not automated.
- Real ASCII diagrams, not placeholders:
  - Workspace/repo topology
  - Control-plane command flow
  - GitKB document/task workflow
  - Agent harness and MCP flow
  - Release build/package/install flow
  - Peer repo ownership and dependency flow
  - Yazelix/runtime integration flow
- Data and control-flow graphs with command evidence and file path anchors.
- Evidence appendix listing the commands used, relevant outputs, and source files inspected.
- Wikilinks between docs, KB task/context references, and code references where GitKB can resolve them, for example `[[tasks/meta-system-architecture-documentation]]`, `[[context/immutable/architecture]]`, and `[[code:path::symbol]]` when proven by code intelligence.

## Acceptance Criteria

- [x] Search existing KB docs/tasks/specs for architecture, data flow, component inventory, code intelligence, release, agent harness, and plugin work before writing final docs.
- [x] Confirm and record the final save location with source evidence from existing docs layout.
- [x] Decide whether the final output is one file or `docs/architecture/`; if multi-file, include an index/README and document why that structure matches the durable knowledge-base requirement.
- [x] Add YAML frontmatter or equivalent stable metadata to each architecture doc: slug/path, title, type/category, status, source task, last verified date, and related links.
- [x] Use wikilinks and related-doc sections so the docs form a traversable graph similar to `.kb`, with links to KB tasks/context and neighboring docs.
- [x] Walk all required source areas above and record any skipped path with a reason.
- [x] Generate the component inventory from actual repo state, `.meta.yaml`, release catalog/provenance, live binaries, and peer repo metadata.
- [x] Run GitKB code intelligence proof commands and capture what they already map: `git-kb code index`, `symbols`, `callers`, `callees`, `impact`, `entrypoints`, `flows`, `query hotspots`, `refs`, `stats`, and `doctor`.
- [x] Use `git-kb graph` or equivalent KB graph output to identify existing task/context relationships that should appear in the architecture map.
- [x] Include a `gitkb-generated-maps` doc explaining exactly which maps should be generated from GitKB/code intelligence instead of hand-maintained.
- [x] Produce real ASCII diagrams for each required system view.
- [x] Clearly separate automated, semi-automated, manual, approval-gated, and not-yet-automated operations.
- [x] Include known gaps and unknowns as explicit follow-up tasks instead of inventing answers.
- [x] Commit final docs in the chosen `docs/` location and update this task with proof before closing.

## Initial Discovery Evidence

- `git-kb search "architecture" --json` found `[[context/immutable/architecture]]`, `[[context/immutable/patterns]]`, `[[tasks/meta-agent-architecture-codex-integration]]`, `[[tasks/meta-docs-architecture-workspace-version-drift]]`, and related plugin/control-plane tasks.
- `git-kb search "data flow" --json` found architecture context plus code-intelligence proof and CLI/MCP parity tasks.
- `git-kb search "component inventory" --json` found the peer component smoke test, release catalog, GitKB parity, skill inventory, and peer-local KB bootstrap tasks.
- `git-kb search "code intelligence" --json` found `[[tasks/meta-gitkb-code-intel-meta-proof-suite]]`, Rust index coverage, skill inventory parity, and GitKB CLI/MCP docs parity tasks.

## Completion Evidence

- 2026-07-02: Started through the GitKB CLI workflow with `git-kb context --task tasks/meta-system-architecture-documentation --code-refs`, `git-kb graph tasks/meta-system-architecture-documentation --json`, `git-kb checkout tasks/meta-system-architecture-documentation`, and `git-kb status --json`.
- 2026-07-02: Confirmed `docs/architecture/` as the final docs location because the repo already has `docs/` as the documentation root and `docs/gitkb/` as a subtree for durable extracted docs.
- 2026-07-02: Created the durable linked docs set: `docs/architecture/README.md`, `glossary.md`, `component-inventory.md`, `automation-boundaries.md`, `data-flows.md`, `control-flows.md`, `diagrams.md`, `gitkb-generated-maps.md`, and `evidence.md`.
- 2026-07-02: Every architecture doc has YAML frontmatter with slug/path, title, type/category, status, source task, last verified date, and related links.
- 2026-07-02: The docs use `[[wikilinks]]` for neighboring docs, KB context, and related tasks, and include explicit source evidence.
- 2026-07-02: Source walk included `.kb/AGENTS.md`, `.kb/skills`, `.codex/instructions`, `.context/CONTEXT.md`, `docs/`, `README.md`, `docs/architecture_overview.md`, `.meta.yaml`, `/home/flexnetos/FlexNetOS/src/flexnetos_runner/release/catalog.tsv`, `/home/flexnetos/FlexNetOS/src/flexnetos_runner/scripts/build-local-ubuntu-release.sh`, and live workspace inventories.
- 2026-07-02: Component inventory was generated from `.meta.yaml`, `meta project list --json`, workspace repo discovery with `find /home/flexnetos/FlexNetOS/src -maxdepth 2 -name .git`, release catalog rows, and `/home/flexnetos/FlexNetOS/usr/bin` executable inventory.
- 2026-07-02: GitKB code-intelligence evidence captured: `git-kb code index`, `stats`, `doctor`, `symbols`, `callers`, `callees`, `impact`, `entrypoints`, `flows`, `query hotspots`, and `refs`.
- 2026-07-02: `git-kb code index` reported 1427 symbols from 240 files, 14304 call sites, 246 imports, and 27 symbol-forwarding facts; all 240 files were unchanged.
- 2026-07-02: `git-kb code stats --json` reported 1429 symbols, 314 files, 2787 call edges, and 11517 unresolved calls; `git-kb code doctor --json` reported repo discovery strategy `meta` with status `ok` and unresolved-call recommendations.
- 2026-07-02: ASCII diagrams were added for workspace topology, project dependency shape, command routing, GitKB graph flow, agent/MCP flow, release build flow, and Yazelix runtime inclusion.
- 2026-07-02: Known gaps are documented in `docs/architecture/evidence.md` and `docs/architecture/gitkb-generated-maps.md` instead of being invented.
- 2026-07-02: Source docs were committed in git commit `1c3c48b` with message `docs: add linked architecture knowledge base` and body reference `Implements [[tasks/meta-system-architecture-documentation]]`.
- 2026-07-03: Performed a verification pass against the checked-in docs and live workspace inventory, including peer list, release catalog, binaries, and KB graph/status surfaces.

## Progress Log

### 2026-07-03
- Verified the task body, checked out the document, and confirmed the architecture docs are backed by current live evidence before closure.
