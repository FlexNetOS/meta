---
id: 019f8801-a54a-71e1-9833-de3259adfd60
slug: tasks/yzx-iso/t8-8-control-tests
title: "T8.8 — Control-plane acquire/release tests"
type: task
status: draft
priority: medium
tags: [yzx-iso, T8, test]
---

Overview: Cycle acquire/release across all resources; assert OS unaffected.

## Acceptance
- [ ] Cycles pass for all resources
- [ ] OS unaffected each cycle
- [ ] Audit verified

Parent [[tasks/yzx-iso/t8-0-lane-index]] · Goal G8

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine control-plane acquire/release tests.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-107 on worktree-archbp-frontier
