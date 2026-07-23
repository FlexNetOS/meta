---
id: 019f8800-6fcf-7b81-b1b0-c987b6cb07b1
slug: tasks/yzx-iso/t4-2-ruvector-ext
title: "T4.2 — Install/verify RuVector extension in schema extensions"
type: task
status: draft
priority: high
tags: [yzx-iso, T4, impl]
---

Overview: Ensure ruvector extension present and verified; app rejects SQLite URLs.

## Acceptance
- [ ] ruvector in schema extensions
- [ ] Verification passes at boot
- [ ] Schema relocatable

Parent [[tasks/yzx-iso/t4-0-lane-index]] · Goal G3

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: done-in-spine
- evidence: ARCHBP-045.proof.json gate_result.extension_evidence: ruvector 0.3.0 survives in schema extensions and answers live distance queries ([1,0,0,0] to [0,1,0,0] = 1.4142) after restore; product_execution=true.
- remaining scope (goal preserved, NOT narrowed): none (schema-relocatable variant tracked separately)
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- cross-reference only (already done in spine): ARCHBP-045
