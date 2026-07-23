---
id: 019f8800-708b-7480-8468-631ccf68f90c
slug: tasks/yzx-iso/t5-3-close-dotlocal
title: "T5.3 — Close ~/.local/share tool state via migrate runbook"
type: task
status: draft
priority: high
tags: [yzx-iso, T5, impl]
---

Overview: Run meta/var/ops migrate-tool-state-off-dotlocal for icm/rtk/weave/yazelix.

## Acceptance
- [ ] Tool state relocated
- [ ] migrate verify passes
- [ ] finalize removes dotlocal

Parent [[tasks/yzx-iso/t5-0-lane-index]] · Goal G5

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: meta/var/ops migrate-tool-state-off-dotlocal runbook exists (CLAUDE.md restart-gated note); execution not proven.
- remaining scope (goal preserved, NOT narrowed): run migrate/verify/finalize
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- gap applied in-place to existing ARCHBP-030
