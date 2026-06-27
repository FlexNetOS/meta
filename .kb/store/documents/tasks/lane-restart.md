---
id: 019e9658-f392-7ce0-bbfa-c31ea4969228
slug: tasks/lane-restart
title: "lane restart (daemon bounce, preserve domains)"
type: task
status: active
priority: medium
tags: [feature, cli, daemon]
---

# Overview

Add a `lane restart` command that bounces the lane daemon (down, then back up) while
leaving the persisted domain configuration intact, so a user can recover a wedged proxy
or re-apply daemon state without re-adding their domains.

Full verifiable spec: `_workspace/01_intent-analyst_spec.md` (in the `feat-restart`
worktree). Recommendation: **GREEN — safe to build as scoped.**

## Key lifecycle facts (grounded, with file:line)

- Domains persist to `~/.lane/config.yaml`: `Config::save()` `src/config/settings.rs:193`,
  `config::load()` `src/config/settings.rs:222`.
- Daemon reloads domains from disk on start: `run_foreground()` calls `config::load()`
  at `src/daemon/mod.rs:136`. => a fresh daemon serves whatever is on disk, so a plain
  bounce preserves domains for free.
- `stop` (no name) ERASES domains AND shuts down: `stop_all()` `src/cli/stop.rs:71-96`.
  => `restart` must NOT reuse stop_all / must NOT touch config.yaml or /etc/hosts.
- Shutdown via `MessageType::Shutdown` IPC `src/daemon/protocol.rs:17`, handled at
  `src/daemon/mod.rs:206`. Spawn via `run_detached` `src/daemon/mod.rs:65` +
  `wait_for_daemon` `src/daemon/mod.rs:98`. `is_running` `src/daemon/mod.rs:42`.
- CLI dispatch: `Commands` enum `src/cli/mod.rs:51`, `run()` `src/cli/mod.rs:207`.

## Semantics

`lane restart` (no args): if daemon running -> Shutdown IPC, wait for down, then
run_detached + wait_for_daemon; if not running -> just start it. Never touches
config.yaml or /etc/hosts. `[name]` argument is a NON-GOAL (no per-domain process;
per-domain refresh is the existing Reload verb).

## Exact messages

- running -> bounced: `Restarted lane daemon.`
- not running -> started: `lane daemon was not running; started it.`
- error contexts reuse existing strings: `stopping daemon`, `starting daemon`.

## Acceptance Criteria

Sandbox-safe (blocking):
- [ ] fmt/clippy/build/test clean.
- [ ] `restart` subcommand listed in `--help`; `restart --help` exits 0.
- [ ] `restart <name>` is rejected (no positional arg) — proves the `[name]` non-goal.
- [ ] Pure `decide_action(daemon_running: bool)` seam with unit tests
  (true=>Restarted, false=>Started).
- [ ] Unit test asserts the down IPC verb is `MessageType::Shutdown` (not Reload, no new verb).
- [ ] Config-preservation: seeded config.yaml is byte-unchanged; restart calls neither
  `Config::save()` nor `system::add_host`/`remove_host` (TempDir HOME + serial test).
- [ ] `MessageType` still has exactly Shutdown/Status/Reload (no new verb).
- [ ] No non-Rust artifact, no new heavy dep; `restart.rs` is the only new file.

Behavioral (best-effort, non-blocking in sandbox):
- [ ] e2e: start a domain, `restart` prints `Restarted lane daemon.`, pid changes,
  `list` still shows the domain.
- [ ] no-daemon: `restart` prints `lane daemon was not running; started it.`, then
  `is_running()` true.

## Affected areas

- `src/cli/mod.rs` — add `Restart` to `Commands`, dispatch arm, `mod restart;`.
- `src/cli/restart.rs` (new) — command body (decide action, Shutdown IPC, spawn+wait).
- `daemon` — reused, not changed.
- `config`/`system` — must NOT be mutated by restart.

## Open questions (non-blocking)

- Re-ensure port-forwarding after bounce? Default: process-bounce only for v1.
- Append `print_services(...)` for nicer output? Cosmetic; pinned status strings unchanged.

## Context

- Spec: `_workspace/01_intent-analyst_spec.md`
- Input intent: `_workspace/00_input/intent.md`
- Worktree: `~/Desktop/meta/.worktrees/feat-restart/lane`
