---
id: 019f87ff-90ee-79d0-91bc-ab52f15cb823
slug: tasks/yzx-iso/t3-6-envctl-commit
title: "T3.6 — Update envctl committer for new runtime rows"
type: task
status: draft
priority: high
tags: [yzx-iso, T3, impl]
---

Overview: Commit new bootstrap_env_vars rows via envctl (sole authoritative committer), no hand-edits.

## Acceptance
- [ ] Rows committed via envctl
- [ ] Live table reflects new root
- [ ] Restart-gated

Parent [[tasks/yzx-iso/t3-0-lane-index]] · Goal G4

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: envctl committer is runtime-proven for DB commits (ARCHBP-042, product_execution=true) but the bootstrap_env_vars runtime-relocation rows are ARCHBP-030 (READY, not built).
- remaining scope (goal preserved, NOT narrowed): commit runtime-relocation rows
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- gap applied in-place to existing ARCHBP-030
