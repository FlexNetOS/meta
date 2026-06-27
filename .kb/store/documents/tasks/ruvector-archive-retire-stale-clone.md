---
id: 019eed02-acd3-7a53-a5ce-51eeeee0f07e
slug: tasks/ruvector-archive-retire-stale-clone
title: "Archive + retire the stale RuVector clone (keep compressed safe backup)"
type: task
status: active
priority: medium
---

## Overview
`RuVector/` (15G; 14G is regenerable `target/`, 663M `.git`) is a stale second clone
of `meta-ruvector.git` @ main — clean, 0 uncommitted, fully pushed. `meta-ruvector/`
is now the canonical clone (PR FlexNetOS/meta#40). Retire `RuVector/` to remove the
two-clone confusion, keeping a compressed safe backup just in case.

## Goals
- Compress `RuVector/` to a safe backup archive (exclude regenerable `target/`).
- Remove the live `RuVector/` directory from the active workspace.
- Drop `RuVector` from parent `.gitignore` + root `Cargo.toml` exclude (no longer present).

## Acceptance Criteria
- [ ] Compressed archive exists + integrity-verified (tar test); reconstitutes the repo.
- [ ] `RuVector/` dir removed; `meta-ruvector/` remains canonical.
- [ ] Parent `.gitignore` / `Cargo.toml` no longer reference `RuVector`.
- [ ] `meta project list` still shows `ruvector (meta-ruvector)`.

## Context
GitHub origin is the ultimate backup (clean+pushed); the local archive is extra caution.
Related: FlexNetOS/meta#40 (repoint), meta-ruvector#33 (audit).
