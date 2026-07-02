<!-- Source: https://gitkb.com/docs/core-concepts/code-intelligence/ -->
<!-- Snapshot: 2026-07-02 -->

# Code Intelligence

GitKB indexes your source code to build a call graph  spanning 17 per-language crates. This lets you understand callers, callees, blast radius, dead code, execution flows, and architectural hotspots before making changes.

## Zero-friction setup

Code intelligence works on any Git repository — no ` git-kb init`  required. Install GitKB and start querying:

```
brew install gitkb
cd your-project
git-kb code index
git-kb code callers your-function
```

The index is stored invisibly under ` .git/`  — nothing added to your project, nothing to configure.

If you have a full GitKB knowledge base (` .kb/` ), code intelligence integrates automatically — linking code symbols to documents, tasks, and specs in the knowledge graph.

## Supported languages

Rust, Python, JavaScript, TypeScript, Go, C, C++, C#, Java, Ruby, Elixir, Kotlin, Swift, Scala, PHP, Haskell, and Lua. All 17 ship as per-language crates with full native AST extraction — symbols, calls, and imports. See Supported Languages  for details.

## Indexing

Index your source files:

```
# Index a directory
git-kb code index src/

# Index an entire repo (default when no path given)
git-kb code index

# Dry run — see what would be indexed
git-kb code index --dry-run
```

After initial indexing, the daemon’s file watcher keeps the index current automatically (500ms debounce on file save). Without the daemon, re-run ` git-kb code index`  after significant changes.

## Querying

### Symbols

List all symbols in a file:

```
git-kb code symbols --file src/auth.ts
```

### Callers

Find every call site for a function:

```
git-kb code callers validateToken
```

Resolves trait dispatch, interface implementations, and cross-module references.

### Callees

Find what a function calls:

```
git-kb code callees login
```

### Impact analysis

Before modifying a file, check the transitive blast radius:

```
git-kb code impact src/auth.ts
```

Shows all dependent files at each depth — the complete set of things that could break.

### Dead code

Find symbols with zero callers:

```
git-kb code dead src/
```

Framework entrypoints, route handlers, CLI commands, and test functions are classified separately — they aren’t reported as dead code.

### Doctor

Diagnose index health — unresolved calls, resolution rates by language, stale files:

```
git-kb code doctor
git-kb code doctor --json
```

### Entrypoints

Inspect inferred code entrypoints — CLI commands, route handlers, test functions, public API surfaces:

```
git-kb code entrypoints
git-kb code entrypoints --refresh
```

### Flows

Trace execution flows from entrypoints through the call graph:

```
# List all flows
git-kb code flows
git-kb code flows --refresh

# Inspect a specific flow
git-kb code flow <flow-id>
```

### Query templates

Run prebuilt architectural queries:

```
# Find the most-called symbols (highest fan-in)
git-kb code query hotspots

# Dead code with evidence explaining each classification
git-kb code query dead-code-explain
```

### Stats

Index health dashboard — symbol counts by language, resolved vs unresolved edges, file coverage:

```
git-kb code stats
```

### Refs (requires full KB)

Find documents that reference a code symbol via ` [[code:...]]`  wikilinks:

```
git-kb code refs validateToken
```

This command requires a full GitKB knowledge base (` git-kb init` ).

### Dump AST

Debug language indexing by inspecting the raw parse tree:

```
git-kb code dump-ast src/auth.rs
git-kb code dump-ast src/auth.rs --language rust --lines 10-25
```

### Maintenance

```
# Remove stale symbols from deleted/renamed files
git-kb code prune

# Detect default branches for multi-repo setups
git-kb code detect-default-branches
```

## Linking code to documents

When using a full GitKB knowledge base, reference code symbols in your documents:

```
The auth refactor changes [[code:src/auth.ts::validateToken]].
```

This creates ` references_code`  edges in the knowledge graph, connecting your documentation to the actual implementation.

## Performance

GitKB’s code intelligence is built in Rust with tree-sitter for AST parsing:

- Indexing : Several hundred thousand lines of code across 57 repos in ~3 seconds

- Queries : Callers, callees, impact, dead code — typically under 30ms

- Incremental updates : Daemon re-indexes on save with 500ms debounce — effectively instantaneous

## Next steps

- Daemon  — How the background service powers code intelligence

- CLI Reference  — Full command reference
