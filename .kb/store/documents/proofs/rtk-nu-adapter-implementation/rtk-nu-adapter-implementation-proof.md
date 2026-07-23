---
id: 019f80b3-7f77-7203-b21e-a65359ba206b
slug: proofs/rtk-nu-adapter-implementation/rtk-nu-adapter-implementation-proof
title: "rtk_nu adapter implementation proof"
type: reference
status: completed
priority: high
tags: [architecture-blueprint, rtk-nu, proof, byte-lineage]
---

Immutable-anchor sections 3.4 and 4.4 require a separately packaged adapter that preserves raw stdout and stderr bytes before adapter serialization, emits JSONL, JSON, and Nuon envelopes, and leaves native Nu as a bypass. Implementation commit `71393632412ca5d5a1fc5c92b378a2cf1a641de7` adds the `rtk_nu` binary, base64 frames with digests and offsets, metadata and completion records, binary/nonzero/partial-output tests, and a package contract. Repair commit `c9af82a66f74cc95d826a59df5654829db88bcda` delegates legacy launch through the literal `rtk proxy` raw-command frontdoor, replaces Unix-only fixtures with a cross-platform Cargo binary, and makes the benchmark fixture input deterministic.

At `c9af82a`, `cargo fmt --all -- --check`, `cargo clippy --all-targets -- -D warnings`, and `cargo test --all` passed (2,436 RTK unit tests, 3 `rtk_nu` unit tests, and all integration suites). The CI-mode benchmark exited zero with zero negative and zero failed filters. A baseline Semgrep scan against `origin/develop` returned zero current findings. Source-built live Nushell 0.113.1 proof parsed three JSONL records, one JSON frame, and one Nuon frame; the binary fixture retained exit code 7 in its JSON completion envelope. `rtk_nu` receives the raw streams relayed by `rtk proxy` before it performs any envelope decoding, filtering, normalization, or serialization.

GitHub PR #11 was reviewed against the raw diff and a refreshed GitKB code index (8,458 symbols, 49,122 call sites for the exact feature worktree). It merged cleanly into `FlexNetOS/rtk-tokenkill` `develop` at squash commit `e8229286e3eb23b3d0932e7713b5be530f3bfa39` on 2026-07-20. All pre-merge gates passed: fmt, clippy, docs, test-presence, Security Scan, Semgrep, CodeQL, benchmark, and test matrices on Ubuntu, macOS, and Windows. The merged PR URL is https://github.com/FlexNetOS/rtk-tokenkill/pull/11.
