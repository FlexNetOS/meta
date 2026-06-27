---
id: 019eed02-ace4-7d71-bfc4-93ab0bdfaada
slug: tasks/teri-meta-workspace-root-fix
title: "Fix teri<->meta workspace-root conflict (teri is a nested workspace, not a meta member)"
type: task
status: active
priority: medium
---

## Overview
Parent `meta` `cargo metadata` fails: "multiple workspace roots found in the same
workspace: teri and meta". `teri/Cargo.toml` is BOTH a `[package]` and a `[workspace]`
root (multi-crate: agent/api/graph/memory/models/report/seed/services/sim), but the
parent meta `Cargo.toml` lists `teri` as a workspace `member` — illegal nesting.

## Goals
- Move `teri` from parent `members` -> parent `exclude` (nested workspace builds
  independently), mirroring how meta-ruvector/RuVector are handled.
- Restore a clean `cargo metadata` on the parent meta workspace.

## Acceptance Criteria
- [ ] `cargo metadata --no-deps` on parent meta succeeds (no "multiple workspace roots").
- [ ] teri still builds standalone (`cargo build` in teri/).
- [ ] Check shimmy + other members for the same latent issue.

## Context
teri grew its own workspace during the MiroFish->teri port. Sibling card:
[[tasks/mirofish-teri-port-parity-proof]].
