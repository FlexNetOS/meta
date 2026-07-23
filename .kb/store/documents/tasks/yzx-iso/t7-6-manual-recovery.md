---
id: 019f8801-a47d-7521-898c-5a6ce6a36a47
slug: tasks/yzx-iso/t7-6-manual-recovery
title: "T7.6 — Single-command manual recovery path"
type: task
status: draft
priority: low
tags: [yzx-iso, T7, impl]
---

Overview: One command that performs full re-attach when auto-trigger is undesired.

## Acceptance
- [ ] Command implemented
- [ ] Idempotent
- [ ] Documented

Parent [[tasks/yzx-iso/t7-0-lane-index]] · Goal G7

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine single-command manual recovery path.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-098 on worktree-archbp-frontier
