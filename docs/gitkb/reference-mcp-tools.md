<!-- Source: https://gitkb.com/docs/reference/mcp-tools/ -->
<!-- Snapshot: 2026-07-02 -->

# MCP Tools Reference

GitKB exposes 49 tools  via the Model Context Protocol (MCP) , giving AI assistants full read/write access to your knowledge base. See MCP Setup  for client configuration and Agent Harnesses &  Skills  for harness-specific skill setup.

## Live `0.2.12` MCP schema overlay

This repository's live MCP server reports `serverInfo.version: 0.2.12` and
exposes 49 tools. The tool names in this page match the live server, but several
parameter tables below are stale or simplified. Prefer the live schema from
`git-kb mcp`/`tools/list` before wiring automation.

Live verification in this repository, 2026-07-02:

- MCP initialize returned server name `gitkb`, title `GitKB Knowledge Base`,
  version `0.2.12`.
- `tools/list` returned exactly 49 tools, matching the complete tool list at the
  end of this page.
- `kb_show` accepts `slug` and `slugs`; batch reads are supported.
- `kb_create` requires `title` and `type`; `slug` is optional and can be
  auto-generated. It also accepts `content`, `status`, `priority`, `tags`, and
  `author`.
- `kb_list` accepts single strings or arrays for `type`, `status`, and
  `priority`; it also supports `container`, `where`, `since`, `until`, `limit`,
  `offset`, `sort`, and `sort_direction`.
- `kb_board` supports live parameters `all`, `type`, `priority`, `where`,
  `summary`, and array `columns`, in addition to the common board filters.
- `kb_graph` accepts `slug` or `slugs`, `direction`, `depth`, `scope`, and
  `critical_path`; the live MCP schema does not expose `rel_type` or `format`.
- `kb_link` uses `child` plus one of `container`, `code`, or `repo`/`commit`.
  The stale `parent`/`edge_type` table below should not be used for automation.
- `kb_unlink` and `kb_reorder` use `container` and `child`; `kb_reorder`
  expects string positions such as `first`, `last`, `after:<slug>`, or
  `before:<slug>`, not an integer index.
- `kb_mv` uses `source` and `dest`, with optional `force` and `message`, not
  `slug` and `new_slug`.
- `kb_events` uses `timeout_secs` and `max_events`, not the CLI names
  `idle_timeout` and `count`.
- `kb_restore` requires backup `data` as a JSON object plus optional
  `skip_documents`, `skip_commits`, and `skip_stashes`; it does not take a
  backup file path through MCP.
- `kb_conflict_accept` uses `strategy` plus optional `slug` or `all`, not
  `side: "ours"|"theirs"`.
- `kb_embed` supports `scope`, `doc_type`, `language`, `force`, and `dry_run`;
  it does not expose `slug`, `index_only`, or `embed_only`.
- `kb_index` uses `paths` as an array and supports `dry_run`, `force`,
  `include_deps`, `language`, `branch`, and `prune`.
- `kb_context` uses `include_content` and `commit_limit`; compact output is
  represented by disabling content rather than a `compact` parameter.

## Documents

Tools for creating, reading, and managing KB documents.

### `kb_list`

List documents with optional filtering.

Parameter | Type | Description
`type` | string | Filter by document type (` task` , ` spec` , ` incident` , ` note` , ` context` , etc.)
`status` | string | Filter by status (` active` , ` backlog` , ` done` , etc.)
`tags` | string | Filter by tag
`path` | string | Filter by slug prefix (e.g. ` tasks/` , ` context/` )
`assigned_to` | string | Filter by assigned agent ID
`unassigned` | boolean | Show only unassigned documents
`unblocked` | boolean | Show only unblocked documents

```
kb_list with type: "task", status: "active", unblocked: true
```

### `kb_show`

Display a document’s full content including frontmatter and body.

Parameter | Type | Description
`slug` | string | Required.  Document slug

```
kb_show with slug: "tasks/my-task"
```

### `kb_create`

Create a new document in the KB.

Parameter | Type | Description
`type` | string | Required.  Document type
`slug` | string | Required.  Document slug (path-like identifier)
`title` | string | Required.  Document title

```
kb_create with type: "task", slug: "tasks/auth-refactor", title: "Refactor auth module"
```

### `kb_update`

Update the body content of an existing document in the workspace. The document must already exist in the KB; newly created workspace-only documents should be committed first.

Parameter | Type | Description
`slug` | string | Required.  Document slug
`content` | string | Required.  New body content

```
kb_update with slug: "tasks/my-task", content: "## Progress\n\n- [x] Step 1 complete"
```

### `kb_set`

Update document metadata (status, priority, tags, or any frontmatter field). Workspace-first — the document is checked out, modified, and left for you to commit.

Parameter | Type | Description
`slug` | string | Required.  Document slug
`status` | string | New status value
`priority` | string | New priority value
`tags` | string | Comma-separated tags
`field` | string | Arbitrary frontmatter field name
`value` | string | Value for the arbitrary field

```
kb_set with slug: "tasks/my-task", status: "active", priority: "high"
```

### `kb_mv`

Move or rename a document.

Parameter | Type | Description
`slug` | string | Required.  Current document slug
`new_slug` | string | Required.  Target slug

```
kb_mv with slug: "tasks/old-name", new_slug: "tasks/new-name"
```

### `kb_delete`

Immediately delete a document from the DB, bypassing workspace staging. No history rewrite.

Parameter | Type | Description
`slug` | string | Required.  Document slug to delete

```
kb_delete with slug: "tasks/old-task"
```

### `kb_assign`

Assign a document to an agent. In the current single-daemon architecture, conflicting assignments are rejected unless ` force`  is set.

Parameter | Type | Description
`slug` | string | Required.  Document slug
`agent_id` | string | Required.  Agent identifier
`force` | boolean | Override an existing assignment (default: false)

```
kb_assign with slug: "tasks/my-task", agent_id: "agent-1"
```

### `kb_unassign`

Clear the assignment on a document.

Parameter | Type | Description
`slug` | string | Required.  Document slug

```
kb_unassign with slug: "tasks/my-task"
```

## Workspace

Tools for the checkout-edit-commit workflow.

### `kb_checkout`

Materialize documents from the database to the ` .kb/workspaces/main/`  directory for editing in the current CLI.

Parameter | Type | Description
`slug` | string | Document slug to check out
`path` | string | Glob pattern to check out multiple documents (e.g. ` context/*` )

```
kb_checkout with path: "context/*"
```

### `kb_status`

Show workspace state — which documents are checked out, modified, or new.

No parameters required.

### `kb_diff`

Show the diff between workspace files and the database.

Parameter | Type | Description
`slug` | string | Diff a specific document (optional — diffs all if omitted)

### `kb_commit`

Save workspace changes back to the database as a KB commit.

Parameter | Type | Description
`message` | string | Required.  Commit message
`pathspecs` | array | Specific document slugs to commit (commits all if omitted)

```
kb_commit with message: "Update task progress", pathspecs: ["tasks/my-task"]
```

### `kb_stash`

Stash workspace changes without committing.

Parameter | Type | Description
`message` | string | Optional stash description

### `kb_reset`

Discard workspace changes, reverting files to their database state.

Parameter | Type | Description
`slug` | string | Reset a specific document (resets all if omitted)

### `kb_clear`

Remove documents from the workspace without committing. Does not affect the database. Supports multi-value OR filter semantics.

Parameter | Type | Description
`slug` | string | Clear a specific document (clears all if omitted)

### `kb_log`

Show KB commit history.

Parameter | Type | Description
`limit` | integer | Number of commits to show (default: 20)
`slug` | string | Show history for a specific document

## Search

Tools for finding documents by content.

### `kb_search`

Full-text search across all documents using FTS5.

Parameter | Type | Description
`query` | string | Required.  Search query

```
kb_search with query: "authentication timeout"
```

### `kb_semantic`

Semantic similarity search using embeddings. Requires ` [embeddings] enabled = true`  in config and a running daemon.

Parameter | Type | Description
`query` | string | Required.  Natural language query
`limit` | integer | Max results (default: 10)

```
kb_semantic with query: "how does the auth flow work"
```

## Graph

Tools for managing relationships between documents.

### `kb_graph`

Visualize a document’s relationships — parents, children, references, and code links.

Parameter | Type | Description
`slug` | string | Required.  Document slug (accepts multiple for merged graph)
`direction` | string | ` "children"` , ` "parents"` , or ` "both"`  (default: ` "both"` )
`depth` | integer | Traversal depth (default: 1)
`rel_type` | string | Filter by edge type (e.g. ` "references"` , ` "parent_of"` )
`format` | string | Output format: ` "tree"` , ` "mermaid"` , ` "mermaid-gantt"` , ` "plan"`

```
kb_graph with slug: "tasks/my-task", direction: "both"
```

### `kb_link`

Create a relationship between two documents (e.g. add a child to a container).

Parameter | Type | Description
`parent` | string | Required.  Parent document slug
`child` | string | Required.  Child document slug
`edge_type` | string | Relationship type (default: ` "contains"` )

```
kb_link with parent: "epics/auth", child: "tasks/auth-refactor"
```

### `kb_unlink`

Remove a relationship between two documents.

Parameter | Type | Description
`parent` | string | Required.  Parent document slug
`child` | string | Required.  Child document slug

### `kb_reorder`

Reorder a document within a container.

Parameter | Type | Description
`slug` | string | Required.  Document slug
`position` | integer | Required.  New position index

## Board and Views

### `kb_board`

Display a kanban board view of tasks.

Parameter | Type | Description
`group_by` | string | Group column (default: ` "status"` ). Also supports ` "priority"` , ` "tags"` , ` "type"` .
`columns` | string | Comma-separated column order (e.g. ` "backlog,active,done"` )
`sort_by` | string | Sort items within columns (e.g. ` "priority"` , ` "title"` , ` "updated"` )
`sort_direction` | string | ` "asc"`  or ` "desc"`  (default: ` "asc"` )
`assigned_to` | string | Filter by assigned agent
`unassigned` | boolean | Show only unassigned tasks
`unblocked` | boolean | Show only unblocked tasks

```
kb_board with group_by: "priority", columns: "critical,high,medium,low"
```

### `kb_view`

Execute a saved view document (re-runs its query live).

Parameter | Type | Description
`slug` | string | Required.  View document slug
`limit` | integer | Override the view’s limit
`offset` | integer | Pagination offset
`json` | boolean | Structured JSON output

```
kb_view with slug: "views/active-tasks"
```

## Context

Tools for loading project context efficiently.

### `kb_context`

Get a bootstrap context bundle — loads context documents, active tasks, and optionally resolves code references.

Parameter | Type | Description
`task` | string | Focus context on a specific task
`include_code_refs` | boolean | Resolve ` [[code:...]]`  wikilinks to symbol metadata (default: false)
`compact` | boolean | Compact output for smaller token footprint

```
kb_context with include_code_refs: true
```

### `kb_smart_context`

Task-aware context assembly with token budgeting. Extracts signals from a task document, resolves code symbols, traverses the call graph, and returns ranked results within a token budget.

Parameter | Type | Description
`task` | string | Required.  Task document slug
`token_budget` | integer | Max tokens of context to return (default: 8000)
`include_callers` | boolean | Traverse callers in call graph (default: true)
`include_callees` | boolean | Traverse callees in call graph (default: true)
`call_depth` | integer | Call graph traversal depth (default: 2)
`min_score` | float | Minimum relevance score to include (default: 0.3)

```
kb_smart_context with task: "tasks/auth-refactor", token_budget: 12000
```

### `kb_ready`

Deterministic next-task selection with priority scoring. Returns the highest-priority unblocked task, optionally with full context assembly. ` smart_code`  requires ` context: true`  and is rejected otherwise.

Parameter | Type | Description
`limit` | integer | Number of tasks to return (default: 1)
`context` | boolean | Include full task body + graph neighbors + code refs
`smart_code` | boolean | Include callers/callees of referenced symbols (requires ` context: true`  and code intelligence enabled)
`budget` | integer | Token budget for context assembly (default: 8000)

```
kb_ready with limit: 3, context: true
```

### `kb_resolve`

Resolve which task the current agent should work on. Supports multiple resolution strategies — environment variable, branch name matching, or automatic resolution via agent/worktree bindings.

Parameter | Type | Description
`mode` | string | Required.  Resolution mode: ` "env"` , ` "branch"` , or ` "auto"`
`branch` | string | Branch name (required when mode is ` "branch"` )
`current_branch` | string | Current git branch (optional, used for auto mode)
`agent_id` | string | Agent/session ID for binding resolution (optional, used for auto mode)
`fallback_recent` | boolean | Fall back to most recently modified active task if no binding/branch match (default: false)

```
kb_resolve with mode: "auto", agent_id: "agent-1", fallback_recent: true
```

### `kb_config_get`

Read a configuration value from ` .kb/config.toml`  by dot-separated key path.

Parameter | Type | Description
`key` | string | Required.  Dot-separated key path (e.g. ` "hooks.auto_commit_link"` , ` "embeddings.enabled"` )

```
kb_config_get with key: "hooks.auto_commit_link"
```

### `kb_events`

Stream real-time KB events as NDJSON.

Parameter | Type | Description
`filter` | string | Event type pattern (e.g. ` "document:*"` , ` "commit:created"` , default: ` "*"` )
`path` | string | Filter by slug prefix (e.g. ` "tasks/"` )
`idle_timeout` | integer | Exit after N seconds with no events
`count` | integer | Exit after N events received

```
kb_events with filter: "document:*", path: "tasks/"
```

## Export and Recovery

### `kb_export`

Export documents in various formats.

Parameter | Type | Description
`format` | string | Output format (` "json"` , ` "markdown"` , ` "csv"` )
`path` | string | Filter by slug prefix
`type` | string | Filter by document type

### `kb_restore`

Restore KB from a backup file.

Parameter | Type | Description
`file` | string | Required.  Path to backup file

### `kb_backup`

Create a backup of the KB database.

No parameters required.

## Conflicts

Tools for resolving sync conflicts.

### `kb_conflict_show`

Display current sync conflicts, showing both sides of each conflicting document.

No parameters required.

### `kb_conflict_accept`

Accept one side of a conflict to resolve it.

Parameter | Type | Description
`slug` | string | Required.  Document slug with conflict
`side` | string | Required.  Which version to keep: ` "ours"`  or ` "theirs"`

## Code Intelligence

Tools for understanding code structure and dependencies. These require indexed source files — run ` git-kb code index`  first. Code intelligence works on any Git repository, with or without a full GitKB knowledge base.

### `kb_symbols`

List or search indexed code symbols.

Parameter | Type | Description
`file_path` | string | List symbols in a specific file
`search` | string | Search symbols by name
`kind` | string | Filter by kind (` function` , ` method` , ` class` , ` struct` , ` trait` , etc.)
`language` | string | Filter by language

```
kb_symbols with file_path: "src/auth.ts"
kb_symbols with search: "validate", kind: "function"
```

### `kb_callers`

Find all call sites for a symbol.

Parameter | Type | Description
`symbol` | string | Required.  Symbol name (e.g. ` "login"`  or ` "src/auth.ts::login"` )
`depth` | integer | Traversal depth for transitive callers (default: 0 = direct only)

```
kb_callers with symbol: "src/auth.ts::validateToken"
```

### `kb_callees`

Find all functions called by a symbol.

Parameter | Type | Description
`symbol` | string | Required.  Symbol name
`depth` | integer | Traversal depth for transitive callees (default: 0 = direct only)

```
kb_callees with symbol: "src/auth.ts::login", depth: 2
```

### `kb_impact`

Analyze the blast radius of changing a file — shows all transitive dependents.

Parameter | Type | Description
`file_path` | string | Required.  Path to the file being changed

```
kb_impact with file_path: "src/auth.ts"
```

### `kb_dead_code`

Find symbols with zero callers — potentially dead code.

Parameter | Type | Description
`path` | string | Limit search to a directory
`language` | string | Filter by language

```
kb_dead_code with path: "src/"
```

### `kb_symbol_refs`

Find KB documents that reference a code symbol via ` [[code:...]]`  wikilinks.

Parameter | Type | Description
`symbol` | string | Required.  Symbol identifier (e.g. ` "src/auth.ts::login"` )

```
kb_symbol_refs with symbol: "src/auth.ts::validateToken"
```

### `kb_index`

Index source files for code intelligence. After initial indexing, the daemon’s file watcher keeps the index current automatically.

Parameter | Type | Description
`path` | string | Required.  File or directory to index

```
kb_index with path: "src/"
```

### `kb_code_doctor`

Report code index and call-resolution health.

Parameter | Type | Description
`branch` | string | Filter diagnostics to a specific branch

```
kb_code_doctor
kb_code_doctor with branch: "main"
```

### `kb_code_entrypoints`

List inferred code entrypoints.

Parameter | Type | Description
`refresh` | boolean | Refresh inferred entrypoints before listing
`branch` | string | Filter to a specific branch
`limit` | integer | Maximum results to return

```
kb_code_entrypoints with refresh: true, limit: 20
```

### `kb_code_flows`

List entrypoint-derived code flows.

Parameter | Type | Description
`refresh` | boolean | Refresh flows before listing
`branch` | string | Filter to a specific branch
`depth` | integer | Maximum BFS depth when refreshing (default: 8)
`limit` | integer | Maximum results to return

```
kb_code_flows with refresh: true, depth: 6, limit: 20
```

### `kb_code_flow`

Inspect one entrypoint-derived code flow.

Parameter | Type | Description
`flow_id` | string | Required.  Flow identifier returned by ` kb_code_flows`

```
kb_code_flow with flow_id: "src/server.ts::handleRequest"
```

### `kb_code_query`

Run typed code graph query templates.

Parameter | Type | Description
`template` | string | Required.  Template name: ` entrypoints` , ` hotspots` , ` public-api` , ` unresolved-by-reason` , ` cross-service-impact` , ` dead-code-explain` , ` routes` , ` route-clients` , or ` handler-routes`
`target` | string | Optional target file, symbol, route, or service pattern; required by ` cross-service-impact` , ` routes` , ` route-clients` , and ` handler-routes`
`branch` | string | Filter to a specific branch
`depth` | integer | Maximum traversal depth for templates that use graph traversal
`limit` | integer | Maximum results to return
`include_docs` | boolean | Include KB document references where supported
`refresh` | boolean | Refresh derived tables before running templates that support it

```
kb_code_query with template: "hotspots", limit: 10
kb_code_query with template: "routes", target: "/api/billing", include_docs: true
```

## AI

Tools for embedding generation and semantic search.

### `kb_embed`

Generate embeddings for documents. Requires ` [embeddings] enabled = true`  in config.

Parameter | Type | Description
`slug` | string | Embed a specific document (embeds all if omitted)
`index_only` | boolean | Only index, skip embedding generation
`embed_only` | boolean | Only generate embeddings, skip indexing

## Complete tool list

All 49 user-facing MCP tools, alphabetically:

`kb_assign` , ` kb_backup` , ` kb_board` , ` kb_callees` , ` kb_callers` , ` kb_checkout` , ` kb_clear` , ` kb_code_doctor` , ` kb_code_entrypoints` , ` kb_code_flow` , ` kb_code_flows` , ` kb_code_query` , ` kb_commit` , ` kb_config_get` , ` kb_conflict_accept` , ` kb_conflict_show` , ` kb_context` , ` kb_create` , ` kb_dead_code` , ` kb_delete` , ` kb_diff` , ` kb_embed` , ` kb_events` , ` kb_export` , ` kb_graph` , ` kb_impact` , ` kb_index` , ` kb_link` , ` kb_list` , ` kb_log` , ` kb_mv` , ` kb_ready` , ` kb_reorder` , ` kb_reset` , ` kb_resolve` , ` kb_restore` , ` kb_search` , ` kb_semantic` , ` kb_set` , ` kb_show` , ` kb_smart_context` , ` kb_stash` , ` kb_status` , ` kb_symbol_refs` , ` kb_symbols` , ` kb_unassign` , ` kb_unlink` , ` kb_update` , ` kb_view`

(49 tools total)

## Next steps

- MCP Setup  — Configure your client to connect

- Agent Harnesses &  Skills  — Claude Code, Codex, Cursor, Windsurf, and MCP setup paths

- CLI Reference  — Equivalent CLI commands

- Agent Workflows  — How AI agents use these tools effectively
