---
id: 019f8801-a691-71d1-87bd-df144206442a
slug: tasks/yzx-iso/t10-7-latency-benchmark
title: "T10.7 — Native-latency benchmark vs bare metal"
type: task
status: completed
priority: medium
tags: [yzx-iso, T10, test]
---

Overview: Benchmark the released envelope vs bare native; confirm no hypervisor tax.

## Acceptance
- [x] Benchmark run — the unchanged T2.7 harness (`scripts/envelope-latency-bench.mjs`) pointed at the RELEASED bundle launcher (envelope `--store` mode, host store hidden, 36-path/234MB closure incl. python3) via `YZX_ENVELOPE_BIN`; 9 interleaved self-timed runs per arm.
- [x] Overhead within noise — bare 1.0293s vs released envelope 1.0364s median → **0.69%** runtime overhead, ~33ms one-time setup; consistent with dev-host −0.04% (ARCHBP-130): no hypervisor tax (I04).
- [x] Consumes T2.7 harness — harness not forked or modified; receipt carries `consumes` + the harness's own schema.

Parent [[tasks/yzx-iso/t10-0-lane-index]] · Goal G2

## Reconciliation verdict (yzx-iso vs planning-spine, 2026-07-22)
- verdict: genuine-new
- evidence: Native-latency-vs-bare-metal envelope benchmark; fixed-latency claims BLOCKED per coverage; not done.
- remaining scope (goal preserved, NOT narrowed): all
- basis: strict — done-in-spine only where a proof_record has product_execution_performed=true AND the capability matches; no coverage assumed by name; no downgrade without a cited proof.


## Spine application (2026-07-22, archbp-frontier)
- added as spine ARCHBP-120 on worktree-archbp-frontier

## Completion evidence (2026-07-22)
- Spine ARCHBP-120 Complete: red `1683e74` → green `42e8fa3` (FlexNetOS/lifeos PR #98), proof `planning-spine-v0/proof_records/ARCHBP-120.proof.json` (ledger seq 375), receipt `docs/envelope_released_benchmark.json`, suite 507/507.
