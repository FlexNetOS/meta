---
id: 019f87ff-910e-7cc3-8860-a38f655c362e
slug: tasks/yzx-iso/t3-8-restart-validate
title: "T3.8 — Validate adoption after session restart"
type: task
status: draft
priority: medium
tags: [yzx-iso, T3, test]
---

Overview: Restart yazelix session; confirm new roots adopted by the agent env.

## Acceptance
- [ ] New roots active post-restart
- [ ] No /run fallback
- [ ] Tools write to persistent root

Parent [[tasks/yzx-iso/t3-0-lane-index]] · Goal G3,G4

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of session-restart adoption of relocated roots.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-076 on worktree-archbp-frontier
