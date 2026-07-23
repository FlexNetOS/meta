---
id: 019f8801-a66f-76b3-bdac-250bea8c8fdb
slug: tasks/yzx-iso/t10-5-update-reboot-gauntlet
title: "T10.5 — Gauntlet: host update+reboot -> zero LifeOS loss"
type: task
status: draft
priority: high
tags: [yzx-iso, T10, acceptance]
---

Overview: End-to-end acceptance combining persistence + re-attach under a host update+reboot.

## Acceptance
- [ ] Update+reboot executed
- [ ] Zero LifeOS loss
- [ ] Uses T1.8 gauntlet

Parent [[tasks/yzx-iso/t10-0-lane-index]] · Goal G1,G3,G7

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: Host-update+reboot zero-loss gauntlet is isolation-specific; not in spine.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-118 on worktree-archbp-frontier
