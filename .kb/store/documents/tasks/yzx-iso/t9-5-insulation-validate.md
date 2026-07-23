---
id: 019f8801-a5c0-78c2-8ec0-54d4ff392d27
slug: tasks/yzx-iso/t9-5-insulation-validate
title: "T9.5 — Validate insulation (host upgrade does not touch LifeOS)"
type: task
status: draft
priority: medium
tags: [yzx-iso, T9, test]
---

Overview: Run a host upgrade; confirm LifeOS state/services unaffected.

## Acceptance
- [ ] Host upgrade performed
- [ ] LifeOS unaffected
- [ ] Evidence recorded

Parent [[tasks/yzx-iso/t9-0-lane-index]] · Goal G10,G1

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine host-upgrade insulation validation.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-113 on worktree-archbp-frontier
