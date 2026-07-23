---
id: 019f8800-7035-7c72-8150-b2377102c283
slug: tasks/yzx-iso/t4-8-backup-restore
title: "T4.8 — Backup/restore + integrity checks"
type: task
status: draft
priority: medium
tags: [yzx-iso, T4, test]
---

Overview: Automated backup + verifiable restore of the durable plane.

## Acceptance
- [ ] Backup runs
- [ ] Restore verified byte-identical
- [ ] Integrity gate in CI

Parent [[tasks/yzx-iso/t4-0-lane-index]] · Goal G3

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: done-in-spine
- evidence: ARCHBP-045.proof.json product_execution=true: disposable PITR drill on real PG 17.10 (data-checksums, WAL archive, streaming replication, base backup, selected-LSN PITR restore, row-counts + byte-hash equal; receipt verification/pitr-drill/results/receipt.json). Matches T4.8.
- remaining scope (goal preserved, NOT narrowed): schedule automation + CI integrity gate (drill is one-shot)
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- cross-reference only (already done in spine): ARCHBP-045
