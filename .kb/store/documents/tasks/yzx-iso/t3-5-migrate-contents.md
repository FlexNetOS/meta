---
id: 019f87ff-90dd-7d40-a55d-3eb29b21040a
slug: tasks/yzx-iso/t3-5-migrate-contents
title: "T3.5 — Migrate existing profile-runtime contents"
type: task
status: draft
priority: medium
tags: [yzx-iso, T3, impl]
---

Overview: Copy current /run profile-runtime state to the new persistent root with no loss.

## Acceptance
- [ ] Contents migrated and verified
- [ ] Integrity checked
- [ ] Old tmpfs copy retired safely

Parent [[tasks/yzx-iso/t3-0-lane-index]] · Goal G3

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of migrating profile-runtime contents off /run.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-074 on worktree-archbp-frontier
