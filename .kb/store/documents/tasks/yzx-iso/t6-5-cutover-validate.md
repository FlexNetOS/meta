---
id: 019f8800-7157-72d2-8853-0fee7c8198b9
slug: tasks/yzx-iso/t6-5-cutover-validate
title: "T6.5 — Cut over and validate network mgmt continuity"
type: task
status: draft
priority: medium
tags: [yzx-iso, T6, test]
---

Overview: Switch to nix Omada; confirm APs/switches stay adopted and managed.

## Acceptance
- [ ] Devices adopted post-cutover
- [ ] No management gap
- [ ] Rollback path tested

Parent [[tasks/yzx-iso/t6-0-lane-index]] · Goal G9,G8

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of Omada network-mgmt cutover.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-088 on worktree-archbp-frontier
