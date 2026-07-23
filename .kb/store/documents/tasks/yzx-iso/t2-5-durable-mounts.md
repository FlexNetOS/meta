---
id: 019f87ff-9038-7261-acd5-a4bd735734cd
slug: tasks/yzx-iso/t2-5-durable-mounts
title: "T2.5 — Wire durable-state mounts into the envelope"
type: task
status: draft
priority: medium
tags: [yzx-iso, T2, impl]
---

Overview: Bind meta/var, postgres datadir, and the relocated runtime path into the sandbox.

## Acceptance
- [ ] Durable paths visible inside envelope
- [ ] Writes persist across exit
- [ ] Depends on [[tasks/yzx-iso/t3-0-lane-index]]

Parent [[tasks/yzx-iso/t2-0-lane-index]] · Goal G2,G3

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of binding durable state into a user-namespace envelope.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-068 on worktree-archbp-frontier
