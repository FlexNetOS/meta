---
id: 019f21d2-5962-7563-94de-81b81aa66e06
slug: tasks/meta-codex-gitkb-mcp-ownership
title: "Resolve Codex GitKB MCP ownership"
type: task
status: completed
priority: high
---

# Summary
Resolve the possible duplicate GitKB MCP registration for Codex by choosing one ownership surface for the `gitkb` server.

# Evidence
- `~/.codex/config.toml` has `[mcp_servers.gitkb]` pointing to `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-meta`.
- `codex-plugins/plugins/gitkb/.mcp.json` also declares `mcpServers.gitkb` as `git-kb mcp`.
- Installed plugin cache `~/.codex/plugins/cache/gitkb/gitkb/0.1.0+codex.20260702020541/.mcp.json` has the same plugin MCP declaration.
- Extracted docs say Codex MCP is configured with `codex mcp add gitkb -- git-kb mcp` or equivalent `$CODEX_HOME/config.toml`; `git-kb init codex` owns repo-local skills/instructions, not MCP.

# Acceptance Criteria
- [x] Verify how current Codex loads MCP from global config and installed plugins.
- [x] Decide whether meta owns GitKB MCP through global Codex config, plugin MCP, or a documented meta wrapper.
- [x] Remove or disable the losing duplicate declaration without breaking `gitkb-mcp-meta`.
- [x] Prove only one active `gitkb` MCP route is loaded for `/home/flexnetos/FlexNetOS/src/meta`.
- [x] Document the chosen ownership model in the repo-local docs or KB.

# Completion Evidence

- Updated `codex-plugins/plugins/gitkb/.codex-plugin/plugin.json` to remove plugin-owned `mcpServers`.
- Updated `codex-plugins/plugins/gitkb/.mcp.json` to `{ "mcpServers": {} }`.
- Added MCP ownership notes to `codex-plugins/plugins/gitkb/README.md`, `codex-plugins/README.md`, and `docs/agent_plugin_control_plane.md`.
- Refreshed installed Codex plugin cache: `codex plugin add gitkb@gitkb --json` installed version `0.1.1` to `~/.codex/plugins/cache/gitkb/gitkb/0.1.1`.
- `codex mcp list` shows one active `gitkb` route via `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-meta` plus separate `gitkb-yazelix`; no plugin-owned duplicate `gitkb` route appears.
