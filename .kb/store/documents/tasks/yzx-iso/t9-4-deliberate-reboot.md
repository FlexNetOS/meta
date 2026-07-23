---
id: 019f8801-a5b0-7bd0-96b1-b5a3da95ddc9
slug: tasks/yzx-iso/t9-4-deliberate-reboot
title: "T9.4 — Make reboots deliberate"
type: task
status: draft
priority: medium
tags: [yzx-iso, T9, impl]
---

Overview: Disable auto-reboot; notify + require intent before reboot.

## Acceptance
- [ ] Auto-reboot disabled
- [ ] Notification path
- [ ] Intent required

Parent [[tasks/yzx-iso/t9-0-lane-index]] · Goal G10

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine deliberate-reboot policy.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-112 on worktree-archbp-frontier
