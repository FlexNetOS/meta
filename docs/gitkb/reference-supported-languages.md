<!-- Source: https://gitkb.com/docs/reference/supported-languages/ -->
<!-- Snapshot: 2026-07-02 -->

# Supported Languages

GitKB’s code intelligence supports 17 per-language crates  with full native AST extraction: symbols, calls, imports, call graph traversal, impact analysis, and dead code detection.

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

## Non-code formats

These formats are recognized by file extension (they appear in ` git-kb code stats` ) but don’t support code intelligence features — no symbol extraction, no call graph, no impact analysis.

Format | File extensions
HTML | ` .html` , ` .htm`
CSS | ` .css` , ` .scss` , ` .sass` , ` .less`
JSON | ` .json`
YAML | ` .yaml` , ` .yml`
Nix | ` .nix`

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

## Next steps

- Code Intelligence  — How to query the call graph

- CLI Reference  — Full command reference for ` git-kb code`

- MCP Tools  — Code intelligence tools for AI assistants
