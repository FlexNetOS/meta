---
id: 019f87f6-b4fa-79c3-b21f-8d52f5c3974a
slug: tasks/yzx-iso/t1-0-lane-index
title: "T1.0 — Isolation architecture spec & invariant ledger (lane index)"
type: task
status: draft
priority: high
tags: [yzx-iso, T1, architecture, epic]
---

Lane index / epic for T1. Rolls up T1.1–T1.9. Parent goal: [[yazilix-nix-isolated-persistant]] G1 (foundation for all). See repo-root spec yazilix-nix-isolated-persistant.md.

## Rollup acceptance
- [ ] T1.1–T1.9 all completed with evidence
- [ ] Invariant ledger merged and referenced by T2–T10

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine equivalent for an OS-isolation architecture spec/invariant ledger; spine authority (RELEASE-001 North Star acceptance, ARCHBP-047 anchor gates) governs blueprint-anchor conformance, not two-brother OS-isolation.
- remaining scope (goal preserved, NOT narrowed): entire lane
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.

## Normative authority (ratified 2026-07-22)
This lane references the ratified isolation spec v1.0.0:
lifeos planning-spine-v0/docs/isolation-architecture-spec.md (spine ARCHBP-058..064; invariant ledger, tier map, failure modes, CT-G1..CT-G10 alongside it).
