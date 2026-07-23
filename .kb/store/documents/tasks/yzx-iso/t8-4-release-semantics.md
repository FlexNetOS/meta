---
id: 019f8801-a506-7eb2-b257-513195852dcd
slug: tasks/yzx-iso/t8-4-release-semantics
title: "T8.4 — Implement clean-release semantics"
type: task
status: draft
priority: high
tags: [yzx-iso, T8, impl]
---

Overview: Restore prior host state on release so the OS returns to normal.

## Acceptance
- [ ] Release restores prior state
- [ ] Verified OS normalcy
- [ ] No residue

Parent [[tasks/yzx-iso/t8-0-lane-index]] · Goal G8,G10

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine clean-release-restores-host semantics.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-104 on worktree-archbp-frontier
