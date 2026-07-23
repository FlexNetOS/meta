---
id: 019f87ff-90fe-7c81-a9a6-e834cd4307ee
slug: tasks/yzx-iso/t3-7-guard-test
title: "T3.7 — Add tier-map guard test"
type: task
status: draft
priority: medium
tags: [yzx-iso, T3, test]
---

Overview: CI check that fails if any durable var points at host /run.

## Acceptance
- [ ] Guard test written
- [ ] Runs in CI
- [ ] Fails on regression

Parent [[tasks/yzx-iso/t3-0-lane-index]] · Goal G4

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine guard preventing durable vars on /run.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-075 on worktree-archbp-frontier
