---
id: 019f8800-6fad-7933-97ad-446afc37ff9f
slug: tasks/yzx-iso/t4-0-lane-index
title: "T4.0 — Durable state plane Postgres/RuVector + redb (lane index)"
type: task
status: draft
priority: high
tags: [yzx-iso, T4, epic]
---

Lane index/epic for T4. Rolls up T4.1-T4.9.

## Rollup acceptance
- [ ] Postgres/RuVector canonical + redb transient live
- [ ] Every byte durable

Parent [[yazilix-nix-isolated-persistant]] · Goal G3,G9

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: Lane largely runtime-proven at child level (T4.1/4.2/4.3/4.4/4.7/4.8 done-in-spine). T4.5/4.6/4.9 remain.
- remaining scope (goal preserved, NOT narrowed): see children T4.5/4.6/4.9
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.

## Normative authority (ratified 2026-07-22)
This lane references the ratified isolation spec v1.0.0:
lifeos planning-spine-v0/docs/isolation-architecture-spec.md (spine ARCHBP-058..064; invariant ledger, tier map, failure modes, CT-G1..CT-G10 alongside it).
