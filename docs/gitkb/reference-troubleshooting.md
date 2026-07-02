<!-- Source: https://gitkb.com/docs/reference/troubleshooting/ -->
<!-- Snapshot: 2026-07-02 -->

# Troubleshooting

Common issues and how to resolve them.

## “Daemon not running” / “Connection refused”

The daemon isn’t running or the socket file is stale.

```
# Check daemon status
git-kb daemon status

# Start manually
git-kb daemon start

# If the socket file is stale, stop and restart
git-kb daemon stop
git-kb daemon start
```

The daemon auto-starts when needed by MCP and CLI commands, so this usually means something prevented startup. Check logs:

```
git-kb daemon start
```

Live verification in this repository, 2026-07-02: `git-kb daemon start
--help` exposes `--background`, but it does not expose `--log-level`. The local
daemon status currently reports not running while `.kb/.cache/gitkb.sock`
exists, so treat that socket as stale unless a matching daemon process is
present.

## “No documents found”

The KB is empty or you’re in the wrong directory.

```
# Verify you're in a KB root (should show .kb/ info)
git-kb info

# Check if documents exist
git-kb list

# If empty, initialize context
git-kb create --type context --slug context/active --title "Active Context"
```

GitKB discovers the KB by searching upward for a ` .kb/`  directory. Use the ` GITKB_ROOT`  environment variable to override discovery if needed.

Local proof: `git-kb info --json` reports `80` documents, `41` KB commits, `0`
stashes, and `1429` indexed symbols in this checkout.

## MCP tools not appearing in editor

The editor can’t find or connect to the MCP server.

1.

Verify config file location:

2. Claude Code: ` .mcp.json`  in project root

3. Cursor: ` .cursor/mcp.json`  in project root

4. Cline: Cline extension MCP settings

5. Windsurf: ` ~/.codeium/windsurf/mcp_config.json`

6.

Verify the binary is on PATH:

```
which git-kb
```

7.

Restart the editor  after adding MCP configuration.

8.

Cursor note:  MCP tools only appear in Agent mode, not normal chat.

9.

Test MCP locally:

```
{ printf '%s\n' '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"mcp-check","version":"0"}}}'; sleep 0.2; printf '%s\n' '{"jsonrpc":"2.0","method":"notifications/initialized","params":{}}'; sleep 0.2; printf '%s\n' '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}'; sleep 1; } | git-kb mcp
```

The shorter `tools/list`-only pipe fails against the live `0.2.12` MCP server
with `expect initialized request`; MCP clients must initialize before listing
tools.

## Stale workspace

The workspace has old checkouts or uncommitted changes from a previous session.

```
# See what's in the workspace
git-kb status

# Review uncommitted changes
git-kb diff

# If changes are valuable, commit them
git-kb commit -m "Save previous work"

# If changes are stale, discard them
git-kb reset
git-kb clear
```

To reset a single document without affecting others:

```
git-kb reset tasks/my-task
git-kb clear tasks/my-task
```

## Semantic search not working

Semantic search requires embeddings to be enabled and the daemon to be running.

1.

Enable embeddings in config:

```
# .kb/config.toml
[embeddings]
enabled = true
```

2.

Restart the daemon  to pick up config changes:

```
git-kb daemon stop
git-kb daemon start
```

3.

Check embedding state  — the daemon initializes embeddings lazily on first request. The state progresses: Idle → Initializing → Ready. If it shows “Unavailable”, check logs for errors.

4.

Generate embeddings  for existing documents:

```
git-kb ai embed
```

Local proof: `git-kb ai embed --dry-run --scope documents` returns `Embedding
operations require the daemon. Run 'git-kb daemon start' first.` Dry-run does
not bypass the daemon requirement.

## Sync conflicts during push/pull

When two nodes modify the same document, GitKB detects the conflict during pull.

```
# List conflicts
git-kb conflict show

# View a specific conflict
git-kb conflict show <slug>

# Resolve — choose local, remote, or edit manually
git-kb conflict accept <slug> --local
git-kb conflict accept <slug> --remote
```

After resolving all conflicts, commit and push:

```
git-kb commit -m "Resolve sync conflicts"
git-kb push origin
```

Live verification: `git-kb conflict --help` exposes only `show` and `accept`;
there is no `conflict list` or `conflict resolve` command in the installed
`git-kb 0.2.12` binary.

## Code intelligence returning empty results

The source files haven’t been indexed yet.

```
# Index a directory
git-kb code index agent/src/

# Verify symbols were indexed
git-kb code symbols --file agent/src/guard.rs --json
```

After initial indexing, the daemon’s file watcher keeps the index current automatically (500ms debounce on file save). If the daemon isn’t running, changes won’t be re-indexed until it starts.

Local proof: `git-kb code symbols --file agent/src/guard.rs --json` returns
Rust symbols. Use repo-relative peer paths in this meta checkout rather than a
generic `src/` path.

## “Permission denied” on socket

The daemon socket at ` .kb/.cache/gitkb.sock`  has incorrect permissions, or another user’s daemon owns it.

```
# Check socket ownership
ls -la .kb/.cache/gitkb.sock

# Prefer stop first, then restart
git-kb daemon stop
git-kb daemon start
```

If the socket remains after `git-kb daemon stop` and `git-kb daemon status`
confirms no daemon is running, removing `.kb/.cache/gitkb.sock` is a destructive
filesystem cleanup step and should be done only after that proof.

Each KB instance gets its own daemon and socket — make sure you’re not accidentally sharing a ` .kb/`  directory across users.

## Diagnostic commands

Command | What it checks
`git-kb doctor` | Configuration, daemon, database integrity, file store
`git-kb info` | KB statistics — document count, storage size, index state
`git-kb daemon status` | Whether the daemon is running, PID, socket path
`git-kb verify` | File store integrity — detects missing or corrupt files

Run ` git-kb doctor`  first — it checks everything and reports problems with suggested fixes.

## Reporting issues

If you can’t resolve an issue, open a GitHub issue with:

1. Output of ` git-kb doctor`

2. Output of ` git-kb info`

3. Your ` .kb/config.toml`  (redact API keys)

4. Steps to reproduce

File issues at: github.com/nicholasgasior/gitkb

## Next steps

- Configuration  — Full config.toml reference

- Daemon  — How the background service works

- CLI Reference  — Complete command reference
