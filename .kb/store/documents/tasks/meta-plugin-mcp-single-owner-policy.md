---
id: 019f21fc-56fa-7bf0-847d-0da3175b312e
slug: tasks/meta-plugin-mcp-single-owner-policy
title: "Enforce single-owner MCP registration policy"
type: task
status: completed
priority: high
parent: tasks/meta-gitkb-docs-command-config-extraction
---

# Summary

Define and enforce one MCP owner per assistant/server name so `gitkb` is not registered by multiple plugins, local dotfiles, and global configs at the same time.

# Source Evidence

- `docs/gitkb/getting-started-mcp-setup.md` documents `git-kb mcp` as the stdio MCP server.
- The same doc shows Claude/Cursor/Cline/Windsurf JSON `mcpServers.gitkb` config.
- The same doc shows Codex setup with `codex mcp add gitkb -- git-kb mcp` and manual `[mcp_servers.gitkb]`.
- `docs/gitkb/index.md` also shows a generic `mcpServers.gitkb` JSON block.
- The previous implementation already found duplicate Codex plugin MCP ownership caused confusion.
- `incidents/codex-gitkb-mcp-startup-singleton-conflict` records the correct wrapper resolution: root MCP frontdoors use `git-kb mcp --force`, and direct initialize/tools-list probes through the wrappers return the GitKB MCP tool list.

# Commands And Configs Covered

- `git-kb mcp`
- `codex mcp add gitkb -- git-kb mcp`
- `.mcp.json`
- `.cursor/mcp.json`
- Cline extension MCP settings
- `~/.codeium/windsurf/mcp_config.json`
- `$CODEX_HOME/config.toml`
- `~/.codex/config.toml`
- `[mcp_servers.gitkb]`
- JSON `mcpServers.gitkb`
- Cline MCP settings
- Cursor Agent mode MCP visibility note

# Acceptance Criteria

- [x] Define the single-owner rule in `meta-plugin`: one assistant/server name has exactly one configured owner.
- [x] For FlexNetOS meta, document whether `gitkb` is owned by global Codex config, project Codex config, Claude config, or generated meta wrapper.
- [x] Add validation that detects duplicate `gitkb` MCP registrations across plugin cache, `.codex`, `.claude`, `.mcp.json`, and global Codex config.
- [x] Validation prints the owning file and conflicting file before suggesting changes.
- [x] Generated plugin package MCP files remain empty when ownership belongs to the control plane.
- [x] Verification includes `codex mcp list` and a local MCP tools/list smoke test where possible.
- [x] MCP tool schema validation is delegated to [[tasks/meta-gitkb-mcp-parameter-schema-parity]].

# Policy

- One assistant/server name has exactly one owner. For FlexNetOS meta, Codex `gitkb` MCP ownership is global Codex config through `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-meta`.
- Plugin payloads must not register a second `gitkb` MCP server when the control plane owns that server name.
- Agents should prove MCP through the configured owner wrapper (`/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-meta`) rather than direct `git-kb mcp`, because direct startup competes with the singleton and can report an existing owner.
- `meta plugin doctor-mcp --server gitkb` scans project MCP files, assistant adapter configs, repo plugin payloads, global Codex config, and Codex plugin cache `.mcp.json` files. It prints the owning file and every conflicting file before suggesting removal of conflicting registrations.

# Progress Evidence

- 2026-07-02: `codex mcp list` showed `gitkb` mapped to `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-meta` and `gitkb-yazelix` mapped to `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-yazelix`.
- 2026-07-02: `/home/flexnetos/.codex/config.toml` contains `[mcp_servers.gitkb]` and `[mcp_servers.gitkb-yazelix]`.
- 2026-07-02: `codex-plugins/plugins/gitkb/.mcp.json` has an empty `mcpServers` object, and `codex-plugins/plugins/gitkb/.codex-plugin/plugin.json` does not register MCP servers.
- 2026-07-02: Initialized `git-kb mcp` tools/list smoke test returned 49 tools.
- 2026-07-02 rerun: `codex mcp list` still shows exactly two GitKB servers: `gitkb` owned by `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-meta` and `gitkb-yazelix` owned by `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-yazelix`.
- 2026-07-02 follow-up: raw `tools/list` and initialized `tools/list` probes through bare `git-kb mcp` both returned `error: MCP server already running (PID 3592346)`. `ps` still shows `/home/flexnetos/FlexNetOS/usr/bin/git-kb mcp`, owned by `flexnetos`. `codex mcp list` still shows global Codex ownership through `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-meta`; no `--force` kill was used.
- 2026-07-02 correction, superseded by the 2026-07-20 owner policy: PID `3592346` had exited; direct `git-kb mcp` then reported a newer singleton owned by a now-retired per-user Codex shadow and launched through a now-retired FlexNetOS compatibility tree. That stale singleton was stopped and GitKB initialized as `server=gitkb version=0.2.12` with `tools=49`. The exact obsolete paths were removed from this active document; current ownership is exclusively `/home/flexnetos/.nix-profile`.
- 2026-07-02 implementation: `meta_cli` commit `b7e7416 feat: validate MCP single owner` added `meta plugin doctor-mcp --server gitkb`, JSON/TOML parsing for `mcpServers.gitkb` and `[mcp_servers.gitkb]`, plugin-cache scanning, owner/conflict reporting, and focused tests.
- 2026-07-02 root docs/lockfile commit: `3d33135 docs: record MCP ownership validator` documented the validator in `docs/agent_plugin_control_plane.md`, `docs/architecture/automation-boundaries.md`, and `docs/gitkb/getting-started-mcp-setup.md`.
- 2026-07-02 verification: `PATH=/nix/store/amnp0j1awapnf8vqs3bwlyvffpkjl5cl-rust-mixed/bin:$PATH cargo test -p meta mcp_ownership --locked -- --test-threads=1` passed 2 focused tests.
- 2026-07-02 live validation: `PATH=/nix/store/amnp0j1awapnf8vqs3bwlyvffpkjl5cl-rust-mixed/bin:$PATH cargo run -p meta --locked -- plugin doctor-mcp --server gitkb --json` scanned 12 config files, found owner `/home/flexnetos/.codex/config.toml`, command `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-meta`, and reported no conflicts.

# Completion Evidence

- `meta_cli` source commit: `b7e7416 feat: validate MCP single owner`.
- Meta root docs/lockfile commit: `3d33135 docs: record MCP ownership validator`.
- Validation command implemented: `meta plugin doctor-mcp --server gitkb`.
- Focused tests passed with locked dependencies.
- Live JSON validator output proved exactly one current `gitkb` registration and no conflicts.

# Progress Log

### 2026-07-02
- Reran `codex mcp list`; current owner state still matches policy. Duplicate-registration scanner/owner-conflict reporting implementation remains open.
- Confirmed current single-owner state and plugin-empty MCP policy; left scanner/validation implementation criteria open.
- During [[tasks/meta-foundation-live-proof-gitkb-parity]], a fresh local `git-kb mcp` stdio proof could not run because `git-kb mcp` returned `MCP server already running (PID 3592346)`. `ps` showed `/home/flexnetos/FlexNetOS/usr/bin/git-kb mcp`, started Thu Jul 2 09:53:23 2026, owned by `flexnetos`; `.kb/.cache/mcp.pid` exists; `git-kb daemon status` reported the daemon is not running while repo discovery is OK. This reinforces the need for scanner/owner-conflict reporting before any agent uses `git-kb mcp --force`.
- Reran the raw and initialized MCP probes for [[tasks/meta-foundation-live-proof-gitkb-parity]]; singleton denial remains the current behavior. This is evidence for the policy task rather than a reason to kill another session's MCP owner.
- Corrected proof path: direct `git-kb mcp` is not the owner frontdoor for Codex. The configured owner wrapper `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-meta` is the right proof surface and returned `server=gitkb version=0.2.12` plus `tools=49`.
- Implemented and verified `meta plugin doctor-mcp --server gitkb`; all acceptance criteria are now checked.
