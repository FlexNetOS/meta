---
id: 019f8801-a5d1-7ae1-a509-1d0d9f17b386
slug: tasks/yzx-iso/t9-6-host-normalcy
title: "T9.6 — Validate host still updates/reboots normally"
type: task
status: draft
priority: medium
tags: [yzx-iso, T9, test]
---

Overview: Confirm the drdave path: the host updates and reboots fine independent of LifeOS.

## Acceptance
- [ ] Host updates cleanly
- [ ] Host reboots cleanly
- [ ] No LifeOS interference

Parent [[tasks/yzx-iso/t9-0-lane-index]] · Goal G1

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine validation that the host still updates/reboots normally.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-114 on worktree-archbp-frontier
