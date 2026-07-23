---
id: 019f8801-a539-7141-aefd-481fbf0468a9
slug: tasks/yzx-iso/t8-7-safety-guards
title: "T8.7 — Safety guards: no permanent takeover"
type: task
status: draft
priority: high
tags: [yzx-iso, T8, test]
---

Overview: Enforce the little-brother-always-functions invariant; controls are reversible and time-bounded.

## Acceptance
- [ ] No permanent takeover possible
- [ ] Auto-release on failure
- [ ] Invariant tested

Parent [[tasks/yzx-iso/t8-0-lane-index]] · Goal G8,G10

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine little-brother-always-functions guard.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-106 on worktree-archbp-frontier
