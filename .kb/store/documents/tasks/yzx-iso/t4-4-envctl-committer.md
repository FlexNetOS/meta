---
id: 019f8800-6ff0-71f2-984d-7c0935dfac4d
slug: tasks/yzx-iso/t4-4-envctl-committer
title: "T4.4 — Route ingress through envctl sole committer"
type: task
status: draft
priority: high
tags: [yzx-iso, T4, impl]
---

Overview: All durable writes go through envctl, the sole authoritative PostgreSQL/RuVector ingress committer.

## Acceptance
- [ ] envctl committer path live
- [ ] No bypass writers
- [ ] Links [[tasks/restore-envctl-shared-substr]]

Parent [[tasks/yzx-iso/t4-0-lane-index]] · Goal G3,G9

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: done-in-spine
- evidence: ARCHBP-042.proof.json product_execution=true: envctl exclusive PostgreSQL committer, PG-grant-enforced (intruder INSERT to SQLSTATE 42501), ordered idempotent drain, UDS return projection. Matches T4.4.
- remaining scope (goal preserved, NOT narrowed): none
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- cross-reference only (already done in spine): ARCHBP-042
