---
id: 019f8801-a45c-7a21-ac5a-e90b521dc6cc
slug: tasks/yzx-iso/t7-4-service-restart
title: "T7.4 — Orchestrate service restart order"
type: task
status: draft
priority: medium
tags: [yzx-iso, T7, impl]
---

Overview: Start postgres, then redb, then the Glass/Engine front door in dependency order.

## Acceptance
- [ ] Ordered startup implemented
- [ ] Health-gated transitions
- [ ] Failures surfaced

Parent [[tasks/yzx-iso/t7-0-lane-index]] · Goal G7

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of ordered service restart orchestration on boot.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-096 on worktree-archbp-frontier
