---
id: 019f8801-a48d-72b2-9cd7-624ee2bafe9f
slug: tasks/yzx-iso/t7-7-failure-handling
title: "T7.7 — Handle partial state / dirty shutdown"
type: task
status: completed
priority: medium
tags: [yzx-iso, T7, test]
---

Overview: Recover cleanly from crash/dirty shutdown (WAL replay, redb crash path).

## Acceptance
- [x] Dirty-shutdown recovery works — live drill on the canonical cluster: kill -9 postmaster (down confirmed, stale-pid dirty marker), recovery via the sanctioned reattach path (`scripts/dirty-shutdown-recovery.mjs`, lifeos archbp-frontier).
- [x] WAL/replay validated — from the cluster's own log: "not properly shut down; automatic recovery in progress", "redo starts at 0/119DC7E0", "redo done at 0/11E20EF8"; re-verified live by the always-on spec.
- [x] No corruption — sentinel md5 byte-identical across the crash (500/500 rows), redb probe intact; drill DB dropped (rollback), durable receipt retained.

Parent [[tasks/yzx-iso/t7-0-lane-index]] · Goal G3,G7

## Completion evidence (2026-07-22)
- Spine ARCHBP-133 Complete: red `b3101fb` → green `67ce3ec` (FlexNetOS/lifeos PR #98), proof `planning-spine-v0/proof_records/ARCHBP-133.proof.json` (ledger seq 373), suite 500/500.
- Side findings recorded: [[incidents/postgres-logfile-unrotated]] (1.79 GB unrotated cluster log).

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: Partial component mechanisms exist: ARCHBP-039 crash replay (redb) + ARCHBP-045 WAL/PITR (product_execution=true). Orchestrated dirty-shutdown recovery of the whole envelope not built.
- remaining scope (goal preserved, NOT narrowed): envelope-level dirty-shutdown recovery
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-133 on worktree-archbp-frontier
