---
id: 019f8801-a6b3-77c0-9666-e14e59a494b5
slug: tasks/yzx-iso/t10-9-release-signoff
title: "T10.9 — Release sign-off: all G1-G10 conformance green"
type: task
status: draft
priority: high
tags: [yzx-iso, T10, acceptance]
---

Overview: Final gate: every goal conformance test green; ship the portable release.

## Acceptance
- [ ] G1-G10 tests green
- [ ] Release signed off
- [ ] Shipped

Parent [[tasks/yzx-iso/t10-0-lane-index]] · Goal G6,G1,G2,G7

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: RELEASE-001 acceptance runs fail-closed (release NOT certified); ARCHBP-048 (BLOCKED) cutover + retire transitional authorities. Sign-off not achieved.
- remaining scope (goal preserved, NOT narrowed): achieve green release + owner cutover
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- gap applied in-place to existing ARCHBP-048
