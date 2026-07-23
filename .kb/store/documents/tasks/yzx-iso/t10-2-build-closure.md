---
id: 019f8801-a63d-72c2-a1eb-4f68a7b80ade
slug: tasks/yzx-iso/t10-2-build-closure
title: "T10.2 — Build the portable closure"
type: task
status: draft
priority: medium
tags: [yzx-iso, T10, impl]
---

Overview: Produce a self-contained closure that carries its own store, no host /nix/store dependency.

## Acceptance
- [ ] Closure builds
- [ ] Self-contained
- [ ] Reproducible

Parent [[tasks/yzx-iso/t10-0-lane-index]] · Goal G6

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: ARCHBP-021 (READY) prove full-stack Yazelix musl + portable closure; YZXCONV-021 musl eligibility. Not built; no-store/static-musl claims BLOCKED per coverage correction #4.
- remaining scope (goal preserved, NOT narrowed): build the closure
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- gap applied in-place to existing ARCHBP-021
