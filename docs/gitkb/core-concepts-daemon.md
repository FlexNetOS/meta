<!-- Source: https://gitkb.com/docs/core-concepts/daemon/ -->
<!-- Snapshot: 2026-07-02 -->

# Daemon

Local verification: this extracted page was executed against the FlexNetOS
`meta` checkout. The live daemon socket and log paths are under
` .kb/.cache/` , and the live `git-kb daemon start` command supports
`--background`, `--verbose`, and `--log-format`; it does not support
`--log-level`.

The GitKB daemon is an optional  background service for users who want realtime code indexing and embedding generation. All core KB operations — documents, graph, full-text search, MCP tools, commits — work without it.

Run the daemon when you want the file watcher to re-index your code on save, or when you want semantic search powered by embeddings.

## Architecture

The daemon runs as a single background process per KB, communicating via a Unix socket at ` .kb/.cache/gitkb.sock` . All daemon-dependent features — MCP tools, code intelligence queries, semantic search — route through this socket.

```
  Editor (MCP)  ──┐
                  │     Unix socket
  CLI command   ──┼──▶ .kb/.cache/gitkb.sock ──▶ Daemon process
                  │         │
  File watcher  ──┘         ├── Code index (SQLite)
                            ├── Embedding engine
                            └── Vector index
```

Each KB instance gets its own daemon — if you work across multiple projects, each runs independently.

## What the daemon powers

Feature | Description
File watching | Monitors source files and re-indexes on save
Code intelligence | Serves symbol lookups, caller/callee queries, impact analysis
Semantic search | Manages embeddings and vector similarity search
MCP server | Handles tool calls from AI editors via the Model Context Protocol

Without the daemon, you can still use all document management commands (` create` , ` show` , ` list` , ` commit` , etc.) — those operate directly on the database.

## Auto-start

You rarely need to manage the daemon manually. The MCP server and CLI commands that require the daemon will auto-start  it when needed. For example, running ` git-kb code callers`  will start the daemon if it isn’t already running.

## File watching

The daemon watches your source files for changes and re-indexes automatically. When you save a file, the daemon waits 500ms  (debounce) then updates the code symbol index. This means call graph queries always reflect your latest code without manual re-indexing.

File watching activates after initial indexing:

```
# Index your source directory (one-time)
git-kb code index src/

# From here, the daemon watches for changes automatically
```

## Embedding management

The embedding engine uses lazy initialization  — it doesn’t load the model until the first semantic search or embed request. This keeps daemon startup fast.

The state machine:

```
Idle ──▶ Initializing ──▶ Ready
                     └──▶ Unavailable (on error)
```

- Idle  — Daemon is running but the embedding model isn’t loaded

- Initializing  — Model is loading (triggered by first embed/search request)

- Ready  — Model loaded, semantic search available

- Unavailable  — Model failed to load (check logs for details)

Enable embeddings in your configuration :

```
[embeddings]
enabled = true
```

## Manual control

```
# Start the daemon
git-kb daemon start

# Check daemon status
git-kb daemon status

# Stop the daemon
git-kb daemon stop
```

## Logging

For debugging, start the daemon with verbose CLI output:

```
git-kb daemon start --verbose
```

The live start command also supports ` --background`  when a caller wants the
daemon spawned as a child process and then released.

Logs output to stderr in the foreground. The daemon log file for this checkout
is ` .kb/.cache/daemon.log` .

## Resource usage

The daemon is lightweight when idle — it holds the file watcher and socket listener but uses minimal CPU. Memory usage increases with:

- Code index size  — more indexed files means a larger in-memory symbol table

- Embedding model  — the Candle backend loads the model into memory (~100MB) on first use

- Vector index  — scales with the number of embedded documents

If resources are a concern, stop the daemon when you’re not actively using code intelligence or semantic search:

```
git-kb daemon stop
```

It will auto-start again when needed.

## Diagnostics

Run the built-in doctor to check your GitKB setup:

```
git-kb doctor
```

This checks the daemon status, database integrity, and configuration.

## Next steps

- MCP Setup  — Connect the daemon to your editor

- Code Intelligence  — Features powered by the daemon

- Configuration  — Daemon-related settings

- Troubleshooting  — Common daemon issues and fixes
