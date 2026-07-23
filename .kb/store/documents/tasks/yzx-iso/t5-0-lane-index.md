---
id: 019f8800-7056-7612-a910-3173d83dd46f
slug: tasks/yzx-iso/t5-0-lane-index
title: "T5.0 — Eliminate path-law residuals (lane index)"
type: task
status: draft
priority: high
tags: [yzx-iso, T5, epic]
---

Lane index/epic for T5. Rolls up T5.1-T5.9.

## Rollup acceptance
- [ ] Zero home-owned active owners
- [ ] Path-law green

Parent [[yazilix-nix-isolated-persistant]] · Goal G5,G4

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: Path-law residual elimination lane; residuals are this-session findings, not in spine.
- remaining scope (goal preserved, NOT narrowed): lane
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.

## Normative authority (ratified 2026-07-22)
This lane references the ratified isolation spec v1.0.0:
lifeos planning-spine-v0/docs/isolation-architecture-spec.md (spine ARCHBP-058..064; invariant ledger, tier map, failure modes, CT-G1..CT-G10 alongside it).
