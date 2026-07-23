---
id: 019f8801-a4ae-7453-9a11-aec7228f69a5
slug: tasks/yzx-iso/t7-9-reattach-acceptance
title: "T7.9 — Acceptance: reboot auto re-attach restores everything"
type: task
status: draft
priority: high
tags: [yzx-iso, T7, acceptance]
---

Overview: Prove reboot leads to automatic re-attach with services and sessions restored.

## Acceptance
- [ ] Auto re-attach confirmed
- [ ] Services up
- [ ] Sessions resumable

Parent [[tasks/yzx-iso/t7-0-lane-index]] · Goal G7

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine boot re-attach acceptance.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-100 on worktree-archbp-frontier
