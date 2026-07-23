---
id: 019f87ff-9027-7541-988f-17037eb30c7f
slug: tasks/yzx-iso/t2-4-exit-release
title: "T2.4 — Implement clean exit / release lifecycle"
type: task
status: draft
priority: medium
tags: [yzx-iso, T2, impl]
---

Overview: Teardown mounts + acquired resources with zero leaks on exit.

## Acceptance
- [ ] All mounts unwound on exit
- [ ] No dangling namespaces
- [ ] Host state restored

Parent [[tasks/yzx-iso/t2-0-lane-index]] · Goal G2,G8

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of envelope exit/teardown.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-067 on worktree-archbp-frontier
