---
id: 019f87ff-8ff4-7450-acdf-52b21928f8a4
slug: tasks/yzx-iso/t2-1-envelope-design
title: "T2.1 — Design envelope rootfs + bind-mount layout"
type: task
status: draft
priority: high
tags: [yzx-iso, T2, design]
---

Overview: Define private /, /nix, home overlay, and durable-state mounts the sandbox presents.

## Acceptance
- [ ] Mount table specified
- [ ] Overlay vs bind decisions recorded
- [ ] Matches tier map T1.2

Parent [[tasks/yzx-iso/t2-0-lane-index]] · Goal G2

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: 05_HERMETIC_CELL_CONTRACT.md defines the bounded-cell design (allowed/blocked paths, network denied-by-default, snapshot, rollback; v0 hermetic, not container-first, Docker not required). DESIGN only; no implementation proof record.
- remaining scope (goal preserved, NOT narrowed): bubblewrap implementation
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-129 on worktree-archbp-frontier
