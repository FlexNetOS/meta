<!-- Source: https://gitkb.com/docs/reference/supported-languages/ -->
<!-- Snapshot: 2026-07-02 -->

# Supported Languages

GitKB’s code intelligence supports 17 per-language crates  with full native AST extraction: symbols, calls, imports, call graph traversal, impact analysis, and dead code detection.

## Live FlexNetOS `meta` verification

This page describes the upstream language matrix. The live index in this
repository should be treated separately: this checkout currently has deep code
intelligence for Rust only, plus detected non-symbol formats.

Live verification in this repository, 2026-07-02:

- `git-kb code stats --json` reported `1429` symbols from `314` indexed files,
  with `2144` resolved call edges and `9127` unresolved calls.
- `language_capabilities` reported Rust as `tier: "deep"` with symbols, calls,
  and resolution support.
- Detected non-symbol formats were Bash, JSON, Makefile, Markdown, TOML, and
  YAML. Each had `supports_symbols: false`, `supports_calls: false`, and
  `supports_resolution: false`.
- `git-kb code symbols --language rust --count` returned `1429 symbols
  indexed`; `git-kb code symbols --language python --count` returned
  `0 symbols indexed`.
- `git-kb code index --dry-run` would index `1429` Rust symbols from `314`
  files and extract `14304` call sites, `247` imports, and `29`
  symbol-forwarding facts.
- `git-kb code index --dry-run agent/src/guard.rs` would index `156` Rust
  symbols from one file.
- `git-kb code --help` also exposes live commands not listed in the short
  feature list below: `stats`, `doctor`, `entrypoints`, `flows`, `flow`,
  `query`, `quality`, `dump-ast`, `prune`, and `detect-default-branches`.

## Supported languages

All 17 languages ship as per-language crates with the same level of support — symbols, calls, and imports extracted from the AST, enabling full call graph traversal and impact analysis.

Language | File extensions
Rust | ` .rs`
Python | ` .py`
JavaScript | ` .js` , ` .jsx` , ` .mjs` , ` .cjs`
TypeScript | ` .ts` , ` .tsx` , ` .mts` , ` .cts`
Go | ` .go`
C | ` .c` , ` .h`
C++ | ` .cpp` , ` .cc` , ` .cxx` , ` .hpp` , ` .hh` , ` .hxx`
C# | ` .cs`
Java | ` .java`
Ruby | ` .rb`
Elixir | ` .ex` , ` .exs`
Kotlin | ` .kt` , ` .kts`
Swift | ` .swift`
Scala | ` .scala` , ` .sc`
PHP | ` .php`
Haskell | ` .hs`
Lua | ` .lua`

What you get for every language:

- `git-kb code symbols`  — functions, methods, classes, structs, traits, interfaces

- `git-kb code callers`  — all call sites for any symbol

- `git-kb code callees`  — everything a function calls

- `git-kb code impact`  — transitive blast radius across the call graph

- `git-kb code dead`  — symbols with zero callers

Local caveat: the equal-support statement above is an upstream capability claim.
Before relying on it for a specific checkout, confirm with
`git-kb code stats --json`, `git-kb code doctor --json`, and a language-specific
`git-kb code symbols --language <language> --count`.

## Non-code formats

These formats are recognized by file extension (they appear in ` git-kb code stats` ) but don’t support code intelligence features — no symbol extraction, no call graph, no impact analysis.

Format | File extensions
HTML | ` .html` , ` .htm`
CSS | ` .css` , ` .scss` , ` .sass` , ` .less`
JSON | ` .json`
YAML | ` .yaml` , ` .yml`
Nix | ` .nix`

Local detected non-code formats also include Markdown (`.md`), TOML (`.toml`),
Makefile, and Bash/shell files. They appeared in local stats with zero symbols.

## How to index

Index a directory or specific file:

```
git-kb code index src/
git-kb code index src/auth.ts
```

GitKB auto-detects the language by file extension. After initial indexing, the daemon  watches for file changes and re-indexes automatically (500ms debounce).

To re-index everything and clean up deleted symbols:

```
git-kb code index --prune src/
```

For this meta checkout, use repo-relative peer paths instead of the generic
`src/` example, for example:

```
git-kb code index --dry-run
git-kb code index --dry-run agent/src/guard.rs
git-kb code index --dry-run loop_lib/src/lib.rs
```

`git-kb code index --help` confirms that indexing respects both `.gitignore`
and `.gitkbignore`, supports `--language`, `--include-deps`, `--index-only`,
`--embed-only`, `--branch`, and `--worktree`, and that `--dry-run` is the safe
preview path.

## Next steps

- Code Intelligence  — How to query the call graph

- CLI Reference  — Full command reference for ` git-kb code`

- MCP Tools  — Code intelligence tools for AI assistants
