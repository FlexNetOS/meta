---
id: 019f87ff-8fc3-7181-92de-f2d9f40e7aa0
slug: tasks/yzx-iso/t1-8-acceptance-gauntlet
title: "T1.8 — Specify the end-to-end acceptance gauntlet"
type: task
status: draft
priority: medium
tags: [yzx-iso, T1, test]
---

Overview: Define the proof matrix used at release: update+reboot loss test, host-change test, latency benchmark, survival/re-attach test.

## Acceptance
- [ ] Gauntlet steps enumerated
- [ ] Pass/fail criteria per step
- [ ] Adopted by [[tasks/yzx-iso/t10-0-lane-index]]

Parent [[tasks/yzx-iso/t1-0-lane-index]] · Goal G1

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: Release-acceptance machinery exists (RELEASE-001 fail-closed; ARCHBP-047 path-walk release gates NOT-COMPLETE). Isolation-specific gauntlet not defined there.
- remaining scope (goal preserved, NOT narrowed): isolation gauntlet (update+reboot, host-change, latency, survival)
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- gap applied in-place to existing ARCHBP-047
