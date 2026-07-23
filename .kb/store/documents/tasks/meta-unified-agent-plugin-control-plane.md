---
id: 019f21d4-6b5c-7293-bf9c-700cb88b45eb
slug: tasks/meta-unified-agent-plugin-control-plane
title: "Design unified meta-owned agent plugin control plane"
type: task
status: draft
priority: high
---

# Summary
Design a unified, meta-owned control plane for agent plugins, marketplaces, MCP config, and shared skills without conflating meta CLI subprocess plugins with Claude/Codex assistant plugin payloads.

# Current Mental Model

Meta should own the source-of-truth registry and generation flow for assistant integrations:
- one meta-owned manifest of tools/capabilities;
- generated Claude plugin payloads under the Claude plugin schema;
- generated Codex plugin payloads under the Codex plugin schema;
- one documented MCP ownership decision per tool/server;
- one marketplace publication path per assistant, generated from the same meta registry.

This keeps meta as the central control plane while still respecting that Claude Code and Codex load plugins through their own plugin systems, caches, trust gates, and settings files.

# Research Notes

- Implementation refresh on 2026-07-02 checked current Codex plugin/MCP docs and Claude plugin docs.
- Meta CLI plugins are subprocess command planners discovered from `.meta/plugins`, `~/.meta/plugins`, and `PATH` as `meta-*` executables. They are not the same artifact type as Claude or Codex assistant plugins.
- Codex plugins can bundle skills, app integrations, MCP servers, and lifecycle hooks. Codex reads marketplace files from repo, personal, curated, and legacy-compatible locations, then installs plugins into `~/.codex/plugins/cache/$MARKETPLACE_NAME/$PLUGIN_NAME/$VERSION/`.
- Codex MCP can also be configured directly in `~/.codex/config.toml` or project `.codex/config.toml` via `[mcp_servers.<name>]`. This means plugin-provided MCP and global/project MCP can overlap unless ownership is explicit.
- Claude Code plugins are self-contained directories that can include skills, commands, agents, hooks, `.mcp.json`, LSP servers, and monitors. Marketplace installs are copied into `~/.claude/plugins/cache`; skills-directory plugins can also load in place.
- Claude supports user, project, local, and managed plugin scopes through `enabledPlugins` and marketplace settings. Project-scope plugins and MCP servers still go through trust/approval gates.
- Claude docs explicitly describe migrating standalone `.claude/` commands/agents/skills/hooks into a plugin and then removing originals to avoid duplicate behavior.
- Local repo state already has `claude-plugin/`, `claude-plugins/`, and `codex-plugins/`; `codex-plugins/README.md` says to add a Codex `meta` plugin after a `codex-plugin` payload mirrors the Claude plugin.

# Proposed Architecture

- Keep `meta-plugins/` for meta CLI subprocess plugin registry and executable command plugins.
- Keep assistant-specific payload directories as generated or published outputs:
  - `claude-plugin/` for Claude's installable meta plugin payload.
  - future `codex-plugin/` or `codex-plugins/plugins/meta/` for Codex's installable meta plugin payload.
  - `claude-plugins/` and `codex-plugins/` as marketplace catalogs, not hand-maintained divergent logic.
- Add a meta-owned integration manifest that declares capabilities once, then generates/validates assistant payloads.
- Use one MCP owner per server. For example, meta MCP may be owned by the meta assistant plugin, while GitKB MCP may be owned by global Codex config or the GitKB plugin, but not both.
- Treat `.claude/` and `.codex/` repo-local scaffolds as project adapters for the active repo, not as the marketplace source of truth.

# Acceptance Criteria

- [x] Read current Claude and Codex official plugin docs again at implementation time and capture version/date.
- [x] Inventory all local plugin payloads and marketplaces: `meta-plugins/`, `claude-plugin/`, `claude-plugins/`, `codex-plugins/`, `.claude/`, `.codex/`.
- [ ] Define one source-of-truth manifest/schema for meta-owned agent integrations.
- [x] Decide artifact boundaries: meta CLI plugin registry vs Claude plugin payload vs Codex plugin payload vs repo-local adapter.
- [x] Specify MCP ownership rules to prevent duplicate server registration.
- [x] Prototype validation commands for both assistant plugin payloads without changing active global config.
- [x] Document migration order from current hand-maintained plugin directories to generated/validated meta-owned outputs.

# Progress

- Added `docs/agent_plugin_control_plane.md` with boundaries, MCP ownership, and migration order.
- This task remains open for the next deeper implementation step: define the actual meta-owned manifest/schema and generator/validator.
