---
id: 019f8801-a49e-72d0-9b1d-d2381bb07e21
slug: tasks/yzx-iso/t7-8-cold-reboot-harness
title: "T7.8 — Cold-reboot test harness"
type: task
status: completed
priority: medium
tags: [yzx-iso, T7, test]
---

Overview: Automated harness that cold-reboots and asserts full re-attach.

## Acceptance
- [x] Harness built — `scripts/cold-reboot-harness.mjs` (lifeos archbp-frontier): `arm` captures boot_id + service set + durable session baseline to durable-only storage; `verify` demands a NEW boot_id, runs the full T7 re-attach, writes a durable verdict receipt; `unit` emits the decoupled systemd user unit.
- [x] Runs unattended — verify proven as a stdin-free subprocess; unit Type=oneshot, WantedBy=default.target, no host-unit Requires=, no TTY directives.
- [x] Asserts service + session restore — fixture green path, loud NAMED failure on a dead service, same-boot refusal without the explicit override; production dry run 3/3 services healthy, 10/10 durable sessions restored.

Parent [[tasks/yzx-iso/t7-0-lane-index]] · Goal G7

## Completion evidence (2026-07-22)
- Spine ARCHBP-099 Complete: red `fd9e279` → green `ec1938b` (FlexNetOS/lifeos PR #98), proof `planning-spine-v0/proof_records/ARCHBP-099.proof.json` (ledger seq 371), suite 490/490.
- The production manifest is armed at `meta/var/xdg-data/lifeos/cold-reboot/expectation.json`; the physical reboot (t7-9 / spine ARCHBP-100, owner-gated) is fully instrumented: post-reboot `verify` demands the new boot_id and asserts full re-attach.

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine cold-reboot re-attach harness.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-099 on worktree-archbp-frontier
