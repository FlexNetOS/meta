---
id: 019f8800-7168-7512-b5aa-a74201a6e783
slug: tasks/yzx-iso/t6-6-remove-container
title: "T6.6 — Remove docker Omada container + image"
type: task
status: draft
priority: medium
tags: [yzx-iso, T6, impl]
---

Overview: Delete the moby container 98ade093 and its image after successful cutover.

## Acceptance
- [ ] Container removed
- [ ] Image pruned
- [ ] No auto-restart residue

Parent [[tasks/yzx-iso/t6-0-lane-index]] · Goal G1

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of removing the Omada docker container.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-089 on worktree-archbp-frontier
