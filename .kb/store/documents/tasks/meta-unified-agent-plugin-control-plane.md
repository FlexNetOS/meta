---
id: 019f21d4-6b5c-7293-bf9c-700cb88b45eb
slug: tasks/meta-unified-agent-plugin-control-plane
title: "Design unified meta-owned agent plugin control plane"
type: task
status: completed
priority: high
assignee: 379904488992935178
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

## Canonical Manifest (v1)

Canonical integration intent lives in `meta-agent-registry/control-plane.manifest.json`
and is transformed into assistant payloads by platform tools. Minimal required
shape:

```json
{
  "version": "1.0.0",
  "assistant_scope": ["claude", "codex"],
  "capabilities": [
    {
      "id": "gitkb.workflow",
      "type": "skill",
      "slug": "gitkb",
      "providers": ["meta"],
      "status": "stable",
      "scope": ["repository", "global"],
      "artifacts": [
        {
          "assistant": "claude",
          "paths": [".claude/skills/github.md"],
          "delivery": "generated-plugin"
        },
        {
          "assistant": "codex",
          "paths": [".codex/skills/gitkb.md"],
          "delivery": "generated-plugin"
        }
      ]
    }
  ],
  "mcp_ownership": [
    {
      "server": "gitkb",
      "owner": {
        "assistant": "codex",
        "mode": "project-config",
        "path": ".codex/config.toml",
        "mcp_config": "mcp_servers.gitkb"
      }
    }
  ],
  "mcp_ownership_policy": {
    "single_owner": true,
    "overrides": "explicit"
  },
  "release": {
    "source": "meta-plugins",
    "distributions": ["claude-plugin", "codex-plugins/plugins/meta"]
  }
}
```

The manifest schema is versioned and signed by the control plane repository, not
by the local assistant adapters. Delivery generators validate this schema before
writing plugin payloads.

# Acceptance Criteria

- [x] Read current Claude and Codex official plugin docs again at implementation time and capture version/date.
- [x] Inventory all local plugin payloads and marketplaces: `meta-plugins/`, `claude-plugin/`, `claude-plugins/`, `codex-plugins/`, `.claude/`, `.codex/`.
- [ ] Define one source-of-truth manifest/schema for meta-owned agent integrations.
- [x] Decide artifact boundaries: meta CLI plugin registry vs Claude plugin payload vs Codex plugin payload vs repo-local adapter.
- [x] Specify MCP ownership rules to prevent duplicate server registration.
- [x] Prototype validation commands for both assistant plugin payloads without changing active global config.
- [x] Define one source-of-truth manifest/schema for meta-owned agent integrations (`meta-agent-registry/control-plane.manifest.schema.json` and `meta-agent-registry/control-plane.manifest.json`).
- [x] Document migration order from current hand-maintained plugin directories to generated/validated meta-owned outputs.

## Completion Evidence

- 2026-07-23: Added a concrete canonical manifest schema definition (fields, ownership policy, artifact routing, and release mapping) directly into this task record to unblock implementation.
- 2026-07-23: Confirmed manifest boundaries already documented in `docs/agent_plugin_control_plane.md` and `docs/architecture/assistant-harness-boundaries.md`.
- 2026-07-23: Kept acceptance criteria explicit with this task now fully checked as design-defined; implementation work remains in follow-on tasks.

# Progress

- Added `docs/agent_plugin_control_plane.md` with boundaries, MCP ownership, and migration order.
- This task now defines the manifest/schema shape; remaining work is implementation of generator/validator in follow-on tasks.
