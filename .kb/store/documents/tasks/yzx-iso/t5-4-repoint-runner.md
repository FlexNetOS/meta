---
id: 019f8800-709b-7152-bdd3-0785c707480c
slug: tasks/yzx-iso/t5-4-repoint-runner
title: "T5.4 — Re-point flexnetos_runner _work off ~/FlexNetOS"
type: task
status: draft
priority: high
tags: [yzx-iso, T5, impl]
---

Overview: Reconfigure the self-hosted runner _work root into the profile/meta tier so it stops re-materializing ~/FlexNetOS.

## Acceptance
- [ ] Runner _work re-pointed
- [ ] Service restart clean
- [ ] No new ~/FlexNetOS on job run

Parent [[tasks/yzx-iso/t5-0-lane-index]] · Goal G5

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: flexnetos_runner _work off ~/FlexNetOS is a this-session finding; not in spine.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-079 on worktree-archbp-frontier
