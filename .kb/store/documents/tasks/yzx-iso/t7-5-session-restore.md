---
id: 019f8801-a46c-72c3-b1d6-812809cde540
slug: tasks/yzx-iso/t7-5-session-restore
title: "T7.5 — Restore resumable session context"
type: task
status: draft
priority: medium
tags: [yzx-iso, T7, impl]
---

Overview: Re-expose claude/codex session transcripts from the durable plane for resume.

## Acceptance
- [ ] Sessions listed post-reboot
- [ ] Resume works
- [ ] No tmpfs dependency

Parent [[tasks/yzx-iso/t7-0-lane-index]] · Goal G7,G3

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: No spine coverage of restoring resumable claude/codex session context on boot.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-097 on worktree-archbp-frontier
