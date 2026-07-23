---
id: 019f8801-a4d0-7cf3-b080-fd2a8729b7a8
slug: tasks/yzx-iso/t8-1-interface-design
title: "T8.1 — Design the acquire/release control interface"
type: task
status: draft
priority: high
tags: [yzx-iso, T8, design]
---

Overview: Declarative, audited API by which LifeOS takes and releases host resources.

## Acceptance
- [ ] API surface defined
- [ ] Audit-log schema set
- [ ] Reversibility guaranteed

Parent [[tasks/yzx-iso/t8-0-lane-index]] · Goal G8

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine host acquire/release control interface.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-101 on worktree-archbp-frontier
