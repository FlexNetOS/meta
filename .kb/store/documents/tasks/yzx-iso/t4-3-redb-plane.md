---
id: 019f8800-6fe0-7173-8906-66f797769a12
slug: tasks/yzx-iso/t4-3-redb-plane
title: "T4.3 — Wire redb transient shared plane"
type: task
status: draft
priority: medium
tags: [yzx-iso, T4, impl]
---

Overview: Single-owner file-backed redb buffer publishing read-only mmap projection + ordered wakeup events.

## Acceptance
- [ ] redb owner process defined
- [ ] mmap projection published
- [ ] Never treated as source of truth

Parent [[tasks/yzx-iso/t4-0-lane-index]] · Goal G3

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: done-in-spine
- evidence: ARCHBP-039.proof.json product_execution=true: flexnetos-redb-owner single writable handle, atomic checksummed mmap projection generations, ordered commit-notification events, crash replay, corruption fallback. Matches T4.3 acceptance exactly.
- remaining scope (goal preserved, NOT narrowed): none
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- cross-reference only (already done in spine): ARCHBP-039
