---
id: 019ec0f1-666e-7b83-ba8c-eb3ab4675b3b
slug: tasks/libsql-baton-refresh
title: "libSQL Hrana baton-refresh: reconnect on invalid baton"
type: task
status: done
priority: high
tags: [envctl, secretd, libsql, store-robustness, bugfix]
---

# Overview

`secretctl unlock` failed on a `secretd` that had sat locked/idle, with
`libSQL query failed: Hrana: api error: status=400 ... Received an invalid baton`.
A Phase-1 store-robustness gap in `crates/secrets-store-libsql`, independent of
the Cognitum Seed vault-factor work (PR #50) that surfaced it during runtime
verification.

## Root cause

`SyncConnection::run_retry` already wraps every read/write primitive
(`query_all`/`query_one`/`execute`) and reconnects-on-expiry — but its
`is_stream_expired` predicate matched only the `STREAM_EXPIRED` shape. sqld
returns a SECOND, equally-recoverable Hrana session fault — a 400
`Received an invalid baton` — when a long-idle connection makes its first
request (or the DB generation advanced under a concurrent writer). Unmatched →
`run_retry` did not reconnect → the 400 surfaced. `status` (no libSQL query)
worked; `unlock` (`load_keyslots`, the first real query) tripped the dead baton.

## Goals

- Recover transparently from the `invalid baton` 400, identical to `STREAM_EXPIRED`.
- No spurious retry of genuine, non-session errors.

## Acceptance Criteria

- [x] `is_stream_expired` matches `invalid baton` (+ sibling `baton not found` / `stream not found`).
- [x] Unit test asserting the exact `status=400 ... Received an invalid baton` shape reconnects.
- [x] Genuine errors (UNIQUE, connection-refused) still do NOT retry.
- [x] crate tests pass; clippy `-D warnings` clean; no-c/shape/enable gates PASS.

## Completion Evidence

- Branch `libsql-baton-fix`; PR **#53** (base `master`).
- `crates/secrets-store-libsql/src/sync.rs` — `is_stream_expired` + module doc + tests.
- Verified: crate tests 11 pass (incl. the 400 shape), clippy clean, gates PASS.

## Apply

Lives in the installed daemon (`~/.cargo/bin/secretd`). After merge:
`cargo install --path crates/secretd` (or rebuild + replace) then restart the
daemon — `unlock` transparently reconnects on a stale baton.
