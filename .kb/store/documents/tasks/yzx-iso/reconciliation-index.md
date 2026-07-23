---
id: 019f8857-df9f-7af3-b0c0-b59ba9310596
slug: tasks/yzx-iso/reconciliation-index
title: "yzx-iso reconciliation index (verdicts + deltas, 2026-07-22)"
type: task
status: draft
priority: high
tags: [yzx-iso, reconciliation, index, verdicts]
---

Conflict/overlap reconciliation of the 100 yzx-iso tasks against Fable 5 planning-spine-v0 (session 047abf20, branch worktree-archbp-frontier @ 014ce2d, pushed to origin). Read: ARCHITECTURE_BLUEPRINT_TASK_COVERAGE.md, generated/task_graph.status.json (233 complete, 0 draft, 5 blocked, 6 ready), and the cited proof_records. Strict rule: done-in-spine only where proof_record.product_execution_performed=true AND capability matches.

## Counts
- done-in-spine: 6
- designed-not-built: 23
- genuine-new: 71

## done-in-spine (6) — durable storage plane only
- t4-1 PostgreSQL 17.10 datadir -> ARCHBP-038/042/045/046 run against real PG 17.10 on durable meta/var cluster
- t4-2 ruvector extension -> ARCHBP-045 (ruvector 0.3.0 in schema extensions, live distance query)
- t4-3 redb plane -> ARCHBP-039 (single-owner redb, mmap generations, ordered events, crash replay)
- t4-4 envctl committer -> ARCHBP-042 (envctl-only PG committer, grant-enforced)
- t4-7 byte-complete ingress -> ARCHBP-038 (13-class byte-complete host import + reconstruction)
- t4-8 backup/restore -> ARCHBP-045 (PITR drill, byte-identical restore)

## genuine-new deltas worth folding into the spine numbering (capability groups)
- T2 bubblewrap envelope IMPLEMENTATION (hermetic cell contract is design-only)
- T3 profile-runtime relocation OFF host /run tmpfs (distinct from ARCHBP-030 envctl-root)
- T5 path-law residuals: ~/.claude, ~/.local/share tools, ~/FlexNetOS runner _work
- T6 Omada docker->nix + retire host docker/KVM (personal-infra, wholly absent)
- T7 boot re-attach of envelope + services + sessions (RECOVERY family is task-table sealing, not this)
- T8 big-brother host-control plane (acquire/release host resources), beyond ARCHBP-018/043 transport
- T9 OS-update-lifecycle governance / unattended-upgrades insulation (wholly absent)
- T1 two-brother isolation spec + invariant ledger + shared-kernel boundary + failure catalog
- T10 isolation gauntlets: host-update+reboot zero-loss, LifeOS-update zero-host-change, native-latency benchmark

## Guardrails honored
- Spine NOT edited. Only yzx-iso task bodies edited (## Reconciliation verdict appended per task).
- No task downgraded/closed without strict cited proof. No status changes. No goal narrowed.
- APPROVAL GATE: no in-spine application until owner review + approval.