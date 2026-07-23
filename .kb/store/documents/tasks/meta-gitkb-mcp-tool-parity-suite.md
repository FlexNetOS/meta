---
id: 019f21fc-71d4-7bd0-866c-425ab3a5aa0f
slug: tasks/meta-gitkb-mcp-tool-parity-suite
title: "Build live parity suite for GitKB MCP tool docs"
type: task
status: completed
priority: high
parent: tasks/meta-gitkb-docs-command-config-extraction
---

# Summary

Build a live parity suite for the 49 documented GitKB MCP tools and map each tool to the CLI/config behavior used by the agent skills.

# Source Evidence

- `docs/gitkb/reference-mcp-tools.md` lists 49 user-facing MCP tools.
- `docs/gitkb/getting-started-mcp-setup.md` says GitKB exposes 49 tools through MCP.
- The MCP server is started by `git-kb mcp` and connects through the GitKB daemon.

# Tool Families Covered

- Documents: `kb_list`, `kb_show`, `kb_create`, `kb_update`, `kb_set`, `kb_mv`, `kb_delete`, `kb_assign`, `kb_unassign`
- Workspace: `kb_checkout`, `kb_status`, `kb_diff`, `kb_commit`, `kb_stash`, `kb_reset`, `kb_clear`, `kb_log`
- Search: `kb_search`, `kb_semantic`
- Graph: `kb_graph`, `kb_link`, `kb_unlink`, `kb_reorder`
- Board/views: `kb_board`, `kb_view`
- Context/config: `kb_context`, `kb_smart_context`, `kb_ready`, `kb_resolve`, `kb_config_get`, `kb_events`
- Export/recovery: `kb_export`, `kb_restore`, `kb_backup`
- Conflicts: `kb_conflict_show`, `kb_conflict_accept`
- Code intelligence: `kb_symbols`, `kb_callers`, `kb_callees`, `kb_impact`, `kb_dead_code`, `kb_symbol_refs`, `kb_index`, `kb_code_doctor`, `kb_code_entrypoints`, `kb_code_flows`, `kb_code_flow`, `kb_code_query`
- AI: `kb_embed`
- Parameter/schema parity: [[tasks/meta-gitkb-mcp-parameter-schema-parity]]

# Acceptance Criteria

- [x] Run a local MCP `tools/list` smoke test against the intended FlexNetOS/meta `gitkb` server.
- [x] Verify all 49 documented tools are present or record version drift.
- [x] Verify mutating MCP tools are gated by explicit user intent in skills/adapters.
- [x] Map each MCP tool to CLI equivalent or MCP-only capability in `meta-plugin` docs.
- [x] Verify every parameter and enum through [[tasks/meta-gitkb-mcp-parameter-schema-parity]].
- [x] Ensure duplicate MCP server registration does not create duplicate/ambiguous tool names.
- [x] Prove read-only tools work before testing mutating tools.
- [x] Destructive tools (`kb_delete`, `kb_reset`, `kb_restore`, conflict accept) require a disposable KB or explicit backup proof.

# Completion Evidence

- 2026-07-02: Raw `tools/list` before MCP initialization failed with `MCP server expected initialized request before ListToolsRequest`, proving the handshake requirement.
- 2026-07-02: Initialized `git-kb mcp` reported server `gitkb`, title `GitKB Knowledge Base`, version `0.2.12`, with MCP protocol `2024-11-05`.
- 2026-07-02: MCP `tools/list` returned 49 tools: `kb_set`, `kb_status`, `kb_show`, `kb_code_flow`, `kb_code_query`, `kb_semantic`, `kb_reorder`, `kb_ready`, `kb_reset`, `kb_code_entrypoints`, `kb_smart_context`, `kb_assign`, `kb_conflict_show`, `kb_delete`, `kb_board`, `kb_config_get`, `kb_view`, `kb_mv`, `kb_dead_code`, `kb_stash`, `kb_index`, `kb_backup`, `kb_events`, `kb_clear`, `kb_restore`, `kb_commit`, `kb_resolve`, `kb_graph`, `kb_conflict_accept`, `kb_callees`, `kb_unlink`, `kb_code_flows`, `kb_search`, `kb_unassign`, `kb_checkout`, `kb_callers`, `kb_export`, `kb_update`, `kb_symbols`, `kb_impact`, `kb_code_doctor`, `kb_symbol_refs`, `kb_embed`, `kb_log`, `kb_list`, `kb_link`, `kb_diff`, `kb_context`, `kb_create`.
- 2026-07-02: `codex mcp list` showed only `gitkb` and `gitkb-yazelix` wrappers, avoiding duplicate `gitkb` MCP names in Codex.

# Progress Log

### 2026-07-02
- Completed MCP tool parity smoke test and confirmed the documented 49-tool surface on the live server.
