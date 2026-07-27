---
id: 019f916f-2b37-7d02-8a00-a904c57a8a24
slug: tasks/blueprint-ingestion-epic
title: "Blueprint ingestion epic — RuVector architecture task stream"
type: task
status: backlog
priority: critical
component: blueprint-ingestion
tags: [blueprint, ruvector, codex, epic]
---

## Overview

Parent epic for the component-level task stream extracted from
`/home/flexnetos/meta/src/lifeos/Architecture_Data_Pipeline_Blueprint_RUVECTOR_FULLY_EXPANDED_VERIFIED.md`
(the normative architecture and data-pipeline authority for the lifeos repository, itself anchored
to `Architecture_Data_Pipeline_Graph_ANCHORED_VERIFIED(3).md`, SHA-256 `abd36f1c…`). Every child
task implements one major component of the blueprint. This epic does not carry implementation
work itself; it exists so the whole stream is discoverable, ordered, and traceable.

Tasks were staged by Fable 5 for execution by Codex. The machine-readable task graph lives at
`/home/flexnetos/meta/src/lifeos/reports/blueprint-task-graph.tsv`; the conflict/gap cross-check
against the pre-existing 207 meta-root KB tasks lives at
`/home/flexnetos/meta/src/lifeos/reports/blueprint-task-crosscheck.md`.

## Goals

- Every actionable obligation in the blueprint is covered by exactly one child task (or an
  explicit "descriptive — no action" entry in the task graph).
- Child tasks are self-contained: a cold-start agent can execute any of them from the document
  body alone.
- Dependency order between components is explicit via `depends_on` frontmatter/wikilinks and the
  task-graph TSV.

## Acceptance Criteria

- [x] All child tasks listed below exist in this KB with status `backlog`. Evidence: `git-kb board --group-by status --columns backlog,draft,active,completed` → backlog 20 / draft 0 (2026-07-23).
- [x] `git-kb graph tasks/blueprint-ingestion-epic --json` shows every child linked. Evidence: 21 nodes / 58 edges.
- [x] The task graph TSV row count matches the blueprint section coverage audit. Evidence: 203 rows; `audit-section-coverage.py` exit 0 (52 real headings mapped).
- [x] No child task duplicates scope already delivered by a completed meta-root task without a re-verification criterion (crosscheck Table 1); intra-stream Svelte-migration duplication (T005/T056 vs T165) found in the verify pass and consolidated into [[tasks/blueprint-glass-svelte-migration]].

## Context

- The blueprint's **21 HARD EXECUTION RULES** and **19 Operational invariants** bind every child
  task; each child copies the rules relevant to its component into its own Context section.
- Operating constraint (owner directive): previously "completed" planning-spine tasks and green
  test suites are **untrusted claims until independently audited**. Child tasks covering scope
  that a completed task already claims (e.g. `tasks/architecture-rtk-nu-adapter`,
  `tasks/yzx-iso/t4-*`) therefore lead with an independent verification criterion, not an
  assumption of done.
- Status flow for children: `draft` → `backlog` only. Codex claims tasks by moving them to
  `active`; nothing here is pre-claimed.
- Sibling stream: the lifeos-local KB carries an earlier, different-axis decomposition
  (`tasks/blueprint-ingest-*` 009–014, blueprint-content-ingestion pipeline) that remains
  active in that KB; see Table 2 of the crosscheck report. `tasks/blueprint-ruvector-ingestion-002`
  there is fulfilled by this stream and is recommended for closure with evidence.
- Provenance: the blueprint document itself was delivered by completed meta-root task
  `tasks/architecture-data-pipeline-blueprint`; this epic implements it.

## Children

In blueprint execution order (RV§17 / integration table):

1. [[tasks/blueprint-install-activation-order]] — ordering spine (order 1, critical)
2. [[tasks/blueprint-byte-capture-reconciliation]] — cross-cutting capture contract (order 1, critical)
3. [[tasks/blueprint-nix-release-gate]] — hermetic build + release gates (order 2, critical)
4. [[tasks/blueprint-rtk-rtk-nu-envelope]] — rtk_nu tee + envelope (order 2, critical)
5. [[tasks/blueprint-postgres-ruvector-store]] — canonical store (order 3, critical)
6. [[tasks/blueprint-witness-chain]] — SHAKE256 witnesses (order 5, high)
7. [[tasks/blueprint-data-schema]] — schemas, migrations, RLS (order 5, critical)
8. [[tasks/blueprint-cow-branching]] — COW branches + promotion (order 5, high)
9. [[tasks/blueprint-redb-state-plane]] — redb owner + mmap projection (order 6, critical)
10. [[tasks/blueprint-envctl-committer-security]] — sole committer + secrets (order 6, critical)
11. [[tasks/blueprint-codedb-ingress]] — byte-complete ingress (order 7, critical)
12. [[tasks/blueprint-retrieval-indexing]] — HNSW/IVF + embeddings (order 8, high)
13. [[tasks/blueprint-coordination-surfaces]] — Git/GitKB/meta/ICM/weave projections (order 8, high)
14. [[tasks/blueprint-ruvllm-agentdb-rvf]] — cognition containers (order 9, high)
15. [[tasks/blueprint-sona-rl]] — learning + promotion gates (order 9, high)
16. [[tasks/blueprint-graph-gnn-causal]] — graph/GNN/causal/MinCut (order 9, high)
17. [[tasks/blueprint-ruflo-ruvltra-atas]] — swarms + forecasting (order 9, high)
18. [[tasks/blueprint-glass-svelte-migration]] — Vue→Svelte (order 13, critical)
19. [[tasks/blueprint-glass-engine-frontdoor]] — PTY/xterm/sidebar front door (order 13, critical)

## Progress Log

### 2026-07-23
- Stream staged: 20 tasks committed and moved to backlog (KB commits 019f916f-2aff / 019f9170-2e19).
- Verify pass driven through the git-kb surface (board/show/graph/search + probes); pin-currency
  audit appended to 7 child tasks; T005/T056 migration scope consolidated into
  [[tasks/blueprint-glass-svelte-migration]]; native `component` and execution-order `blocked_by`
  metadata added to all children.
- Known tag collision: pre-existing completed task `tasks/rtk-codex-hooks-server-dashboard-icm`
  also carries tag `codex` — filter stream queries by tag AND status (backlog), or by slug prefix.
