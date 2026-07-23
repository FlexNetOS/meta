---
id: 019f87ff-90cb-77b1-aa90-77601166b37e
slug: tasks/yzx-iso/t3-4-keep-volatile
title: "T3.4 — Keep volatile tier on tmpfs (verify)"
type: task
status: draft
priority: medium
tags: [yzx-iso, T3, impl]
---

Overview: Confirm caches, cargo-target, tmp, rustup stay ephemeral on tmpfs.

## Acceptance
- [ ] Volatile paths remain tmpfs
- [ ] No durable data in volatile
- [ ] Documented

Parent [[tasks/yzx-iso/t3-0-lane-index]] · Goal G4

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of the volatile-tmpfs classification.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-073 on worktree-archbp-frontier
