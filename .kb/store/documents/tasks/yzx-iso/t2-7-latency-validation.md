---
id: 019f87ff-9058-7d73-a1bc-d42152e5f138
slug: tasks/yzx-iso/t2-7-latency-validation
title: "T2.7 — Validate native latency vs bare metal"
type: task
status: draft
priority: medium
tags: [yzx-iso, T2, test]
---

Overview: Benchmark in-envelope vs bare-native; assert near-zero overhead (no hypervisor tax).

## Acceptance
- [ ] Benchmark harness built
- [ ] Overhead within noise
- [ ] Result recorded for T10.7

Parent [[tasks/yzx-iso/t2-0-lane-index]] · Goal G2

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: ARCHBP-039 (product_execution=true) captured redb commit-to-read latency samples (method exists). Fixed-latency claims BLOCKED per coverage correction #4. Envelope-latency benchmark not done.
- remaining scope (goal preserved, NOT narrowed): envelope benchmark vs bare metal
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-130 on worktree-archbp-frontier
