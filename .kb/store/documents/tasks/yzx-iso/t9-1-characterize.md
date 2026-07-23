---
id: 019f8801-a57d-7783-8fff-0a74e30ca347
slug: tasks/yzx-iso/t9-1-characterize
title: "T9.1 — Characterize host update mechanisms"
type: task
status: draft
priority: high
tags: [yzx-iso, T9, impl]
---

Overview: Map unattended-upgrades, apt, snap refresh, kernel installs and their triggers/timing.

## Acceptance
- [ ] Mechanisms + schedules documented
- [ ] Desktop-breaking pkgs identified
- [ ] 2026-07-21 incident referenced

Parent [[tasks/yzx-iso/t9-0-lane-index]] · Goal G10

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine characterization of unattended-upgrades/apt/snap/kernel.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-109 on worktree-archbp-frontier
