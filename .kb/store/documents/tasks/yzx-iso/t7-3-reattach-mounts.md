---
id: 019f8801-a44c-70f3-83ce-6b4db2241ce1
slug: tasks/yzx-iso/t7-3-reattach-mounts
title: "T7.3 — Re-attach durable mounts (postgres/redb/runtime)"
type: task
status: draft
priority: medium
tags: [yzx-iso, T7, impl]
---

Overview: Rebind the durable plane so services find their data.

## Acceptance
- [ ] Durable mounts re-attached
- [ ] Paths match T3/T4
- [ ] Ownership correct

Parent [[tasks/yzx-iso/t7-0-lane-index]] · Goal G3,G7

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of re-attaching durable mounts on boot.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-095 on worktree-archbp-frontier
