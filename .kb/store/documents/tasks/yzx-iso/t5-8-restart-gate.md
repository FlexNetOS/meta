---
id: 019f8800-70e0-7372-a705-fa0a00c2cb82
slug: tasks/yzx-iso/t5-8-restart-gate
title: "T5.8 — Restart-gated finalize ordering"
type: task
status: draft
priority: medium
tags: [yzx-iso, T5, impl]
---

Overview: Ensure finalize refuses unless XDG already redirected; sequence one session restart.

## Acceptance
- [ ] Finalize guard enforced
- [ ] Order documented in runbook
- [ ] Dry-run then apply

Parent [[tasks/yzx-iso/t5-0-lane-index]] · Goal G5

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: Restart-gated finalize ordering documented in the migrate runbook; not executed.
- remaining scope (goal preserved, NOT narrowed): execute ordering
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- gap applied in-place to existing ARCHBP-030
