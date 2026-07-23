---
id: 019f87ff-90ab-75d2-a4d2-c33b88a5ef86
slug: tasks/yzx-iso/t3-2-choose-root
title: "T3.2 — Choose the persistent runtime root"
type: task
status: draft
priority: high
tags: [yzx-iso, T3, design]
---

Overview: Select the nix-declared persistent root (meta/var-based or dedicated mount) for profile-runtime.

## Acceptance
- [ ] Root chosen and justified
- [ ] Owned by nix/yazelix, not host /run
- [ ] Survives reboot

Parent [[tasks/yzx-iso/t3-0-lane-index]] · Goal G4

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: STORE-001 (product_execution=false) sets durable-class ownership; ARCHBP-030 (READY) covers envctl root relocation. Persistent profile-runtime root not selected.
- remaining scope (goal preserved, NOT narrowed): root decision
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- gap applied in-place to existing ARCHBP-030
