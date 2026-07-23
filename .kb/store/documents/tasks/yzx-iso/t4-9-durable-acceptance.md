---
id: 019f8800-7045-7fd2-b288-5e40e639af1f
slug: tasks/yzx-iso/t4-9-durable-acceptance
title: "T4.9 — Acceptance: reboot leaves state byte-identical"
type: task
status: draft
priority: high
tags: [yzx-iso, T4, acceptance]
---

Overview: Kill + reboot; Postgres/redb/state verified byte-identical.

## Acceptance
- [ ] Reboot test run
- [ ] Byte-identical confirmed
- [ ] Evidence recorded

Parent [[tasks/yzx-iso/t4-0-lane-index]] · Goal G3

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: designed-not-built
- evidence: ARCHBP-045 proves PITR restore byte-identical on a disposable cluster; T4.9 kill+reboot-of-the-live-system byte-identical test is different. Mechanism proven, live-reboot survival not.
- remaining scope (goal preserved, NOT narrowed): live kill+reboot survival test
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-132 on worktree-archbp-frontier
