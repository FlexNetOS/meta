---
id: 019f8800-7145-7e70-83e4-be0233d24901
slug: tasks/yzx-iso/t6-4-data-migration
title: "T6.4 — Migrate Omada data from docker mongo to nix mongo"
type: task
status: draft
priority: medium
tags: [yzx-iso, T6, impl]
---

Overview: Export/import network config so AP/switch adoption is preserved.

## Acceptance
- [ ] Data migrated
- [ ] Config intact
- [ ] Reversible backup kept

Parent [[tasks/yzx-iso/t6-0-lane-index]] · Goal G9

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of Omada data migration.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-087 on worktree-archbp-frontier
