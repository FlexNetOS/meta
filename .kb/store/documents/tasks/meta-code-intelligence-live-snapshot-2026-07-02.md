---
id: 019f2394-adb0-71b1-b07d-6ba2ac3c79cd
slug: tasks/meta-code-intelligence-live-snapshot-2026-07-02
title: "Capture live GitKB code intelligence snapshot"
type: task
status: completed
priority: high
tags: [gitkb, code-intelligence, meta, proof]
---

# Summary

Run the GitKB `code-intelligence` workflow against the live Meta control-plane checkout and record proof from the installed local `git-kb` binary. This task exists as a durable receipt for the user request to run `$code-intelligence` and create KB state from the result.

Related follow-up: [[tasks/meta-code-intelligence-unresolved-call-audit]]

# Acceptance Criteria

- [x] Use the `code-intelligence` skill instructions rather than ad hoc text search.
- [x] Run `git-kb code index` from `/home/flexnetos/FlexNetOS/src/meta`.
- [x] Prove symbol, caller/callee, impact, entrypoint, flow, hotspot, dead-code, refs, stats, and doctor surfaces with live commands.
- [x] Capture any gaps as KB task work instead of hiding warnings.
- [x] Commit the KB task evidence.

# Live Evidence

All commands were run from `/home/flexnetos/FlexNetOS/src/meta` on 2026-07-02.

## Index

`git-kb code index`

- Indexed 1,427 symbols from 240 files on the first run.
- Extracted 14,304 call sites.
- Extracted 246 imports.
- Extracted 27 symbol-forwarding facts.
- Subsequent stats showed 1,429 indexed Rust symbols across 314 tracked files, 2,787 resolved call edges, and 0 stale files.

## Stats

`git-kb code stats --json`

- `kb_root`: `/home/flexnetos/FlexNetOS/src/meta`
- `file_count`: 314
- `symbol_count`: 1,429
- `call_edge_count`: 2,787
- `unresolved_call_count`: 11,517
- `stale_files`: 0
- Languages: Rust only, 1,429 symbols.
- Top symbol directories: `meta_cli` 432, `meta_git_lib` 279, `agent` 200, `meta_git_cli` 195, `meta_core` 104, `meta_mcp` 74, `loop_lib` 60, `meta_project_cli` 55, `meta_plugin_protocol` 16, `meta_rust_cli` 12, `loop_cli` 2.
- Unresolved breakdown: `no_match` 6,108, `skip_list` 4,972, `ambiguous` 417, `stdlib_allowlist` 20.

## Doctor

`git-kb code doctor --json`

- Repo discovery status: `ok`
- Repo discovery strategy: `meta`
- KB root and meta root both resolved to `/home/flexnetos/FlexNetOS/src/meta`.
- Repo count: 15.
- Index roots include `agent`, `claude-plugins`, `codex-plugins`, `loop_cli`, `loop_lib`, `meta-plugins`, `meta_cli`, `meta_core`, `meta_git_cli`, `meta_git_lib`, `meta_mcp`, `meta_plugin_protocol`, `meta_project_cli`, and `meta_rust_cli`.
- Recommendations:
  - Inspect top unresolved reasons and files.
  - Unresolved calls exceed resolved edges.
  - Symbol-forwarding facts have unresolved module or target status; doctor reported `module_not_found=18`.

## Symbols

`git-kb code symbols --file meta_cli/src/main.rs --json --compact`

- Returned 50 symbols.
- First symbols included modules `init`, `registry`, and `subprocess_plugins`; constant `VERSION`; struct `Cli`; enum `Commands`; structs `ContextArgs`, `ExecArgs`, and `InitArgs`; enum `InitCommands`; and functions such as `print_help_with_plugins`, `write_help_with_plugin_commands`, `print_context_help`, and plugin help functions.

## Call Graph

`git-kb code callers meta_cli/src/main.rs::function::main --json`

- Returned count `0`; `main` is an entrypoint and has no callers.

`git-kb code callees meta_cli/src/main.rs::function::main --json`

- Returned count `20`.
- Sample callees included `handle_context`, `handle_init_command`, `check_and_warn_orphan`, `extract_global_flags`, `handle_command_dispatch`, `handle_plugin_command`, `print_context_help`, `print_help_with_plugins`, `discover_plugins`, `execute`, `get_plugin_help`, `get_promoted_commands`, and `SubprocessPluginManager.new`.

## Impact

`git-kb code impact meta_cli/src/main.rs --json --compact`

- Returned count `9`.
- Impact callers included `run_plugin`, `print_help_with_plugins`, `main`, `handle_command_dispatch`, `handle_plugin_command`, `unrecognized_command_error`, `flatten_with_tag_filter`, `flatten_filtered_inner`, and `test_discover_nested_projects_with_tag_filter`.

## Entrypoints And Flows

`git-kb code entrypoints --refresh --json`

- Returned 100 entrypoints.
- Sample binary entrypoints include `agent/src/main.rs::function::main`, `loop_cli/src/main.rs::function::main`, `meta_cli/src/main.rs::function::main`, `meta_git_cli/src/main.rs::function::main`, `meta_mcp/src/main.rs::function::main`, `meta_project_cli/src/main.rs::function::main`, and `meta_rust_cli/src/main.rs::function::main`.

`git-kb code flows --refresh --json`

- Returned 50 flows.
- Top flows included `meta_git_cli` status/setup-ssh/worktree flows and `meta_cli/src/main.rs::function::handle_command_dispatch`.

## Hotspots

`git-kb code query hotspots --json --limit 10`

- Highest caller-count hotspots:
  - `meta_core/src/lock.rs::method::LockGuard.path` with count 506.
  - `agent/src/score.rs::method::Grade.display` with count 135.
  - `agent/src/guard.rs::function::evaluate_command` with count 87.
  - `meta_git_lib/src/worktree/types.rs::method::RepoSpec.from_str` with count 83.
  - `meta_mcp/src/main.rs::method::McpServer.new` with count 47.

## Unresolved And Dead Code

`git-kb code query unresolved-by-reason --json --limit 10`

- `no_match`: 6,108
- `skip_list`: 4,972
- `ambiguous`: 417
- `stdlib_allowlist`: 20

`git-kb code dead --json --compact --limit 10`

- Returned 10 entries.
- Sample entries included `meta_git_cli/src/git_env.rs` test-like helper functions without explicit test classification, `meta_git_cli/src/main.rs::function::execute`, `meta_git_cli/src/ssh.rs` helper/test functions, and platform-specific `meta_core/src/lock.rs::function::is_process_alive` variants.

## Document References

`git-kb code refs meta_cli/src/main.rs::function::main --json`

- Returned 5 referencing documents.
- References include completed code-intelligence and foundation proof tasks plus this live snapshot task.

# Findings

- GitKB code intelligence is installed and functioning in this checkout.
- Meta repo discovery is correctly recognized as `strategy = "meta"` rather than a monorepo.
- The live code-intelligence output is useful enough for symbol lookup, entrypoint discovery, flow discovery, hotspot discovery, and targeted call graph work.
- The unresolved-call ratio is not healthy enough to call the code graph complete. That is now tracked explicitly in [[tasks/meta-code-intelligence-unresolved-call-audit]].
