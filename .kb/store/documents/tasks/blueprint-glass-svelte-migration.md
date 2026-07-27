---
id: 019f916f-2b2a-7103-93ab-0511d59f08f4
slug: tasks/blueprint-glass-svelte-migration
title: "LifeOS Glass Vue→Svelte migration (R01, §3.1)"
type: task
status: backlog
priority: critical
parent: tasks/blueprint-ingestion-epic
component: glass-svelte-migration
tags: [blueprint, ruvector, codex]
blocked_by: [tasks/blueprint-ruvllm-agentdb-rvf, tasks/blueprint-sona-rl, tasks/blueprint-graph-gnn-causal, tasks/blueprint-ruflo-ruvltra-atas]
---

## Overview

Component task in the blueprint-ingestion stream (parent: [[tasks/blueprint-ingestion-epic]]). Implements the
`glass-svelte-migration` component of
`/home/flexnetos/meta/src/lifeos/Architecture_Data_Pipeline_Blueprint_RUVECTOR_FULLY_EXPANDED_VERIFIED.md`.
Staged by Fable 5 for execution by Codex; claim by moving status to `active`.

## Goals

- Migrate LifeOS Glass from Vue to Svelte (R01)

- Migrate LifeOS frontend from Vue to Svelte (§3.1)
- Migrate LifeOS to Svelte Glass release target (RV§2)

## Acceptance Criteria

- [ ] Migrate LifeOS Glass from Vue to Svelte — verified by: build closure rejects Vue entrypoint and proves Svelte target

- [ ] Migrate LifeOS frontend from Vue to Svelte — verified by: Pinned checkout builds a Svelte (not Vue) shell; release gate
- [ ] Migrate LifeOS to Svelte Glass release target — verified by: release gate: Glass with embedded Yazelix PTY operational

## Context

- **Execution order:** 13 (from the blueprint's numbered install/activation order, RV§17 / integration table). Do not start implementation before lower-numbered component tasks have their gates green; work within the same order number may run concurrently.
- **Depends on component tasks:** [[tasks/blueprint-glass-engine-frontdoor]]
- **Binding constraints:** the blueprint's 21 HARD EXECUTION RULES and 19 Operational invariants govern this task in full; the broader interpretation governs every ambiguity, and an edit conflicting with them is invalid. Read the blueprint sections named per obligation below before implementing.
- **Machine-readable source:** row(s) T005, T056, T165 in `/home/flexnetos/meta/src/lifeos/reports/blueprint-task-graph.tsv`.
- **Operating constraint (owner directive):** previously completed planning-spine tasks and green test suites are untrusted claims until independently audited — lead with verification, not assumption.
- R19 (2026-07-23) re-affirmed OPEN: package.json still has "vue": "^3.5.34". This task is release-blocking everywhere. The in-repo CLAUDE.md/AGENTS.md contracts still describe the Vue app; the migration supersedes them per the blueprint's authority.

## Obligations (full detail)

### T165 · R01 · Migrate LifeOS Glass from Vue to Svelte

Current checkout (revision 3d741436) is Vue 3/Pinia/Vite + Tauri while Tauri/Svelte is the authority; Vue→Svelte is a release-blocking migration everywhere. R19 re-affirmed OPEN with package.json still "vue": "^3.5.34".

*Verification:* build closure rejects Vue entrypoint and proves Svelte target


### T005 · §3.1 · Migrate LifeOS frontend from Vue to Svelte

The target Glass is an ultra-lightweight Tauri 2/Svelte shell; the current pinned checkout is Vue/Tauri with none of the terminal integration. The Svelte migration is release-blocking work.

*Verification:* Pinned checkout builds a Svelte (not Vue) shell; release gate

### T056 · RV§2 · Migrate LifeOS to Svelte Glass release target

LifeOS current checkout is Vue/Tauri (src-tauri, lifeos-core, lifeos-daemon, lifeos-vue; Vue 3, Vite, Pinia, Tauri 2, Bun 1.3.14); the target/release gate adds Svelte Glass, a PTY controller, the yzx enter lifecycle/attach contract, and a redb-owner event client.

*Verification:* release gate: Glass with embedded Yazelix PTY operational

## Pin currency audit (observed 2026-07-23, verify pass)

- Confirmed live (2026-07-23): `package.json` name is `lifeos-vue` with vue-tsc in build/check scripts — R01 remains OPEN; this task's premise holds.

### 2026-07-25 — brain-build progress (Fable 5 orchestrator)

- Vue→Svelte migration phases 1-3 DELIVERED and MERGED to lifeos main `b58ea6a` (105 files):
  shell + 11 view panes + overlay layer, 168 mirrored Svelte tests, a11y suite ported
  (35 assertions, 0 violations — fixed a real pre-existing AIChat file-input violation),
  cutover retires the Vue tree; svelte-check 0 errors; design:lint 0; suite 530/531 green
  (archbp-096 real-process flake given retry:2 in `e2cd7e5`).
- Engineering record: Vue-reactive arrays inside Svelte $state proxies caused Array.includes
  infinite recursion + stale shallow watches; fixed centrally in src/lib/pinia-bridge.
- OPEN remainder of this task: Glass↔Engine PTY embedding (RV§2 acceptance), docs refresh
  (CLAUDE.md/AGENTS.md still describe Vue), R01 gate probe re-target (vue remains as
  Pinia engine only), Tauri windowed smoke on a real display.
