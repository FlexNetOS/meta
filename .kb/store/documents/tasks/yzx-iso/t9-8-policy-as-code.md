---
id: 019f8801-a5f4-76a2-b624-ccc99f5c76d8
slug: tasks/yzx-iso/t9-8-policy-as-code
title: "T9.8 — Update policy as code + guard"
type: task
status: draft
priority: medium
tags: [yzx-iso, T9, impl]
---

Overview: Encode update governance as declarative config, not manual steps.

## Acceptance
- [ ] Policy declared in config
- [ ] Guard enforces it
- [ ] Reviewable in repo

Parent [[tasks/yzx-iso/t9-0-lane-index]] · Goal G10

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine update-policy-as-code.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-116 on worktree-archbp-frontier
