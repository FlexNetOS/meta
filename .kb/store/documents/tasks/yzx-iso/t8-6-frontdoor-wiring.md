---
id: 019f8801-a528-76f2-90b6-299d754c4362
slug: tasks/yzx-iso/t8-6-frontdoor-wiring
title: "T8.6 — Wire Glass/Engine Room front door to control plane"
type: task
status: draft
priority: medium
tags: [yzx-iso, T8, impl]
---

Overview: Connect the LifeOS Glass (Tauri/Svelte) and Yazelix Engine Room (yzx enter/Zellij) front door to the control plane.

## Acceptance
- [ ] Front door invokes control plane
- [ ] Bidirectional door stays operational
- [ ] Auth enforced

Parent [[tasks/yzx-iso/t8-0-lane-index]] · Goal G8

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: ARCHBP-043 (BLOCKED) embed real yzx enter/Zellij Engine Room in Vue/Tauri Glass; ARCHBP-018 (READY) LifeOS-Yazelix UDS ownership. Front-door transport designed, not built; control-plane wiring new.
- remaining scope (goal preserved, NOT narrowed): build front door + wire to control plane
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- gap applied in-place to existing ARCHBP-043
