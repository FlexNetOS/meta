---
id: 019f87ff-909b-76b1-939e-dec1b735bc6b
slug: tasks/yzx-iso/t3-1-inventory
title: "T3.1 — Inventory all vars pointing at host /run profile-runtime"
type: task
status: draft
priority: high
tags: [yzx-iso, T3, impl]
---

Overview: Enumerate CLAUDE_CONFIG_DIR, CODEX_HOME, YAZELIX_STATE_DIR and peers currently on /run/user tmpfs.

## Acceptance
- [ ] Complete var list captured
- [ ] Durable vs volatile tagged
- [ ] Cross-checked vs T1.2 tier map

Parent [[tasks/yzx-iso/t3-0-lane-index]] · Goal G4

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: Inventory of vars on host /run is new; not in spine.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-072 on worktree-archbp-frontier
