---
id: 019f8801-a605-7ae1-8b43-c2fe18fca560
slug: tasks/yzx-iso/t9-9-update-acceptance
title: "T9.9 — Acceptance: host full-upgrade+reboot, LifeOS unaffected"
type: task
status: draft
priority: high
tags: [yzx-iso, T9, acceptance]
---

Overview: Prove a full host upgrade + reboot leaves LifeOS unaffected and the host normal.

## Acceptance
- [ ] Full-upgrade + reboot run
- [ ] LifeOS unaffected
- [ ] Host normal

Parent [[tasks/yzx-iso/t9-0-lane-index]] · Goal G10,G1

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine host-full-upgrade acceptance.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-117 on worktree-archbp-frontier
