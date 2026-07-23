---
id: 019f21d2-802b-71f2-b1d5-aa2492b719ba
slug: tasks/meta-clear-stale-codex-hook-trust-state
title: "Clear stale Codex hook trust state for removed meta hooks"
type: task
status: completed
priority: high
---

# Summary
Clear stale global Codex hook trust entries for a removed `src/meta/.codex/hooks.json` file through the correct Codex management path.

# Evidence
- `~/.codex/config.toml` contains trusted hook hashes for `/home/flexnetos/FlexNetOS/src/meta/.codex/hooks.json:*`.
- `/home/flexnetos/FlexNetOS/src/meta/.codex/hooks.json` does not currently exist.
- The stale entries can make session state look like hooks are present or trusted even when the repo no longer contains that file.

# Acceptance Criteria
- [x] Research the supported Codex way to remove or refresh stale hook trust state.
- [x] Back up or otherwise preserve the relevant global config before changing it.
- [x] Remove only entries for the missing `src/meta/.codex/hooks.json` path.
- [x] Verify Codex still trusts the active project and does not reference removed meta hook files.
- [x] Record the exact command or edit path used.

# Completion Evidence

- `codex --help` exposes `--dangerously-bypass-hook-trust` but no hook-trust prune/remove command, so cleanup used a scoped config edit.
- Backed up global config to `/home/flexnetos/.codex/config.toml.pre-meta-plugin-control-plane.bak`.
- Removed only six `[hooks.state."/home/flexnetos/FlexNetOS/src/meta/.codex/hooks.json:*"]` tables from `/home/flexnetos/.codex/config.toml`.
- `rg "src/meta/\\.codex/hooks\\.json" /home/flexnetos/.codex/config.toml` returns no matches.
- `codex doctor` reports config parse ok, MCP servers 2, and `17 ok · 1 idle · 1 notes · 0 warn · 0 fail`.
