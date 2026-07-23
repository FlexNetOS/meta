---
id: 019f87ff-8f71-7311-9973-a76fabcd9019
slug: tasks/yzx-iso/t1-3-shared-kernel-boundary
title: "T1.3 — State the shared-kernel boundary"
type: task
status: draft
priority: high
tags: [yzx-iso, T1, architecture]
---

Overview: Record the one honest limit: namespaces share the host kernel (source of zero latency); reboot ends processes but never state. Survival = durable tier + re-attach.

## Acceptance
- [ ] Boundary and rationale documented
- [ ] Isolation vs survival separated as orthogonal
- [ ] Referenced by [[tasks/yzx-iso/t7-0-lane-index]]

Parent [[tasks/yzx-iso/t1-0-lane-index]] · Goal G2,G7

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine statement of the namespaces-share-kernel / reboot-ends-processes-not-state boundary.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-060 on worktree-archbp-frontier
