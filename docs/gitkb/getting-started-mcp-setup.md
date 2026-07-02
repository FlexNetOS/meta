<!-- Source: https://gitkb.com/docs/getting-started/mcp-setup/ -->
<!-- Snapshot: 2026-07-02 -->

# MCP Setup

Local verification: this extracted page was executed against the FlexNetOS
`meta` checkout. The active Codex MCP owner for this repo is the global Codex
config entry `gitkb` pointing to
`/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-meta`; do not add a duplicate
repo-local `gitkb` registration while [[tasks/meta-plugin-mcp-single-owner-policy]]
is active.

GitKB exposes 49 tools  via the Model Context Protocol (MCP) , giving AI assistants full read/write access to your knowledge base.

## How it works

The ` git-kb mcp`  command starts a stdio-based MCP server that connects to the GitKB daemon. The daemon auto-starts when needed — no manual setup required.

## Client configuration

### Claude Code

Add to ` .mcp.json`  in your project root:

```
{
  "mcpServers": {
    "gitkb": {
      "command": "git-kb",
      "args": ["mcp"]
    }
  }
}
```

### Cursor

Add to ` .cursor/mcp.json`  in your project root:

```
{
  "mcpServers": {
    "gitkb": {
      "command": "git-kb",
      "args": ["mcp"]
    }
  }
}
```

>

Note:  MCP tools only appear in Cursor’s Agent mode, not in normal chat. If you use the Cursor integration scaffold, GitKB also installs repo rules and skill forwarders under ` .cursor/` .

### Codex

Codex can use the same MCP server through its local MCP configuration. The recommended setup is:

```
codex mcp add gitkb -- git-kb mcp
```

For this checkout, `codex mcp list` already reports `gitkb` through the
FlexNetOS wrapper path above, and the wrapper returns the same 49 GitKB tools.
The generic `codex mcp add` command is therefore a new-project setup command,
not something to rerun here.

This writes the server entry to ` $CODEX_HOME/config.toml`  when ` CODEX_HOME`  is set, or ` ~/.codex/config.toml`  by default. If editing manually, add:

```
[mcp_servers.gitkb]
command = "git-kb"
args = ["mcp"]
```

For Codex skills and instructions, run:

```
git-kb init codex
```

### Cline (VS Code)

Add to your Cline MCP settings (accessible via the Cline extension settings):

```
{
  "mcpServers": {
    "gitkb": {
      "command": "git-kb",
      "args": ["mcp"]
    }
  }
}
```

### Windsurf

Add to ` ~/.codeium/windsurf/mcp_config.json` :

```
{
  "mcpServers": {
    "gitkb": {
      "command": "git-kb",
      "args": ["mcp"]
    }
  }
}
```

## Verify the connection

After configuring, ask your AI assistant:

>

“List all documents in the knowledge base”

The assistant should use the ` kb_list`  tool and return your documents.

## Available tools

GitKB provides 49 MCP tools organized by category. See the MCP Tools Reference  for full parameter documentation.

Category | Tools
Documents | ` kb_list` , ` kb_show` , ` kb_create` , ` kb_update` , ` kb_set` , ` kb_mv` , ` kb_delete` , ` kb_assign` , ` kb_unassign`
Workspace | ` kb_checkout` , ` kb_status` , ` kb_diff` , ` kb_commit` , ` kb_stash` , ` kb_reset` , ` kb_clear` , ` kb_log`
Search | ` kb_search` , ` kb_semantic`
Graph | ` kb_graph` , ` kb_link` , ` kb_unlink` , ` kb_reorder`
Board &  Views | ` kb_board` , ` kb_view`
Context &  Config | ` kb_context` , ` kb_smart_context` , ` kb_ready` , ` kb_resolve` , ` kb_config_get` , ` kb_events`
Export &  Recovery | ` kb_export` , ` kb_backup` , ` kb_restore`
Conflicts | ` kb_conflict_show` , ` kb_conflict_accept`
Code Intelligence | ` kb_symbols` , ` kb_callers` , ` kb_callees` , ` kb_impact` , ` kb_dead_code` , ` kb_symbol_refs` , ` kb_index` , ` kb_code_doctor` , ` kb_code_entrypoints` , ` kb_code_flows` , ` kb_code_flow` , ` kb_code_query`
AI | ` kb_embed`

## Troubleshooting

Problem | Solution
Tools not appearing | Restart your editor after adding MCP config
“Daemon not running” | Run ` git-kb daemon start`  to start manually
Connection timeout | Check ` git-kb doctor`  for diagnostics
Wrong KB loaded | Verify you’re in the correct project directory

## Next steps

- Claude Code  — Set up rules, skills, and MCP config

- Agent Harnesses &  Skills  — Compare Claude Code, Codex, Cursor, Windsurf, and MCP clients

- Agent Workflows  — Learn how AI agents use GitKB effectively

- Documents  — Understand document types and structure
