---
id: 019f87ff-9048-7273-97a5-e9c880efb120
slug: tasks/yzx-iso/t2-6-resource-hooks
title: "T2.6 — Resource acquisition hooks (GPU/ports/devices)"
type: task
status: draft
priority: medium
tags: [yzx-iso, T2, impl]
---

Overview: On-demand passthrough of GPU, ports, and devices into the envelope for big-brother control.

## Acceptance
- [ ] GPU passthrough works
- [ ] Port/device acquire+release
- [ ] Integrates [[tasks/yzx-iso/t8-0-lane-index]]

Parent [[tasks/yzx-iso/t2-0-lane-index]] · Goal G8

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of on-demand GPU/port/device passthrough into an envelope.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-069 on worktree-archbp-frontier
