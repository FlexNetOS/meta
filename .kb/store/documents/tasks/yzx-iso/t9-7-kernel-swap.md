---
id: 019f8801-a5e3-7be3-b322-3c7147c067ea
slug: tasks/yzx-iso/t9-7-kernel-swap
title: "T9.7 — Handle kernel swap via persistence + re-attach"
type: task
status: draft
priority: medium
tags: [yzx-iso, T9, test]
---

Overview: Ensure a host kernel upgrade + reboot is fully covered by T4 persistence and T7 re-attach.

## Acceptance
- [ ] Kernel swap scenario tested
- [ ] State survives
- [ ] Auto re-attach succeeds

Parent [[tasks/yzx-iso/t9-0-lane-index]] · Goal G10,G7

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine kernel-swap-via-persistence+reattach scenario.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-115 on worktree-archbp-frontier
