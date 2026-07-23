---
id: 019f87ff-8f60-7182-81a6-41de3e5b97a4
slug: tasks/yzx-iso/t1-2-tier-map
title: "T1.2 — Define the volatile / durable / portable tier map"
type: task
status: draft
priority: high
tags: [yzx-iso, T1, architecture]
---

Overview: Exhaustively classify every runtime path into volatile (tmpfs), durable (persistent), or portable (release) tiers so classification cannot drift.

## Acceptance
- [ ] Every env var and state path classified
- [ ] Rule: nothing durable on host /run
- [ ] Feeds [[tasks/yzx-iso/t3-0-lane-index]]

Parent [[tasks/yzx-iso/t1-0-lane-index]] · Goal G1,G4

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: STORE-001 classifies DATA-STATE classes (durable/transient/cognitive), a different axis than runtime PATH tiers (volatile tmpfs / durable / portable). Not covered.
- remaining scope (goal preserved, NOT narrowed): runtime-path tier map
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-059 on worktree-archbp-frontier
