---
id: 019f87ff-911f-77a3-9f09-550c9d686f8b
slug: tasks/yzx-iso/t3-9-reboot-acceptance
title: "T3.9 — Acceptance: live session survives reboot"
type: task
status: draft
priority: high
tags: [yzx-iso, T3, acceptance]
---

Overview: Reboot with a live session; session state intact afterward.

## Acceptance
- [ ] Reboot performed
- [ ] Session state intact
- [ ] Zero loss recorded

Parent [[tasks/yzx-iso/t3-0-lane-index]] · Goal G3

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: ARCHBP-045 proves PITR restore byte-identical on a disposable cluster, NOT live-session survival across a host reboot.
- remaining scope (goal preserved, NOT narrowed): live-reboot session-survival test
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-077 on worktree-archbp-frontier
