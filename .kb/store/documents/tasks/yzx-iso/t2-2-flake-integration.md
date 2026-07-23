---
id: 019f87ff-9007-7643-800c-c25f2444388c
slug: tasks/yzx-iso/t2-2-flake-integration
title: "T2.2 — Add bwrap wrapper to the yazelix Nix flake"
type: task
status: draft
priority: medium
tags: [yzx-iso, T2, impl]
---

Overview: Package the envelope as a flake app/package so it is nix-declared, not ad-hoc.

## Acceptance
- [ ] bwrap wrapper builds via flake
- [ ] No host installs required
- [ ] Pinned inputs

Parent [[tasks/yzx-iso/t2-0-lane-index]] · Goal G2

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No bwrap/user-namespace flake implementation proof record in spine.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-065 on worktree-archbp-frontier
