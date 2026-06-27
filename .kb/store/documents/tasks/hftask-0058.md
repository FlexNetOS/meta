---
id: 019ee823-0ebd-7d63-8fc0-c54daa5068d2
slug: tasks/hftask-0058
title: "Serialize RVF-backed ledger v2 tests (fix FsyncFailed flake under workspace parallelism)"
type: task
status: active
priority: medium
---

# Overview

`ledger::v2` (HFTASK-0006, #69) RVF-backed tests flake under full `cargo test --workspace`
parallelism (~1 in 5): a panic in `Ledger::open` with `rusqlite ToSqlConversionFailure`
wrapping RVF error `0x0303` = `FsyncFailed`. A *different* v2 test fails each run
(`events_after_and_rollup_still_work`, `semantic_recall_finds_similar_event`, …), which
rules out a single bad test and points at a shared resource race. The tests pass in
isolation and under `-p ledger --lib` alone (the contention only appears when many test
binaries hammer `/tmp` IO concurrently). Discovered during the develop/master sync
reconciliation (PR #91); `v2.rs` is byte-identical to develop, so the merge did not
introduce it.

## Root cause

`RvfStore::create` (`RuVector/crates/rvf/rvf-runtime/src/store.rs:112`) opens several files
and fsyncs the manifest, and collapses **any** open/IO failure into `FsyncFailed`. Each
test already uses a unique path (pid + nanos), so this is transient fd/fsync resource
pressure under load, not a logic bug. The ledger is opened single-threaded in production
(`hf` CLI, sequential rollup), so unbounded concurrent `create` only happens in tests.

## Goals

- Make the v2 RVF tests deterministic under full-workspace parallelism without weakening
  what they assert.
- Keep the fix in-scope to the `handoff` repo (do not modify the sibling RuVector crate).

## Acceptance Criteria

- [x] A process-global serialization guard bounds concurrency of the RVF-touching v2 tests.
- [x] Guard recovers from mutex poisoning so one failure can't cascade.
- [x] `temp_db()` hardened with a monotonic counter (unique path even on same-nanosecond calls).
- [x] `cargo test --workspace` green across repeated runs (stress-tested, 0 failures).
- [x] fmt + clippy `--all-targets -D warnings` clean.

## Notes / follow-up

- Upstream finding (NOT fixed here, sibling repo): `store.rs:112` mislabels every
  `create_new` open failure as `FsyncFailed` — worth a RuVector issue so the real errno
  surfaces. Out of scope for this handoff-side test fix.

## Completion Evidence

- Fix: `ledger/src/v2.rs` test module — `RVF_TEST_GUARD` mutex + `rvf_guard()` + counter in `temp_db()`.
- PR: (filled at ship)
