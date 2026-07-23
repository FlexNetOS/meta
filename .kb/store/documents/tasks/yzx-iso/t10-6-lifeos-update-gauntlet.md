---
id: 019f8801-a67f-7462-ac1f-8f5dd9cf852f
slug: tasks/yzx-iso/t10-6-lifeos-update-gauntlet
title: "T10.6 — Gauntlet: LifeOS update -> zero host change"
type: task
status: draft
priority: high
tags: [yzx-iso, T10, acceptance]
---

Overview: Update LifeOS; confirm host kernel/pkgs/etc/env unchanged.

## Acceptance
- [ ] LifeOS updated
- [ ] Host unchanged (diff clean)
- [ ] Evidence recorded

Parent [[tasks/yzx-iso/t10-0-lane-index]] · Goal G1

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: LifeOS-update to zero-host-change gauntlet not in spine.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-119 on worktree-archbp-frontier
