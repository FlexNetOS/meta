---
id: 019f8800-70ac-77a1-b601-583c99bbd18a
slug: tasks/yzx-iso/t5-5-remove-flexnetos
title: "T5.5 — Remove ~/FlexNetOS skeleton after re-point"
type: task
status: draft
priority: medium
tags: [yzx-iso, T5, impl]
---

Overview: Delete the Jul-13 runner residual once the runner no longer targets it.

## Acceptance
- [ ] ~/FlexNetOS removed
- [ ] Does not regenerate
- [ ] Verified across a reboot

Parent [[tasks/yzx-iso/t5-0-lane-index]] · Goal G5

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: Removal of the ~/FlexNetOS runner residual; not in spine.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-080 on worktree-archbp-frontier
