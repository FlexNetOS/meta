---
id: 019f8800-70cd-7692-b326-7c86dd3f2337
slug: tasks/yzx-iso/t5-7-residual-guard
title: "T5.7 — Residual scanner / CI guard"
type: task
status: draft
priority: medium
tags: [yzx-iso, T5, test]
---

Overview: CI guard that fails on any home-owned active owner.

## Acceptance
- [ ] Scanner enumerates residuals
- [ ] CI fails on new residual
- [ ] Runs each session start

Parent [[tasks/yzx-iso/t5-0-lane-index]] · Goal G5

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine residual scanner/CI guard for home-owned owners.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-082 on worktree-archbp-frontier
