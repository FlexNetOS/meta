---
id: 019f87ff-8f4f-7783-a108-63dc57e1ea97
slug: tasks/yzx-iso/t1-1-two-brother-model
title: "T1.1 — Formalize the two-brother control model"
type: task
status: draft
priority: high
tags: [yzx-iso, T1, architecture]
---

Overview: Document big-brother/little-brother semantics: LifeOS acquires and releases host resources on demand; Ubuntu always functions normally.

## Acceptance
- [ ] Acquire + clean-release semantics written
- [ ] Little-brother-always-functions invariant stated
- [ ] Consumed by [[tasks/yzx-iso/t8-0-lane-index]]

Parent [[tasks/yzx-iso/t1-0-lane-index]] · Goal G1

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine artifact defines a big-brother/little-brother host commandeer+release model. STORE-001 (product_execution=false) covers data-state tiers only.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-058 on worktree-archbp-frontier
