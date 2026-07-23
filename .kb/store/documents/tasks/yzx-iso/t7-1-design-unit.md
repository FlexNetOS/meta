---
id: 019f8801-a42a-7553-ac79-f425affe66a3
slug: tasks/yzx-iso/t7-1-design-unit
title: "T7.1 — Design the re-attach unit"
type: task
status: draft
priority: high
tags: [yzx-iso, T7, design]
---

Overview: Login/boot-triggered, idempotent unit that re-materializes the envelope and re-attaches state.

## Acceptance
- [ ] Trigger + idempotency defined
- [ ] Ordering vs host boot set
- [ ] No host-service coupling

Parent [[tasks/yzx-iso/t7-0-lane-index]] · Goal G7

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine boot re-attach unit design.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-093 on worktree-archbp-frontier
