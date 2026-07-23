---
id: 019f8800-718a-7e20-8090-ea66b21a0e93
slug: tasks/yzx-iso/t6-8-meta-var-guard
title: "T6.8 — Guard: meta/var never bind-mounted into a container"
type: task
status: draft
priority: medium
tags: [yzx-iso, T6, test]
---

Overview: Assertion/test preventing meta/var from being mounted into docker/containerd.

## Acceptance
- [ ] Guard implemented
- [ ] CI/boot check
- [ ] Fails on violation

Parent [[tasks/yzx-iso/t6-0-lane-index]] · Goal G9

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine guard against meta/var being bind-mounted into a container.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-091 on worktree-archbp-frontier
