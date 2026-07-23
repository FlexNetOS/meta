---
id: 019f8800-7102-70c0-ae77-935ccc09e5f9
slug: tasks/yzx-iso/t6-0-lane-index
title: "T6.0 — Migrate Omada into Nix; retire Docker/KVM (lane index)"
type: task
status: draft
priority: high
tags: [yzx-iso, T6, epic]
---

Lane index/epic for T6. Rolls up T6.1-T6.9.

## Rollup acceptance
- [ ] Omada under nix, datadir durable
- [ ] Docker/KVM boot stack off

Parent [[yazilix-nix-isolated-persistant]] · Goal G9,G8,G1

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of Omada/docker/kvm; personal-infra outside the blueprint.
- remaining scope (goal preserved, NOT narrowed): lane
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.

## Normative authority (ratified 2026-07-22)
This lane references the ratified isolation spec v1.0.0:
lifeos planning-spine-v0/docs/isolation-architecture-spec.md (spine ARCHBP-058..064; invariant ledger, tier map, failure modes, CT-G1..CT-G10 alongside it).
