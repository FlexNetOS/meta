---
id: 019f8801-a6a2-78b3-b49a-5d8ab8de44a4
slug: tasks/yzx-iso/t10-8-survival-reattach
title: "T10.8 — Full survival + auto re-attach test"
type: task
status: draft
priority: high
tags: [yzx-iso, T10, test]
---

Overview: Integrated test across T3/T4/T7: reboot, survive, auto re-attach, resume.

## Acceptance
- [ ] Integrated test passes
- [ ] Survival + re-attach proven
- [ ] Sessions resume

Parent [[tasks/yzx-iso/t10-0-lane-index]] · Goal G3,G7

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: ARCHBP-045 durability + (new) re-attach; integrated survival+auto-reattach test not built.
- remaining scope (goal preserved, NOT narrowed): integrated survival + auto-reattach test
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-135 on worktree-archbp-frontier
