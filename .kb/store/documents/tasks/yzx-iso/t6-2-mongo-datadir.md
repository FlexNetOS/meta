---
id: 019f8800-7123-7cd2-9aba-acc370c62dd4
slug: tasks/yzx-iso/t6-2-mongo-datadir
title: "T6.2 — Durable Mongo datadir on persistent storage"
type: task
status: draft
priority: medium
tags: [yzx-iso, T6, impl]
---

Overview: Mongo dbpath on LifeOS persistent storage, not container overlay.

## Acceptance
- [ ] dbpath persistent
- [ ] Survives reboot
- [ ] Not in /var/lib/docker

Parent [[tasks/yzx-iso/t6-0-lane-index]] · Goal G9,G3

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of Omada Mongo datadir.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-085 on worktree-archbp-frontier
