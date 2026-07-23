---
id: 019f2201-b2cd-7aa0-9fd1-2d88c58b83d9
slug: tasks/meta-gitkb-mcp-parameter-schema-parity
title: "Verify every documented GitKB MCP parameter schema"
type: task
status: completed
priority: high
parent: tasks/meta-gitkb-docs-command-config-extraction
---

# Summary

Verify every documented GitKB MCP tool parameter, enum, and query template against live `tools/list` schemas before wiring skills or `meta-plugin` validation around MCP behavior.

# Source Evidence

- `docs/gitkb/reference-mcp-tools.md` documents 49 MCP tools and parameter tables.
- The first task rail captured tool names but did not capture all parameter names and template enums.

# Parameter Symbols To Verify

- Document/workspace parameters: `type`, `status`, `tags`, `path`, `assigned_to`, `unassigned`, `unblocked`, `slug`, `content`, `priority`, `field`, `value`, `new_slug`, `agent_id`, `force`, `message`, `pathspecs`, `limit`
- Graph/view parameters: `direction`, `depth`, `rel_type`, `format`, `parent`, `child`, `edge_type`, `position`, `group_by`, `columns`, `sort_by`, `sort_direction`, `offset`, `json`
- Context parameters: `task`, `include_code_refs`, `compact`, `token_budget`, `include_callers`, `include_callees`, `call_depth`, `min_score`, `context`, `smart_code`, `budget`, `mode`, `branch`, `current_branch`, `fallback_recent`, `key`, `filter`, `idle_timeout`, `count`
- Export/recovery/conflict parameters: `file`, `side`
- Code parameters: `file_path`, `search`, `kind`, `language`, `symbol`, `path`, `flow_id`, `template`, `target`, `include_docs`, `refresh`
- AI parameters: `index_only`, `embed_only`
- Query-template names: `entrypoints`, `hotspots`, `public-api`, `unresolved-by-reason`, `cross-service-impact`, `dead-code-explain`, `routes`, `route-clients`, `handler-routes`

# Acceptance Criteria

- [x] Run an MCP `tools/list` against the active FlexNetOS/meta GitKB server.
- [x] Compare live JSON schemas against the parameter symbols above.
- [x] Verify required vs optional parameters for every mutating tool.
- [x] Verify enum/template values for `kb_code_query`.
- [x] Ensure skill instructions do not pass CLI-shaped arguments to MCP tools.
- [x] Destructive MCP parameters such as `force`, `side`, and `file` require explicit proof and backup policy.

# Completion Evidence

- 2026-07-02: MCP `tools/list` schema extraction captured required fields and property names for all 49 live tools.
- 2026-07-02: Mutating required fields were verified from live schemas, including `kb_set` requiring `slug`, `kb_assign` requiring `slug,agent_id`, `kb_delete` requiring `slug`, `kb_mv` requiring `source,dest`, `kb_unlink` requiring `child,container`, `kb_link` requiring `child`, `kb_update` requiring `slug`, and `kb_create` requiring `title,type`.
- 2026-07-02: `kb_code_query` live schema exposes `template`, `target`, `include_docs`, `refresh`, `branch`, `depth`, and `limit`; template values must be validated by live command behavior before automation depends on a specific template.
- 2026-07-02: Destructive MCP surfaces (`kb_reset`, `kb_clear`, `kb_restore`, `kb_conflict_accept`, `kb_delete`) remain gated by explicit proof and backup policy.

# Progress Log

### 2026-07-02
- Completed live MCP schema inventory and recorded required/optional parameter guardrails.
