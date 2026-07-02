<!-- Source: https://gitkb.com/docs/core-concepts/code-intelligence/ -->
<!-- Snapshot: 2026-07-02 -->

# Code Intelligence

GitKB indexes your source code to build a call graph  spanning 17 per-language crates. This lets you understand callers, callees, blast radius, dead code, execution flows, and architectural hotspots before making changes.

## Zero-friction setup

Code intelligence works on any Git repository — no ` git-kb init`  required. Install GitKB and start querying:

```
brew install gitkb/tap/gitkb
cd your-project
git-kb code index
git-kb code callers your-function
```

The index is stored invisibly under ` .git/`  — nothing added to your project, nothing to configure.

If you have a full GitKB knowledge base (` .kb/` ), code intelligence integrates automatically — linking code symbols to documents, tasks, and specs in the knowledge graph.

Live verification in this repository, 2026-07-02: `git-kb --version` reported `git-kb 0.2.12`, and `git-kb code --kb-root` resolved `/home/flexnetos/FlexNetOS/src/meta`. This checkout is a meta-repo, so examples that use `src/` are generic single-repo examples; local commands should use peer paths such as `agent/src/guard.rs`, `loop_lib/src/lib.rs`, or `meta_cli/src/main.rs`.

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

Live local indexing results:

```
git-kb code index src/          # Indexed 0 symbols from 0 files in this meta root
git-kb code index --dry-run     # Would index 1429 Rust symbols from 314 files
git-kb code index               # Indexed 1429 symbols from 314 files; all files unchanged
```

The dry run also extracted 14304 call sites, 247 imports, and 29 symbol-forwarding facts. The real index pass extracted 28 symbol-forwarding facts and reported that all 314 files were unchanged.

After initial indexing, the daemon’s file watcher keeps the index current automatically (500ms debounce on file save). Without the daemon, re-run ` git-kb code index`  after significant changes.

## Querying

### Symbols

List all symbols in a file:

```
git-kb code symbols --file src/auth.ts
git-kb code symbols --file agent/src/guard.rs --json
```

Local proof: `agent/src/guard.rs` returned 50 symbols with the default limit. Searching `GuardConfig` returned both the struct and impl symbols.

### Callers

Find every call site for a function:

```
git-kb code callers validateToken
git-kb code callers agent/src/guard.rs::function::evaluate_command --json
```

Resolves trait dispatch, interface implementations, and cross-module references.

Local proof: `evaluate_command` returned 50 callers with the default limit.

### Callees

Find what a function calls:

```
git-kb code callees login
git-kb code callees agent/src/guard.rs::function::evaluate_command --json
```

Local proof: `evaluate_command` returned 4 callees: `evaluate_segment`, `split_compound_command`, `GuardConfig.compile_patterns`, and `GuardConfig.load`.

### Impact analysis

Before modifying a file, check the transitive blast radius:

```
git-kb code impact src/auth.ts
git-kb code impact agent/src/guard.rs --json
```

Shows all dependent files at each depth — the complete set of things that could break.

Local proof: `agent/src/guard.rs` returned 125 total impact records, with 50 shown at the default limit.

### Dead code

Find symbols with zero callers:

```
git-kb code dead --file src/auth.ts
git-kb code dead --file agent/src/guard.rs --json --limit 10
```

Framework entrypoints, route handlers, CLI commands, and test functions are classified separately — they aren’t reported as dead code.

The live CLI does not accept a positional path for `git-kb code dead`; use `--file`, `--kind`, or other filters. Local proof returned 10 `NoCallers` entries from `agent/src/guard.rs`.

### Doctor

Diagnose index health — unresolved calls, resolution rates by language, stale files:

```
git-kb code doctor
git-kb code doctor --json
```

Local proof: `git-kb code doctor --json` reported 1429 symbols, 2144 resolved call edges, 9127 unresolved calls, 15 discovered repos using `strategy: meta`, and 14 index roots. The recommendations said to inspect unresolved `no_match`/`ambiguous` behavior, review resolution provenance, and inspect unresolved symbol-forwarding facts.

### Entrypoints

Inspect inferred code entrypoints — CLI commands, route handlers, test functions, public API surfaces:

```
git-kb code entrypoints
git-kb code entrypoints --refresh
```

Local proof: `git-kb code entrypoints --refresh --json` succeeded; the default JSON listing returned 100 entries.

### Flows

Trace execution flows from entrypoints through the call graph:

```
# List all flows
git-kb code flows
git-kb code flows --refresh

# Inspect a specific flow
git-kb code flow <flow-id>
```

Local proof: `git-kb code flows --refresh --json` returned the default 50 flows. Inspecting one returned flow id with `git-kb code flow <flow-id> --json` returned ordered flow nodes with distance and edge type.

### Query templates

Run prebuilt architectural queries:

```
# Find the most-called symbols (highest fan-in)
git-kb code query hotspots

# Dead code with evidence explaining each classification
git-kb code query dead-code-explain
```

The live query templates are `hotspots`, `public-api`, `entrypoints`, `unresolved-by-reason`, `cross-service-impact`, `dead-code-explain`, `routes`, `route-clients`, and `handler-routes`. Local proof: `git-kb code query hotspots --json --limit 5` returned `meta_core/src/lock.rs::method::LockGuard.path` as the highest fan-in hotspot, and `git-kb code query dead-code-explain --json --limit 5` returned `NoCallers` evidence.

### Stats

Index health dashboard — symbol counts by language, resolved vs unresolved edges, file coverage:

```
git-kb code stats
git-kb code stats --json
```

Local proof: `git-kb code stats --json` reported 1429 symbols across 314 files, 2144 call edges, 9127 unresolved calls, no stale files, and Rust as the only symbol-producing language in this checkout. JSON/TOML/YAML/Markdown/Makefile/Bash files were detected but produced no symbols.

### Refs (requires full KB)

Find documents that reference a code symbol via ` [[code:...]]`  wikilinks:

```
git-kb code refs validateToken
git-kb code refs agent/src/guard.rs::function::evaluate_command --json
```

This command requires a full GitKB knowledge base (` git-kb init` ).

Local proof: this full KB currently returned zero documents for `agent/src/guard.rs::function::evaluate_command`, including with `--textual --include-maybe`. A document must contain a matching `[[code:...]]` link, or textual match when requested, before `code refs` returns results.

### Dump AST

Debug language indexing by inspecting the raw parse tree:

```
git-kb code dump-ast src/auth.rs
git-kb code dump-ast src/auth.rs --language rust --lines 10-25
git-kb code dump-ast agent/src/guard.rs --language rust --lines 576-592 --json
```

Local proof: the AST dump returned a tree-sitter `source_file` containing the `function_item` for `evaluate_command`.

### Maintenance

```
# Remove stale symbols from deleted/renamed files
git-kb code prune --stale

# Detect default branches for multi-repo setups
git-kb code detect-default-branches --dry-run
git-kb code detect-default-branches
```

The live `prune` command requires one of `--worktree`, `--branch`, or `--stale`; bare `git-kb code prune` exits with usage error. Local proof: `git-kb code prune --stale` reported no non-main branches in the index. `git-kb code detect-default-branches --dry-run` found 15 repos all on `main` and wrote nothing; running without `--dry-run` updated `.kb/config.toml`, including `[code.repo_default_branch_map]` and default `[apps]`, `[embeddings]`, and `[hooks]` sections.

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
