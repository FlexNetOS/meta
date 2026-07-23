---
id: 019f8800-7024-78e0-b58c-3b76bd05539d
slug: tasks/yzx-iso/t4-7-byte-complete
title: "T4.7 — Verify byte-complete ingress (nu_plugin/CodeDB)"
type: task
status: draft
priority: medium
tags: [yzx-iso, T4, test]
---

Overview: Confirm raw-byte capture beside derived representations; hashes supplement not replace bytes.

## Acceptance
- [ ] Raw bytes stored
- [ ] Reconciliation passes
- [ ] Zero undeclared loss

Parent [[tasks/yzx-iso/t4-0-lane-index]] · Goal G3

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: done-in-spine
- evidence: ARCHBP-038.proof.json product_execution=true: codedb-host-import stores every byte (13 fail-closed classes), sha256 recomputed inside PostgreSQL, byte/structure/metadata/semantic/provenance reconstruction verified, fail-closed on unclassifiable. Matches T4.7.
- remaining scope (goal preserved, NOT narrowed): none
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- cross-reference only (already done in spine): ARCHBP-038
