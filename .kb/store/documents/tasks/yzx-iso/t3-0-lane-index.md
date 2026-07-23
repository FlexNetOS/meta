---
id: 019f87ff-908b-7461-a95b-c10a8084539d
slug: tasks/yzx-iso/t3-0-lane-index
title: "T3.0 — Relocate runtime off host /run (lane index)"
type: task
status: draft
priority: high
tags: [yzx-iso, T3, epic]
---

Lane index/epic for T3. Rolls up T3.1-T3.9.

## Rollup acceptance
- [ ] profile-runtime on persistent nix-declared path
- [ ] Session survives reboot

Parent [[yazilix-nix-isolated-persistant]] · Goal G4,G3

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: Runtime-off-/run relocation. ARCHBP-030 (READY, not built) targets envctl canonical root + legacy toolchain bridge, not profile-runtime off host tmpfs.
- remaining scope (goal preserved, NOT narrowed): lane
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.

## Normative authority (ratified 2026-07-22)
This lane references the ratified isolation spec v1.0.0:
lifeos planning-spine-v0/docs/isolation-architecture-spec.md (spine ARCHBP-058..064; invariant ledger, tier map, failure modes, CT-G1..CT-G10 alongside it).
