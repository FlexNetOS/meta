---
id: 019f21c3-d7df-74b3-be2f-dda644c2e0f3
slug: tasks/meta-read-extracted-gitkb-docs-for-codex-wiring
title: "Read extracted GitKB docs before Codex wiring"
type: task
status: completed
priority: high
---

# Summary
Read the full extracted GitKB docs snapshot before changing Codex wiring, then verify we are not duplicating plugin, skill, instruction, or MCP server responsibilities.

# Acceptance Criteria
- [x] Read every file under docs/gitkb.
- [x] Extract docs guidance about Claude, Codex, agent harnesses, MCP setup, skills, and plugins.
- [x] Compare docs guidance against current .claude, .codex, .kb/skills, codex-plugins, claude-plugins, and MCP config surfaces.
- [x] Identify any doubled-up responsibilities or conflicting setup.
- [x] Record findings in the KB task before implementation work proceeds.

# Findings

## Docs guidance read

- The extracted docs snapshot contains 20 files under `docs/gitkb` including the 19 page extractions plus `README.md`.
- The docs define `.kb/skills/` as the canonical GitKB workflow source. Harness directories such as `.claude/skills/` and `.codex/skills/` are adapter or forwarder layers, not independent workflow sources.
- The docs say `git-kb init codex` creates repo-local `.codex/skills/` and `.codex/instructions/`. It does not describe Codex lifecycle hooks as part of the repo-local `init codex` scaffold.
- The docs say Codex MCP should be configured through `codex mcp add gitkb -- git-kb mcp` or an equivalent `[mcp_servers.gitkb]` entry in `$CODEX_HOME/config.toml` / `~/.codex/config.toml`.
- The docs say `git-kb init claude` creates `.claude/rules/`, `.claude/skills/`, `.claude/settings.json`, and `CLAUDE.md`.
- The docs say the `kb-*` command-style workflows are now skills loaded from `.kb/skills/`, not separate `.claude/commands/` or `.codex/commands/` directories.
- The docs expose `git-kb init git hooks` as the Git hook installer for GitKB branch-symbol pruning. This is separate from both `init claude` and `init codex`.
- The docs define `[hooks]` in `.kb/config.toml` as the lifecycle automation feature-toggle layer read by harness adapters.

## Current repo surfaces

- `.codex/skills/*` are symlinks to `../../.kb/skills/*`. This matches the documented canonical-skill adapter model and is not a duplicate source of truth.
- `.codex/instructions/codex-rules.md` and `.codex/instructions/gitkb-process.md` match the documented Codex scaffold shape.
- `.kb/config.toml` currently has identity, sync, code, embeddings, and auth sections, but no `[hooks]` section.
- `.claude/settings.json` contains Claude lifecycle hooks for `meta context`, `agent guard`, and daemon start/status.
- `.claude/commands/kb-board.md`, `.claude/commands/kb-commit.md`, `.claude/commands/kb-context.md`, `.claude/commands/kb-status.md`, and `.claude/commands/kb-tasks.md` exist even though the extracted docs say `kb-*` workflows are now skills instead of separate command directories.

## Plugin and MCP surfaces

- `~/.codex/config.toml` has `features.plugins = true`, `plugins."gitkb@gitkb".enabled = true`, and a global `[mcp_servers.gitkb]` pointing to `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-meta`.
- The `gitkb-mcp-meta` wrapper sets `GITKB_ROOT=/home/flexnetos/FlexNetOS/src/meta`, prepends the workspace `usr/bin`, and execs `/home/flexnetos/FlexNetOS/usr/bin/git-kb mcp`. This is the active global Codex MCP route for meta.
- `codex-plugins/plugins/gitkb/.mcp.json` also declares an MCP server named `gitkb` using `git-kb mcp`. If Codex loads plugin MCP in addition to the global config, this is a possible duplicate MCP registration.
- The installed plugin cache at `~/.codex/plugins/cache/gitkb/gitkb/0.1.0+codex.20260702020541/.mcp.json` has the same MCP declaration.
- The installed plugin cache has `hooks/hooks.json` set to `{ "hooks": {} }`, so the currently cached plugin is not actively installing lifecycle hooks.
- The source plugin file `codex-plugins/plugins/gitkb/hooks/hooks.json` still contains broad lifecycle hooks that call `git-kb hook codex`, but installed `/home/flexnetos/FlexNetOS/usr/bin/git-kb 0.2.12` reports `hook` as an unrecognized subcommand. That source plugin hook file is out of sync with both the installed plugin cache and the installed CLI.
- The source plugin `codex-plugins/plugins/gitkb/.codex-plugin/plugin.json` describes "Codex hooks, skills, and MCP config", while the installed plugin cache describes "skills and MCP config" and explicitly says workspace lifecycle hooks remain owned by the active session root.
- `~/.codex/config.toml` still has trusted hook-state entries for `/home/flexnetos/FlexNetOS/src/meta/.codex/hooks.json`, but `src/meta/.codex/hooks.json` does not currently exist. These entries are stale global trust state, not active repo files.
- `.roo/mcp.json` contains an empty `mcpServers` object and is not a GitKB duplication source.

## Risk calls

- Intended adapter duplication: `.kb/skills` plus `.codex/skills` symlinks plus `.claude/skills` adapters are expected by the docs.
- Real drift: source `codex-plugins/plugins/gitkb` and installed plugin cache disagree about hooks, plugin description, and lifecycle ownership.
- Real potential duplication: global Codex MCP server `gitkb` plus plugin `.mcp.json` server `gitkb`.
- Real stale surface: global Codex hook trust entries for a removed `src/meta/.codex/hooks.json`.
- Real Claude stale surface: `.claude/commands/kb-*` appears older than the extracted docs' skill-only model.

## Recommended next tasks

- Reconcile `codex-plugins/plugins/gitkb` source with the installed cache and docs: remove or redesign `git-kb hook codex` source hooks unless/until the CLI implements that command.
- Decide whether GitKB MCP ownership should be global Codex config or plugin MCP for this workspace. Avoid both declaring the same `gitkb` server.
- Add documented `[hooks]` toggles to `.kb/config.toml` only if the current GitKB version and harness adapters actually read them.
- Audit and likely retire `.claude/commands/kb-*` after confirming Claude does not require them, because docs say `kb-*` workflows are skills now.
- Clear stale Codex hook trust entries for removed `src/meta/.codex/hooks.json` only through the proper Codex config/plugin management path.
