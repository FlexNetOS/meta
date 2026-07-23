---
id: 019f8801-a517-7120-8eaf-368c8e2f0e48
slug: tasks/yzx-iso/t8-5-audit-trail
title: "T8.5 — Audit trail for all acquire/release"
type: task
status: draft
priority: medium
tags: [yzx-iso, T8, impl]
---

Overview: Durable, reversible log of every control action.

## Acceptance
- [ ] Every action logged
- [ ] Reversible from log
- [ ] Stored in durable plane

Parent [[tasks/yzx-iso/t8-0-lane-index]] · Goal G8

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: Spine has a proof ledger/witness chain, but a host-resource-control audit trail is a different capability; not covered.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-105 on worktree-archbp-frontier
