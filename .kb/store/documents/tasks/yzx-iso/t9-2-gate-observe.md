---
id: 019f8801-a58e-73b3-b498-42ce8f5f59bf
slug: tasks/yzx-iso/t9-2-gate-observe
title: "T9.2 — Gate/observe updates via the control plane"
type: task
status: completed
priority: medium
tags: [yzx-iso, T9, impl]
---

Overview: Hook host update events so LifeOS can observe or gate them during active work.

## Acceptance
- [x] Update events observable — `scripts/os-update-observer.mjs` (lifeos archbp-frontier) parses live `/var/log/apt/history.log` into risk-classified events (ARCHBP-109 map patterns) + apt-daily timer surface; live: 19 events, 5 desktop-breaking, the 2026-07-21 kernel swap attributed directly to unattended-upgrade at 06:31:48.
- [x] Gating during active sessions — `os-update-hold` lease flips `gate-check` allow→block (exit-coded for the apt Pre-Invoke hook) with the live session count in the verdict; DPkg::Pre-Invoke snippet generated for ARCHBP-111's root install (/etc untouched).
- [x] Uses T8 control plane — lease-dir resource acquired/released through `HostControlPlane` with owner + TTL and durable restore-verified audit.

Parent [[tasks/yzx-iso/t9-0-lane-index]] · Goal G10

## Completion evidence (2026-07-22)
- Spine ARCHBP-110 Complete: red `00f6edf` → green `a72b463` (FlexNetOS/lifeos PR #98), proof `planning-spine-v0/proof_records/ARCHBP-110.proof.json` (ledger seq 372), suite 495/495.

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine gate/observe of host update events.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-110 on worktree-archbp-frontier
