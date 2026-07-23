---
id: 019f87ff-8fb3-7283-b037-17f35b35d64f
slug: tasks/yzx-iso/t1-7-failure-mode-catalog
title: "T1.7 — Catalog isolation failure modes"
type: task
status: draft
priority: medium
tags: [yzx-iso, T1, architecture]
---

Overview: Enumerate what breaks isolation today: unattended-upgrades kernel swap, tmpfs profile-runtime, home residuals, host docker/kvm.

## Acceptance
- [ ] Each failure mode has root cause + owning task
- [ ] Reboot incident 2026-07-21 captured
- [ ] Feeds T5, T6, T9

Parent [[tasks/yzx-iso/t1-0-lane-index]] · Goal G1

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: Isolation failure catalog (unattended-upgrades kernel swap, tmpfs profile-runtime, home residuals, docker/kvm) is new; not in spine.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-063 on worktree-archbp-frontier
