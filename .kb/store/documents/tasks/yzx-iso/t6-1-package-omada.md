---
id: 019f8800-7113-7212-8af6-b268eee2fcf5
slug: tasks/yzx-iso/t6-1-package-omada
title: "T6.1 — Package Omada controller (Java+Mongo) as nix"
type: task
status: draft
priority: high
tags: [yzx-iso, T6, impl]
---

Overview: Nix derivation/service for TP-Link Omada (com.tplink.smb.omada) replacing the docker image.

## Acceptance
- [ ] Omada builds via nix
- [ ] Java + mongod launch
- [ ] No docker dependency

Parent [[tasks/yzx-iso/t6-0-lane-index]] · Goal G9

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine Omada nix packaging.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-084 on worktree-archbp-frontier
