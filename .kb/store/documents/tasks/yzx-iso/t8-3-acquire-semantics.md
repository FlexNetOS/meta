---
id: 019f8801-a4f5-7691-9034-8bfcc950de68
slug: tasks/yzx-iso/t8-3-acquire-semantics
title: "T8.3 — Implement acquisition semantics"
type: task
status: draft
priority: medium
tags: [yzx-iso, T8, impl]
---

Overview: Take authoritative control while recording prior host state for restore.

## Acceptance
- [ ] Acquire records prior state
- [ ] Conflicts handled
- [ ] Audited

Parent [[tasks/yzx-iso/t8-0-lane-index]] · Goal G8

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine host-resource acquisition semantics.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-103 on worktree-archbp-frontier
