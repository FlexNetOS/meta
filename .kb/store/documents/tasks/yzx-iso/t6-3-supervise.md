---
id: 019f8800-7134-7933-a8f7-62fd34c5eca8
slug: tasks/yzx-iso/t6-3-supervise
title: "T6.3 — Supervise Omada via nix (unit or bwrap service)"
type: task
status: draft
priority: medium
tags: [yzx-iso, T6, impl]
---

Overview: Run Omada as a nix-supervised service inside the envelope, not host docker.

## Acceptance
- [ ] Service starts/stops via nix
- [ ] Auto-start declared
- [ ] Logs captured

Parent [[tasks/yzx-iso/t6-0-lane-index]] · Goal G9

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of nix-supervising Omada.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-086 on worktree-archbp-frontier
