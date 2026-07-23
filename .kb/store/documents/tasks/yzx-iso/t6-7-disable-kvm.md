---
id: 019f8800-7179-7103-89a5-4943471c928f
slug: tasks/yzx-iso/t6-7-disable-kvm
title: "T6.7 — Disable unused libvirtd/qemu-kvm boot units"
type: task
status: draft
priority: low
tags: [yzx-iso, T6, impl]
---

Overview: Disable libvirtd, qemu-kvm, libvirt-guests boot units (host cleanup, leave host functional).

## Acceptance
- [ ] Units disabled
- [ ] Host still boots normally
- [ ] Reversible

Parent [[tasks/yzx-iso/t6-0-lane-index]] · Goal G1

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of disabling host libvirtd/qemu-kvm.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-090 on worktree-archbp-frontier
