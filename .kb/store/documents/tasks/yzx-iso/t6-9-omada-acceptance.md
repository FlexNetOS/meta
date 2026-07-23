---
id: 019f8800-719b-7360-8e12-acfc0866fb95
slug: tasks/yzx-iso/t6-9-omada-acceptance
title: "T6.9 — Acceptance: Omada on nix, docker/kvm off, host normal"
type: task
status: draft
priority: high
tags: [yzx-iso, T6, acceptance]
---

Overview: Prove Omada runs under nix, docker+kvm stacks off, host functions normally.

## Acceptance
- [ ] Omada nix-served
- [ ] docker/kvm off
- [ ] Host normal (drdave path)

Parent [[tasks/yzx-iso/t6-0-lane-index]] · Goal G9,G1

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine Omada acceptance.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-092 on worktree-archbp-frontier
