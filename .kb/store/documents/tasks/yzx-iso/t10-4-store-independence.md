---
id: 019f8801-a65e-7df1-a021-55ca124d8a79
slug: tasks/yzx-iso/t10-4-store-independence
title: "T10.4 — Verify store independence (RPATH/ldd audit)"
type: task
status: draft
priority: medium
tags: [yzx-iso, T10, test]
---

Overview: Audit binaries for any residual /nix/store references.

## Acceptance
- [ ] ldd/RPATH audited
- [ ] No /nix/store leaks
- [ ] Fixed or relocated

Parent [[tasks/yzx-iso/t10-0-lane-index]] · Goal G6

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: no-/nix/store claim explicitly BLOCKED until its named task proves it (coverage correction #4); ARCHBP-021.
- remaining scope (goal preserved, NOT narrowed): RPATH/ldd audit + fix
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- gap applied in-place to existing ARCHBP-021
