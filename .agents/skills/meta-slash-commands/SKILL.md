---
name: meta-slash-commands
description: Use when the user asks for meta slash commands, Claude command parity, command hubs, or the Codex equivalent of slash-command workflows.
---

Codex repo-shared workflows should be skills. Claude standalone slash commands are tracked in `commands/registry.json`; plugin-bundled commands are tracked through `plugin_hub/registry.json`.

Current workspace facts:

- Codex has built-in slash commands such as `/plugins`, `/hooks`, `/skills`, `/mcp`, `/agent`, `/permissions`, `/status`, `/debug-config`, `/model`, `/plan`, and `/goal`.
- `commands/registry.json` is the source of truth for standalone Claude Code slash commands.
- The registry currently has no standalone command entries.
- Codex custom prompts are user-home scoped and deprecated; checked-in templates live under `.codex/prompts/` and must be installed to `~/.codex/prompts/` with `rtk agent codex install-prompts` before they appear as `/prompts:*`.
- Use `$meta-workspace`, `$meta-git`, `$meta-exec`, `$meta-plugins`, `$meta-worktree`, `$meta-safety`, and `$gitkb` as the repo-scoped Codex equivalents.
- Claude `/explore`, `/understand`, and `/before-refactor` map to `$gitkb` code-intelligence workflows in Codex.
- Claude `meta-worker` maps to an explicit Codex subagent prompt using the meta-worker lifecycle in `$meta-workspace`.

When command parity is requested, inspect `commands/README.md`, `commands/registry.json`, `plugin_hub/registry.json`, `claude-plugins/`, `.codex/prompts/`, and the active Codex `/` menu before making claims.
