---
id: 019f8801-a43b-77a1-bc02-48fceb553e0c
slug: tasks/yzx-iso/t7-2-rematerialize
title: "T7.2 — Re-materialize the envelope on boot"
type: task
status: draft
priority: medium
tags: [yzx-iso, T7, impl]
---

Overview: Recreate the bwrap envelope + mounts after a reboot.

## Acceptance
- [ ] Envelope rebuilt on boot
- [ ] Mounts restored
- [ ] Matches T2 design

Parent [[tasks/yzx-iso/t7-0-lane-index]] · Goal G7,G2

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of envelope re-materialization on boot.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-094 on worktree-archbp-frontier
