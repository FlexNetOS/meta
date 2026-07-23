---
id: 019f8801-a627-7481-bed5-6e3ff9569704
slug: tasks/yzx-iso/t10-1-packaging-decision
title: "T10.1 — Decide release packaging strategy"
type: task
status: draft
priority: high
tags: [yzx-iso, T10, design]
---

Overview: Choose nix bundle vs static-musl vs relocatable/embedded store for the portable release.

## Acceptance
- [ ] Strategy chosen + justified
- [ ] Trade-offs recorded
- [ ] Prototype path identified

Parent [[tasks/yzx-iso/t10-0-lane-index]] · Goal G6

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: ARCHBP-029 (COMPLETE) decides Rust toolchain bundling vs build-only provenance; FOUNDATION-001..003 nix+musl plan; YZXCONV-021 musl eligibility open. Release-packaging strategy not finalized.
- remaining scope (goal preserved, NOT narrowed): finalize nix-bundle vs static-musl vs relocatable-store
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-134 on worktree-archbp-frontier
