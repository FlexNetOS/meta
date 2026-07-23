---
id: 019f87ff-9068-7411-aab3-10bf0fe2e626
slug: tasks/yzx-iso/t2-8-multi-session
title: "T2.8 — Support concurrent envelopes / sessions"
type: task
status: draft
priority: low
tags: [yzx-iso, T2, impl]
---

Overview: Multiple envelopes on one shared kernel without state collision.

## Acceptance
- [ ] N envelopes coexist
- [ ] No cross-session leakage
- [ ] Shared durable plane safe

Parent [[tasks/yzx-iso/t2-0-lane-index]] · Goal G2

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of concurrent envelopes.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-070 on worktree-archbp-frontier
