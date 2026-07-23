---
id: 019f8800-6fbf-7950-805e-a705474108cf
slug: tasks/yzx-iso/t4-1-postgres-datadir
title: "T4.1 — Postgres 17.10 + RuVector on persistent storage"
type: task
status: draft
priority: high
tags: [yzx-iso, T4, impl]
---

Overview: Stand up PostgreSQL 17.10 with datadir under meta/var/lib/postgresql (persistent, not container).

## Acceptance
- [ ] Postgres 17.10 running
- [ ] Datadir persistent and owned by LifeOS
- [ ] Links [[tasks/lifeos-postgresql-durable-st]]

Parent [[tasks/yzx-iso/t4-0-lane-index]] · Goal G3

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: done-in-spine
- evidence: PostgreSQL 17.10 durable cluster under meta/var is live and exercised: ARCHBP-038/042/045/046 proof records run product_execution=true against real PostgreSQL 17.10 (durable meta/var cluster). STORE-001 sets PG canonical.
- remaining scope (goal preserved, NOT narrowed): confirm datadir path == T4.1 meta/var/lib/postgresql target
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- cross-reference only (already done in spine): ARCHBP-045/046/038/042 (real PG 17.10)
