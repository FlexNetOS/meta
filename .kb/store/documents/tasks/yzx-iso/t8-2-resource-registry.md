---
id: 019f8801-a4e2-76e2-ad4d-c979c508d05b
slug: tasks/yzx-iso/t8-2-resource-registry
title: "T8.2 — Build the controllable resource registry"
type: task
status: draft
priority: medium
tags: [yzx-iso, T8, impl]
---

Overview: Register desktop apps, daemons, network, GPU, ports, update/power as controllable resources.

## Acceptance
- [ ] Registry enumerated
- [ ] Per-resource acquire/release adapter
- [ ] Prior-state capture

Parent [[tasks/yzx-iso/t8-0-lane-index]] · Goal G8

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine controllable-host-resource registry.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-102 on worktree-archbp-frontier
