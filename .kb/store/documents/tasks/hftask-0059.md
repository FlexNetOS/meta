---
id: 019ee82b-aa41-7880-819b-60306a102932
slug: tasks/hftask-0059
title: "v1 concurrent-writers test fails on Windows (SQLite WAL busy_timeout not robust under CI load)"
type: task
status: active
priority: medium
---

# Overview

`ledger::v1::tests::concurrent_writers_serialize_no_lock_no_fork` (HFTASK-0028 AC1+AC2)
intermittently FAILS on `Test (windows-latest)`: `append` returns an error and the test
panics at `ledger/src/v1.rs:893` (`"append must not fail under concurrency"`). Observed on
PR #92's CI run (base `12e2d4e`); it passed on PR #93's run, so it is a load-sensitive
Windows flake, independent of the v2 fix (HFTASK-0058) and of the guard workflow (#92,
which only adds YAML). `Test (windows-latest)` is **not** a required check, so it does not
block merges — but it is a genuine robustness gap, not just a test artifact.

## Root cause (hypothesis)

The test spawns 8 threads × 25 appends against one SQLite file. HFTASK-0028 made writes
serialize via WAL + `busy_timeout=5000ms` + `BEGIN IMMEDIATE`. On Windows, file-locking
semantics differ and, under heavy CI load, a writer can exceed the 5000ms busy window (or
hit a Windows-specific WAL lock contention) and return `SQLITE_BUSY` instead of serializing
— so `append` errors. This is a production-relevant path (concurrent `hf` processes writing
the shared ledger), not only a test concern.

## Goals

- Make concurrent ledger writes robust on Windows so the test passes deterministically.
- Do not weaken the no-lost-writes / contiguous-no-fork guarantees the test asserts.

## Acceptance Criteria

- [ ] `concurrent_writers_serialize_no_lock_no_fork` passes on `Test (windows-latest)` across repeated runs.
- [ ] Concurrent appends still serialize: all writes land, seqs are contiguous 1..=N, witness chain verifies.
- [ ] No regression on ubuntu/macos.

## Candidate approaches

- Raise `busy_timeout` and/or add an explicit bounded retry loop on `SQLITE_BUSY` around the
  `BEGIN IMMEDIATE` append transaction (retry, don't surface the error).
- Verify WAL is actually enabled on Windows handles (and consider `wal_autocheckpoint` / a
  short randomized backoff between retries).
- Confirm the test's thread count/iteration count is realistic vs. the real concurrent-`hf`
  ceiling; the guarantee must hold at the real ceiling, not an arbitrary stress level.

## Context

- Discovered 2026-06-20 during the develop/master sync + v2-flake session. Sibling of the v2
  RVF flake [[tasks/hftask-0058]] but a distinct subsystem (v1 SQLite, not v2 RVF) and a
  distinct failure mode (SQLITE_BUSY under Windows concurrency, not fsync resource pressure).
- Origin test: HFTASK-0028 (serialize concurrent hf ledger writes).
