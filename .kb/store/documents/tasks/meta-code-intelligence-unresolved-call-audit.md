---
id: 019f2395-e17c-7e23-b9d4-5de349c2ac41
slug: tasks/meta-code-intelligence-unresolved-call-audit
title: "Audit GitKB code intelligence unresolved calls"
type: task
status: completed
priority: high
tags: [gitkb, code-intelligence, meta, quality]
---

# Summary

Audit and improve the GitKB code-intelligence unresolved-call surface for the Meta control plane. The live snapshot in [[tasks/meta-code-intelligence-live-snapshot-2026-07-02]] proved that the index is functioning, but `git-kb code doctor --json` reported more unresolved calls than resolved edges.

# Trigger Evidence

From the 2026-07-02 live run:

- `git-kb code stats --json` reported 2,787 resolved call edges and 11,517 unresolved calls.
- Unresolved reasons were `no_match` 6,108, `skip_list` 4,972, `ambiguous` 417, and `stdlib_allowlist` 20.
- `git-kb code doctor --json` recommended inspecting top unresolved reasons and files, reviewing resolution provenance before tuning matching behavior, and inspecting symbol-forwarding facts with `module_not_found=18`.

# Acceptance Criteria

- [x] Produce the top unresolved files and symbols by reason using GitKB code-intelligence commands or database-supported tooling.
- [x] Classify unresolved calls into expected Rust/stdlib noise, skip-list policy, ambiguous local symbols, and real language-pack or repo-discovery defects.
- [x] Fix only confirmed source or configuration defects; do not tune by guessing.
- [x] Add or update tests for any changed code-intelligence behavior.
- [x] Re-run `git-kb code index --force --prune`, `git-kb code stats --json`, `git-kb code doctor --json`, `git-kb code query unresolved-by-reason --json`, and representative caller/callee/impact probes.
- [x] Record before/after counts and residual known limitations in this task.

# Implementation

Added root `.gitkbignore`:

```gitignore
# Generated Rust build output should not enter GitKB code intelligence.
target/
**/target/
```

This is a confirmed local configuration defect, not a resolver tuning guess. Before the change, `code_file` contained generated build output under `agent/target/`, including two indexed Rust symbols from generated Serde `out/private.rs` files. After adding the ignore rule and running the required force/prune pipeline, those generated files were removed from the code-file projection.

No Rust code-intelligence resolver source was changed in this repository because the remaining high unresolved count is produced by the installed `git-kb` resolver behavior. The local Meta control-plane source/config fix available here is to keep generated build output out of the index.

# Audit Evidence

## Top Unresolved Files By Reason

From GitKB doctor and SQLite projection table `unresolved_call`:

| Reason | File | Count |
|---|---:|---:|
| `skip_list` | `meta_mcp/src/main.rs` | 536 |
| `no_match` | `meta_mcp/src/main.rs` | 489 |
| `no_match` | `meta_cli/src/registry.rs` | 452 |
| `skip_list` | `meta_cli/src/registry.rs` | 344 |
| `no_match` | `meta_cli/src/main.rs` | 339 |
| `no_match` | `meta_cli/src/subprocess_plugins.rs` | 337 |
| `skip_list` | `meta_core/src/config.rs` | 313 |
| `skip_list` | `meta_cli/src/main.rs` | 294 |
| `no_match` | `meta_project_cli/src/lib.rs` | 268 |
| `no_match` | `meta_cli/src/init.rs` | 262 |

## Top Unresolved Symbols By Reason

From `unresolved_call`:

| Reason | Callee | Count | Classification |
|---|---:|---:|---|
| `skip_list` | `unwrap` | 1,026 | expected Rust/std method skip-list policy |
| `skip_list` | `to_string` | 919 | expected Rust/std method skip-list policy |
| `no_match` | `assert` | 861 | expected Rust test macro noise |
| `no_match` | `assert_eq` | 622 | expected Rust test macro noise |
| `skip_list` | `join` | 534 | expected std/path/vector style skip-list policy |
| `no_match` | `contains` | 405 | likely std/container method resolution gap |
| `no_match` | `println` | 330 | expected Rust macro noise |
| `ambiguous` | `new` | 326 | ambiguous local/common constructor name |
| `no_match` | `format` | 258 | expected Rust macro noise |
| `no_match` | `vec` | 235 | expected Rust macro noise |

## Forwarding Defects

`code_symbol_forwarding` reported 18 `module_not_found` rows. The unresolved forwarding rows were for valid external crate-style Rust reexports:

- `meta_cli/src/config.rs` line 6: `pub use meta_core::config::*`
- `meta_cli/src/subprocess_plugins.rs` line 12: `pub use meta_plugin_protocol::{...}`
- `meta_project_cli/src/lib.rs` line 12: `pub use meta_plugin_protocol::{...}`
- `meta_rust_cli/src/lib.rs` line 5: `pub use meta_plugin_protocol::{...}`

GitKB can see the target symbols directly:

- `git-kb code symbols ExecutionPlan --json --compact` returned `meta_plugin_protocol/src/lib.rs::struct::ExecutionPlan`.
- `git-kb code symbols CommandResult --json --compact` returned `meta_plugin_protocol/src/lib.rs::enum::CommandResult` along with other same-name symbols.
- `git-kb code symbols output_execution_plan --json --compact` returned `meta_plugin_protocol/src/lib.rs::function::output_execution_plan`.

Classification: these rows are real resolver/language-pack limitations in the installed `git-kb` resolver for external crate path forwarding across meta peer repos. The source imports are valid Rust and compile-time source should not be rewritten to appease the index.

# Before And After

## Before

- `git-kb code stats --json`: 314 code files, 1,429 symbols, 2,787 resolved call edges, 11,517 unresolved calls, 0 stale files.
- `git-kb code doctor --json`: 64 Rust files, 1,429 symbols, 2,787 resolved call edges, 11,517 unresolved calls.
- `code_file` target query: 74 target files, 2 target symbols, 0 target calls.

## Change

- Added `.gitkbignore` to exclude generated build output:
  - `target/`
  - `**/target/`

## Required Pipeline Re-run

- `git-kb code index --force --prune`
  - Indexed 1,427 symbols from 240 files.
  - Extracted 14,304 call sites.
  - Extracted 246 imports.
  - Extracted 27 symbol-forwarding facts.
  - Pruned 2 stale symbols.
- `git-kb code stats --json`
  - 240 code files.
  - 1,427 symbols.
  - 2,787 resolved call edges.
  - 11,517 unresolved calls.
  - 0 stale files.
- `git-kb code doctor --json`
  - Repo discovery strategy `meta`, status `ok`.
  - Repo count 15.
  - 62 Rust files.
  - Same remaining resolver recommendations.
- `git-kb code query unresolved-by-reason --json --limit 10`
  - `no_match`: 6,108.
  - `skip_list`: 4,972.
  - `ambiguous`: 417.
  - `stdlib_allowlist`: 20.
- `git-kb code callers meta_cli/src/main.rs::function::main --json`
  - Count 0.
- `git-kb code callees meta_cli/src/main.rs::function::main --json`
  - Count 20.
- `git-kb code impact meta_cli/src/main.rs --json --compact`
  - Count 9.
- SQLite projection check:
  - `target_files`: 0.
  - `target_symbols`: 0.
  - `target_calls`: 0.

# Tests And Verification

No Rust resolver code was modified in this repository, so no Rust unit test was added. The changed behavior is configuration/index behavior, verified by:

- `git-kb code index --force --prune`
- `git-kb code index --dry-run`
- `git-kb code stats --json`
- `git-kb code doctor --json`
- `git-kb code query unresolved-by-reason --json --limit 10`
- `git-kb code callers meta_cli/src/main.rs::function::main --json`
- `git-kb code callees meta_cli/src/main.rs::function::main --json`
- `git-kb code impact meta_cli/src/main.rs --json --compact`
- SQLite projection query proving target-indexed files are now zero.

# Residual Limitations

- The unresolved-call count remains 11,517. This is not fixed by Meta source/config alone.
- Most unresolved volume is expected Rust macro/std/common-method surface or skip-list policy.
- The `module_not_found=18` forwarding rows are real installed GitKB resolver limitations for external crate-style `pub use` across peer repos.
- Do not rewrite valid Rust imports to force current index behavior. The right fix belongs in GitKB resolver/language-pack behavior or configuration support for cross-crate module resolution.

# Completion Evidence

- Source change: `.gitkbignore` excludes generated `target/` output from GitKB code intelligence.
- GitKB index proof: after force/prune, target-indexed files dropped from 74 to 0 and target-indexed symbols dropped from 2 to 0.
- Git commit: `1bf0f3b chore: ignore generated code index output`.

# Progress Log

### 2026-07-02

- Started task through the GitKB CLI workflow.
- Used GitKB code-intelligence commands first, then inspected the local SQLite projection for unresolved-call details not exposed directly by CLI summary commands.
- Added the root `.gitkbignore` target exclusion and reran the required code-intelligence verification pipeline.

# Notes

This is a quality task, not a proof that GitKB is absent. The live proof task established that GitKB is present and useful. This task exists because the graph should become more trustworthy before we lean on it for larger refactors or release dependency maps.
