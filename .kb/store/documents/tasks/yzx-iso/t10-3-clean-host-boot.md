---
id: 019f8801-a64e-7b20-8330-b969bb81272a
slug: tasks/yzx-iso/t10-3-clean-host-boot
title: "T10.3 — Clean-host boot test (no nix daemon, no /nix/store)"
type: task
status: draft
priority: medium
tags: [yzx-iso, T10, test]
---

Overview: Run the release on a clean host lacking Nix; confirm it starts.

## Acceptance
- [ ] Boots on clean host
- [ ] No nix daemon needed
- [ ] No /nix/store needed

Parent [[tasks/yzx-iso/t10-0-lane-index]] · Goal G6

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: Within ARCHBP-021 (READY, not built) scope.
- remaining scope (goal preserved, NOT narrowed): clean-host boot test
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- gap applied in-place to existing ARCHBP-021
