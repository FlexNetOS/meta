---
id: 019f87ff-8f93-7e00-b320-b5f12852b196
slug: tasks/yzx-iso/t1-5-conformance-tests
title: "T1.5 — Define per-goal conformance tests"
type: task
status: draft
priority: medium
tags: [yzx-iso, T1, test]
---

Overview: For each goal G1-G10 define the concrete runnable test that proves it (e.g. host full-upgrade+reboot leaves LifeOS byte-identical).

## Acceptance
- [ ] G1-G10 each has a named test
- [ ] Tests reference invariant IDs
- [ ] Gauntlet handed to [[tasks/yzx-iso/t10-0-lane-index]]

Parent [[tasks/yzx-iso/t1-0-lane-index]] · Goal G1

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: RELEASE-001 (product_execution=false, fail-closed) recomputes blueprint coverage, not G1-G10 isolation conformance tests.
- remaining scope (goal preserved, NOT narrowed): G1-G10 tests
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-062 on worktree-archbp-frontier
