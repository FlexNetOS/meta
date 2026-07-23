---
id: 019f87ff-9017-7cb1-b7fe-eb4ff5497f99
slug: tasks/yzx-iso/t2-3-enter-lifecycle
title: "T2.3 — Implement yzx enter entry lifecycle"
type: task
status: draft
priority: medium
tags: [yzx-iso, T2, impl]
---

Overview: Namespace setup, env injection, cwd, shell (nu inside only).

## Acceptance
- [ ] yzx enter starts envelope
- [ ] Env matches declared tiers
- [ ] Host shell untouched

Parent [[tasks/yzx-iso/t2-0-lane-index]] · Goal G2,G5

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: ARCHBP-026 (Home Manager/profile startup, complete) is not the envelope enter lifecycle. No coverage.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-066 on worktree-archbp-frontier
