---
id: 019f8801-a418-7272-b5f9-b2a77b7555d7
slug: tasks/yzx-iso/t7-0-lane-index
title: "T7.0 — Boot re-attach mechanism (lane index)"
type: task
status: draft
priority: high
tags: [yzx-iso, T7, epic]
---

Lane index/epic for T7. Rolls up T7.1-T7.9.

## Rollup acceptance
- [ ] Reboot auto re-attaches to durable state
- [ ] Services + sessions restored

Parent [[yazilix-nix-isolated-persistant]] · Goal G7,G3

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: Boot re-attach lane. RECOVERY family (product_execution=false) is prior-task-table sealing, NOT system re-attach.
- remaining scope (goal preserved, NOT narrowed): lane
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.

## Normative authority (ratified 2026-07-22)
This lane references the ratified isolation spec v1.0.0:
lifeos planning-spine-v0/docs/isolation-architecture-spec.md (spine ARCHBP-058..064; invariant ledger, tier map, failure modes, CT-G1..CT-G10 alongside it).
