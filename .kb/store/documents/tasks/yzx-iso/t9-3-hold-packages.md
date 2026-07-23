---
id: 019f8801-a59f-73c3-92aa-ccea906bcf55
slug: tasks/yzx-iso/t9-3-hold-packages
title: "T9.3 — Hold desktop-breaking packages during active work"
type: task
status: draft
priority: medium
tags: [yzx-iso, T9, impl]
---

Overview: Temporarily hold snapd, accountsservice, kernel upgrades while a session is live.

## Acceptance
- [ ] Holds applied during work
- [ ] Released after
- [ ] No live-session breakage

Parent [[tasks/yzx-iso/t9-0-lane-index]] · Goal G10,G1

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine hold of desktop-breaking packages during active work.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-111 on worktree-archbp-frontier
