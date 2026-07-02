---
slug: docs/architecture/gitkb-generated-maps
title: "GitKB Generated Maps"
type: architecture
status: active
source_task: tasks/meta-system-architecture-documentation
last_verified: 2026-07-02
related:
  - docs/architecture/index
  - docs/architecture/data-flows
  - docs/architecture/evidence
  - tasks/meta-gitkb-code-intel-meta-proof-suite
  - tasks/meta-gitkb-document-graph-view-policy
---

# GitKB Generated Maps

GitKB already owns several maps that should not be duplicated as static prose.
This docs set records what each command produces, how to use it, and current
health evidence.

## Document And Task Maps

| Map | Command | Use |
| --- | --- | --- |
| Task board | `git-kb board --json` | Current task status columns and active work. |
| Task context bundle | `git-kb context --task <slug> --code-refs` | Project context, task body, recent commits, and code refs. |
| Document graph | `git-kb graph <slug> --json` | Wikilink/frontmatter relationships and related tasks/context. |
| Document search | `git-kb search "<query>" --json` | Find related tasks/specs/context before creating new docs. |
| Workspace state | `git-kb status --json` and `git-kb diff` | Pending KB workspace changes and graph preview. |

For this task, `git-kb graph tasks/meta-system-architecture-documentation --json`
shows references to:

- [[context/immutable/architecture]]
- [[context/immutable/patterns]]
- [[context/extensible/tech]]
- [[tasks/meta-release-catalog-portable-tools]]
- [[tasks/meta-local-ubuntu-release-runner]]
- [[tasks/meta-gitkb-code-intel-meta-proof-suite]]
- [[tasks/meta-gitkb-document-graph-view-policy]]
- [[tasks/meta-live-test-cli-loop-lib]]
- [[tasks/meta-plugin-gitkb-harness-generation]]
- [[tasks/meta-plugin-mcp-single-owner-policy]]
- [[tasks/meta-unified-agent-plugin-control-plane]]

## Code Intelligence Maps

| Map | Command | Current evidence |
| --- | --- | --- |
| Index inventory | `git-kb code stats --json` | 1429 symbols, 314 files, 2787 call edges, 11517 unresolved calls. |
| Index dry-run | `git-kb code index --dry-run` | Would index 1427 symbols from 240 files, 14304 call sites, 246 imports, 27 forwarding facts. |
| Health | `git-kb code doctor --json` | Repo discovery strategy `meta`, status `ok`, 15 repo roots, unresolved-call recommendations. |
| File symbols | `git-kb code symbols --file meta_cli/src/main.rs --json --compact` | 50 symbols including `Cli`, `Commands`, `main`, and `handle_command_dispatch`. |
| Callers | `git-kb code callers meta_cli/src/main.rs::function::main --json` | `main` has zero callers, as expected for a binary entrypoint. |
| Callees | `git-kb code callees meta_cli/src/main.rs::function::main --json` | `main` has 20 callees including `handle_context`, `handle_init_command`, `handle_command_dispatch`, and plugin discovery/execution methods. |
| Impact | `git-kb code impact meta_cli/src/main.rs --json --compact` | 9 direct caller entries for symbols in `meta_cli/src/main.rs`. |
| Entrypoints | `git-kb code entrypoints --refresh --json` | Inferred binary entrypoints include `agent`, `loop_cli`, `meta_cli`, `meta_git_cli`, `meta_mcp`, `meta_project_cli`, and `meta_rust_cli`. |
| Flows | `git-kb code flows --refresh --json` | Generated entrypoint-derived flows including `meta_cli/src/main.rs::function::main`, `loop_lib/src/lib.rs::function::run`, and worktree handlers. |
| Hotspots | `git-kb code query hotspots --json --limit 10` | Top hotspots include `LockGuard.path`, `Grade.display`, `evaluate_command`, `RepoSpec.from_str`, and `SubprocessPluginManager.new`. |
| Document refs | `git-kb code refs meta_cli/src/main.rs::function::main --json` | Found textual references in completed code-intelligence/source-walk tasks. |

## Current Limits

`git-kb code doctor --json` reports:

- `unresolved_call_count`: 11517
- top unresolved reasons: `no_match`, `skip_list`, `ambiguous`, `stdlib_allowlist`
- recommendation to inspect unresolved reasons and forwarding facts before
  tuning matching behavior
- Rust has deep support; Markdown/config files are detected but not symbolized

Architecture docs should cite these health facts instead of pretending the call
graph is complete. Use code intelligence for orientation and blast-radius
checks, then verify high-risk conclusions against source.
