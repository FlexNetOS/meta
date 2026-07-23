---
id: 019f2367-30ff-7f10-bd4d-4df155445e9e
slug: tasks/meta-foundation-live-proof-gitkb-parity
title: "Prove Meta GitKB foundation from live evidence"
type: task
status: completed
priority: high
tags: [foundation, gitkb, meta, frontdoor, parity]
---

# Summary

Rebuild confidence in the Meta/GitKB foundation from live evidence only. This task exists because the foundation cannot be trusted from prior claims, inferred setup, or temporary `PATH=...` prefixes.

This task governs the live proof pass for bare GitKB and Meta frontdoors, local GitKB docs parity, code intelligence, MCP behavior, and meta peer repository state. It also records every mismatch as a follow-up KB task instead of hand-waving it away.

# Hard Rules

- Use bare `git-kb` and bare `meta` for environment proof.
- Do not use `PATH=... git-kb` or `PATH=... meta` as proof of ambient setup.
- Treat `src/meta` as the meta-repo control plane, not a monorepo.
- Treat each meta peer repo as independent with its own git state.
- Every non-trivial change must start from a KB task and end with KB evidence.
- Scope KB commits to touched task documents.

# Acceptance Criteria

- [x] Prove bare `git-kb` and `meta` work from `/home/flexnetos/FlexNetOS/src/meta`.
- [x] Prove bare `git-kb` and `meta` work through `meta exec` in root plus all 14 peer contexts.
- [x] Record meta root and peer git states from live commands.
- [x] Walk every local `docs/gitkb/` file and extract commands, flags, config keys, MCP tools, workflow rules, daemon/embedding behavior, code intelligence behavior, agent harness rules, document/frontmatter/graph rules, sync/auth/recovery commands, and troubleshooting instructions.
- [x] Build an evidence table with doc file, documented item, expected behavior, live command, result, status, and related KB task.
- [x] Run live CLI help parity against installed `git-kb 0.2.12`.
- [x] Run local MCP protocol proof and record exact behavior.
- [x] Run GitKB code intelligence proof for `meta_cli/src/main.rs` and root index health.
- [x] Verify meta project list, peer remotes, peer clean state, and frontdoors from peer contexts.
- [x] Inspect `.meta.yaml`, `.gitignore`, `README.md`, `docs/`, `.kb/AGENTS.md`, `.kb/skills/`, `.codex/`, `.context/`, and the flexnetos_runner release catalog if present.
- [x] Create or update KB tasks for every mismatch, missing table, stale doc, broken frontdoor, incomplete peer setup, unsafe workflow, or undocumented manual step found in this pass.
- [x] Commit KB evidence for this task and any created gap tasks.

# Live Evidence

## 2026-07-02 Frontdoor Proof (superseded 2026-07-20)

- `command -v git-kb` returned a now-retired per-user shadow; the exact obsolete path is intentionally removed from this active document.
- `git-kb --version` returned `git-kb 0.2.12`.
- `command -v meta` returned a now-retired per-user shadow; the exact obsolete path is intentionally removed from this active document.
- `meta --version` returned `meta 0.2.22`.
- `git-kb status --json` returned head `019f2352-e7fa-7470-a09b-e96e2fd503c0`, no changes, clean `true` before this task was created.
- `meta project list --json` returned root repo `git@github.com:FlexNetOS/meta.git` and 14 peers: `agent`, `claude-plugins`, `codex-plugins`, `loop_cli`, `loop_lib`, `meta-plugins`, `meta_cli`, `meta_core`, `meta_git_cli`, `meta_git_lib`, `meta_mcp`, `meta_plugin_protocol`, `meta_project_cli`, `meta_rust_cli`.
- `meta exec -- sh -c 'pwd; command -v git-kb; git-kb --version; command -v meta; meta --version'` completed 15 contexts successfully, each resolving the then-current per-user shadows with `git-kb 0.2.12` and `meta 0.2.22`. Those shadow paths are no longer valid ownership evidence.

### 2026-07-20 strict-profile correction

- `command -v git-kb` resolves `/home/flexnetos/.nix-profile/toolbin/git-kb`; `git-kb --version` remains `0.2.12`.
- The owner requires `/home/flexnetos/.nix-profile` to be the sole installed frontdoor. Prior per-user path receipts are retained only as path-redacted historical facts and must not be restored.
- `meta exec -- git status --short --branch` completed 15 contexts successfully. Root `.` is clean but ahead of `origin/codex/clean-gitkb-state` by 1 commit. All 14 peer repos are clean and up to date with `origin/codex/preserve-meta-peer-state-20260702`.

## 2026-07-02 GitKB Workspace Behavior

- `git-kb create --type task --slug tasks/meta-foundation-live-proof-gitkb-parity ... --json` returned id `019f2367-30ff-7f10-bd4d-4df155445e9e` and staged an added document.
- `git-kb checkout tasks/meta-foundation-live-proof-gitkb-parity` failed because uncommitted created documents are not yet visible through normal checkout/list resolution.
- `git-kb status --json` then showed `tasks/meta-foundation-live-proof-gitkb-parity` as an added workspace change.
- The actual local workspace path is `.kb/workspaces/main/`, not `.kb/workspace/`; this must be considered during docs parity.

## 2026-07-02 Task Start Proof

- `git-kb commit -m "Add live foundation proof task [[tasks/meta-foundation-live-proof-gitkb-parity]]" tasks/meta-foundation-live-proof-gitkb-parity` created KB commit `019f2367-e808-7bb1-8a93-fa0f1023fc76`.
- `git-kb context --task tasks/meta-foundation-live-proof-gitkb-parity --code-refs` loaded the task plus context documents and recent KB commits.
- `git-kb graph tasks/meta-foundation-live-proof-gitkb-parity --json` returned references to `tasks/meta-system-architecture-documentation`, `tasks/meta-gitkb-docs-command-config-extraction`, `tasks/meta-gitkb-cli-live-parity-suite`, `tasks/meta-gitkb-code-intel-meta-proof-suite`, `tasks/meta-gitkb-mcp-tool-parity-suite`, and `context/immutable/architecture`.
- `git-kb checkout tasks/meta-foundation-live-proof-gitkb-parity; git-kb status --json` materialized the task under `.kb/workspaces/main` and returned `clean: true`.

## 2026-07-02 Docs Inventory

- `find docs/gitkb -type f | sort` returned 20 local GitKB docs.
- `wc -l $(find docs/gitkb -type f | sort)` returned 8,614 total lines. `docs/gitkb/cli-reference.md` is the largest file with 4,987 lines.
- Extraction commands found local live overlays already present in the docs for installed `git-kb 0.2.12`, including known mismatches with generated `0.2.6` CLI text.
- `awk` over fenced code blocks extracted documented `git-kb`, MCP, and assistant-path commands/configs from all docs.
- `rg -o 'git-kb( [a-z0-9_-]+){0,3}' docs/gitkb` extracted command surfaces including init, document operations, graph, board/view, workspace, sync/auth/remote, conflict/rebase, recovery/export, daemon/MCP/context/ready/resolve, repo/config, code intelligence, AI, plus live `sync`, `slug`, and `app`.
- Config/tool extraction found `CODEX_HOME`, `GITKB_ROOT`, `[identity]`, `[sync.remotes.*]`, `[repos]`, `[apps]`, `[code]`, `[code.repo_default_branch_map]`, `[embeddings]`, `[embeddings.index]`, `[auth]`, `[auth.api_keys]`, `[pager]`, `[hooks]`, and all 49 documented `kb_*` MCP tools.
- Per-file extraction counts proved every local doc had relevant command/config/tool/workflow content: README 6, CLI reference 220, code intelligence 49, daemon 13, documents 24, knowledge graph 20, Claude Code 10, Codex 29, installation 12, MCP setup 31, quick start 36, agent workflows 43, migration/adoption 15, team collaboration 59, index 5, agent harnesses 33, configuration 58, MCP tools 109, supported languages 22, troubleshooting 56.

## Evidence Table

| Area | Doc Source | Expected Behavior | Live Command | Result | Status | KB Task |
| --- | --- | --- | --- | --- | --- | --- |
| Frontdoors | objective / local shell | Bare `git-kb` and `meta` must be on PATH through the profile owner | `command -v git-kb; git-kb --version; command -v meta; meta --version` | Historical per-user shadows are superseded; current GitKB resolves through `/home/flexnetos/.nix-profile/toolbin` | corrected | this task |
| Peer frontdoors | objective / meta workflow | Root plus 14 peers must resolve bare frontdoors | `meta exec -- sh -c 'pwd; command -v git-kb; git-kb --version; command -v meta; meta --version'` | 15 contexts complete, all frontdoors resolved | proven | this task |
| Peer clean state | objective / meta workflow | Each independent peer state must be checked | `meta exec -- git status --short --branch` | all 14 peers clean/up-to-date; root clean and ahead by 1 local commit | proven | this task |
| CLI reference | `docs/gitkb/cli-reference.md` | Docs should match installed CLI | full `git-kb ... --help` sweep | required commands all returned help; extra families `sync`, `slug`, `app` present | proven with stale-doc gaps | [[tasks/meta-gitkb-cli-reference-0212-refresh]] |
| Pull all | team collaboration / CLI reference | Older sparse sync docs mention `pull --all` | `git-kb pull origin --all` | fails with unexpected argument `--all` | mismatch | [[tasks/meta-gitkb-cli-reference-0212-refresh]] |
| Set status | documents/team collaboration | Older docs show `git-kb set <slug> --status active` | `git-kb set tasks/meta-foundation-live-proof-gitkb-parity --status active --dry-run` | fails; installed form is `FIELD=VALUE` | mismatch | [[tasks/meta-gitkb-cli-reference-0212-refresh]] |
| Graph directions | knowledge graph | Older docs used inbound/outbound in places | `git-kb graph ... --direction inbound/outbound --json` | both fail; valid values are `out`, `in`, `both` | mismatch | [[tasks/meta-gitkb-cli-reference-0212-refresh]] |
| Conflict commands | troubleshooting/team collaboration | Older docs referenced list/resolve | `git-kb conflict list`; `git-kb conflict resolve ...` | both fail; installed commands are `show` and `accept` | mismatch | [[tasks/meta-gitkb-cli-reference-0212-refresh]] |
| Board all | CLI reference overlay | Prior overlay said `board --all` absent | `git-kb board --all --json`; `git-kb board --help` | command succeeds, help omits `--all` | inconsistent | [[tasks/meta-gitkb-cli-reference-0212-refresh]] |
| MCP tools/list | MCP setup / troubleshooting | MCP server should respond locally | raw and initialized `tools/list` through `git-kb mcp` | fresh process fails because PID 3592346 already owns MCP | unsafe/unproven | [[tasks/meta-plugin-mcp-single-owner-policy]] |
| Code index | code intelligence docs | Index source and expose graph | `git-kb code index; git-kb code stats --json; git-kb code doctor --json` | 1,429 symbols, 314 files, 2,787 resolved edges, 11,517 unresolved calls, repo discovery OK | proven with warnings | this task |
| `meta_cli` symbol map | code intelligence docs | Symbols/callers/callees/impact available | targeted `git-kb code ... meta_cli/src/main.rs` commands | 50 file symbols, 0 callers for `main`, 20 callees, 9 impact callers, 100 entrypoints, 50 flows | proven | this task |
| Workspace path | quick start / KB skill | Agents need real checkout path | `git-kb checkout ...`; inspect `.kb/skills/gitkb/SKILL.md` | installed checkout path is `.kb/workspaces/main`; skill still says `.kb/workspace` | mismatch | [[tasks/meta-gitkb-skill-workspace-path-drift]] |
| Release catalog | objective / release docs | Catalog must include release components | inspect `/home/flexnetos/FlexNetOS/src/flexnetos_runner/release/catalog.tsv` | release catalog exists and includes requested tools including meta, gitkb, codex, envctl, beads, rtk, yazelix, bun | proven | this task |

## 2026-07-02 CLI Help Parity

- A bare `git-kb` help sweep passed for every required command in the objective: root help/version, init, doctor, repair, upgrade, info, document commands, relationship/view commands, workspace commands, sync/recovery commands, integrations, context/ready/resolve, repo/config, code intelligence, and AI commands.
- The same sweep also proved live extra command families `git-kb sync --help`, `git-kb slug --help`, and `git-kb app --help`.
- Live command mismatches already documented in `docs/gitkb/cli-reference.md` remain relevant: CLI docs include generated `0.2.6` text while this checkout runs `0.2.12`; `pull --all` is not exposed; `set` uses `FIELD=VALUE`; `board --all` is not exposed; checked-out docs materialize under `.kb/workspaces/main/`.

## 2026-07-02 MCP Proof

- `timeout 8s sh -c 'printf ... tools/list ... | git-kb mcp'` returned `error: MCP server already running (PID 3592346)`.
- The initialized MCP probe also returned the same existing-server error.
- `ps -o pid,ppid,user,stat,lstart,cmd -p 3592346` showed `/home/flexnetos/FlexNetOS/usr/bin/git-kb mcp`, started Thu Jul 2 09:53:23 2026, owned by `flexnetos`.
- `.kb/.cache/mcp.pid` exists and points to the running MCP process. `git-kb daemon status` reported the GitKB daemon is not running for this KB, with repo discovery OK and 14 index roots.
- I did not use `git-kb mcp --force` because that would kill a live MCP owner from another session. The fresh MCP response requirement remains unproven and is tied to [[tasks/meta-plugin-mcp-single-owner-policy]].
- Rerun evidence: both raw `tools/list` and initialized MCP probes still returned `error: MCP server already running (PID 3592346)`. `codex mcp list` shows Codex owns `gitkb` through `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-meta` and `gitkb-yazelix` through `/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-yazelix`.

## 2026-07-02 Code Intelligence Proof

- `git-kb code index` reported `Indexed 1427 symbols from 240 files`, all 240 files unchanged, with Rust symbols plus detected zero-symbol yaml, makefile, json, markdown, toml, and bash formats.
- `git-kb code stats --json` reported 1,429 symbols, 314 files, 2,787 resolved call edges, 11,517 unresolved calls, and zero stale files.
- `git-kb code doctor --json` reported repo discovery strategy `meta`, status `ok`, 15 repos, 14 peer index roots, 1,429 Rust symbols, and recommendations to inspect unresolved calls and symbol-forwarding status.
- `git-kb code symbols --file meta_cli/src/main.rs --json --compact` returned 50 symbols. The first symbols include modules `init`, `registry`, `subprocess_plugins`, constant `VERSION`, struct `Cli`, enum `Commands`, and function `main`.
- `git-kb code callers meta_cli/src/main.rs::function::main --json` returned count `0`.
- `git-kb code callees meta_cli/src/main.rs::function::main --json` returned count `20`, including `handle_context`, `handle_init_command`, `check_and_warn_orphan`, `extract_global_flags`, `handle_command_dispatch`, `handle_plugin_command`, and help-printing functions.
- `git-kb code impact meta_cli/src/main.rs --json --compact` returned 9 impact callers.
- `git-kb code entrypoints --json` summarized 100 entrypoints: 7 binaries and 93 tests.
- `git-kb code flows --json` summarized 50 flows; top flows include `meta_git_cli` worktree/status tests and `handle_worktree_command`, and include `meta_cli/src/main.rs::function::main`.
- `git-kb code query hotspots --json --limit 10` returned hotspots headed by `meta_core/src/lock.rs::method::LockGuard.path`, `agent/src/score.rs::method::Grade.display`, and `agent/src/guard.rs::function::evaluate_command`.
- `git-kb code refs meta_cli/src/main.rs::function::main --json` returned 5 referencing documents, including this active task and completed code-intelligence/foundation tasks.

## 2026-07-02 Meta And Release Surface Proof

- `.meta.yaml` declares 14 peers under FlexNetOS SSH remotes: `loop_lib`, `meta_plugin_protocol`, `meta_core`, `meta_git_lib`, `loop_cli`, `meta_cli`, `meta_git_cli`, `meta_project_cli`, `meta_rust_cli`, `meta_mcp`, `agent`, `claude-plugins`, `codex-plugins`, and `meta-plugins`.
- `meta exec -- sh -c 'pwd; git remote -v | sed -n "1,4p"'` completed 15 contexts. Root and all 14 peers have `origin` pointing to `git@github.com:FlexNetOS/...` and `upstream` pointing to `git@github.com:gitkb/...`.
- `.kb/.gitignore` ignores `workspaces/`, so live `.kb/workspaces/main/` edits are locally ignored by the KB directory ignore file even though root `.gitignore` still lists the older `.kb/workspace/` path.
- `.codex/` contains `instructions/codex-rules.md`, `instructions/gitkb-process.md`, and 17 skill adapter entries.
- `.context/` contains `CONTEXT.md`, `VISION_PLAN.md`, and three task notes.
- `/home/flexnetos/FlexNetOS/src/flexnetos_runner/release/catalog.tsv` exists and catalogs `flexnetos_runner`, `meta`, `meta-agent`, `gitkb`, `codex`, `envctl`, `beads_rust`, `rtk-tokenkill`, `yazelix`, `yazelix-helix`, `nu_plugin`, `loop_lib`, `meta_plugin_protocol`, and `bun`.

# Related Documents

- [[tasks/meta-system-architecture-documentation]]
- [[tasks/meta-gitkb-docs-command-config-extraction]]
- [[tasks/meta-gitkb-cli-live-parity-suite]]
- [[tasks/meta-gitkb-code-intel-meta-proof-suite]]
- [[tasks/meta-gitkb-mcp-tool-parity-suite]]
- [[context/immutable/architecture]]
- [[tasks/meta-plugin-mcp-single-owner-policy]]
- [[tasks/meta-gitkb-skill-workspace-path-drift]]
- [[tasks/meta-gitkb-cli-reference-0212-refresh]]

# Completion Evidence

- Final audit `git-kb status --json` returned clean `true` at KB head `019f2372-2ec8-7120-8cc4-d563da0da143`.
- Final audit `git status --short --branch` returned a clean root worktree on `codex/clean-gitkb-state`, ahead of `origin/codex/clean-gitkb-state` by 2 local commits.
- Final audit `meta exec -- git status --short --branch` completed 15 contexts: root clean/ahead by 2, all 14 peers clean and up to date with `origin/codex/preserve-meta-peer-state-20260702`.
- Final audit `meta exec -- sh -c 'command -v git-kb; git-kb --version'` completed 15 contexts and proved bare `git-kb 0.2.12` in each context.
- Source commit `0e60540` fixed the `.kb/AGENTS.md` and `.kb/skills/gitkb/SKILL.md` command/path drift found during this proof pass.
- KB commits for this proof pass include `019f2367-e808-7bb1-8a93-fa0f1023fc76`, `019f236a-7618-7693-a983-62541453f88c`, `019f236c-1266-7eb3-b89e-db11e3d23647`, `019f2370-448a-7fc3-b7ca-695d61e345eb`, `019f2370-b23b-7900-8ca3-22e947f86b39`, and `019f2372-2ec8-7120-8cc4-d563da0da143`.
- Remaining open follow-up tasks are explicitly represented in the KB graph, especially [[tasks/meta-plugin-mcp-single-owner-policy]] for MCP singleton validation and [[tasks/meta-gitkb-cli-reference-0212-refresh]] for full `git-kb 0.2.12` CLI reference refresh.

# Progress

- 2026-07-02: Created controlling task after KB search found no active frontdoor/foundation proof task. Bare frontdoors and peer frontdoor proof passed. Docs parity, MCP proof, code intelligence proof, and gap task creation remain open.
- 2026-07-02: Ran live CLI help sweep, code-intelligence proof, peer remote proof, and release catalog proof. MCP fresh stdio proof is still unproven because a live `git-kb mcp` process already owns the KB MCP pid; force-kill was not used.
- 2026-07-02: Completed structured extraction across all 20 `docs/gitkb/` files and added the evidence table. Created [[tasks/meta-gitkb-skill-workspace-path-drift]] and [[tasks/meta-gitkb-cli-reference-0212-refresh]] for current gaps; updated [[tasks/meta-plugin-mcp-single-owner-policy]] for the live MCP owner conflict.
- 2026-07-02: Inspected `.kb/AGENTS.md`, `.kb/skills/gitkb/SKILL.md`, `.codex/instructions/`, `.context/`, `.meta.yaml`, `.gitignore`, `README.md`, architecture docs, and the flexnetos_runner release catalog. Created [[tasks/meta-kb-agents-command-path-drift]] and source commit `0e60540` for the live `git-kb`/workspace path command drift in agent instruction surfaces.
- 2026-07-02: Committed KB evidence in `019f2370-448a-7fc3-b7ca-695d61e345eb`, then marked the two implemented drift tasks completed in a follow-up KB commit.
- 2026-07-02: Reran raw and initialized MCP probes. The exact current behavior remains a singleton denial from PID `3592346`; no `--force` was used. The MCP proof command was executed and recorded, but a fresh tools/list response remains unproven by design and is tracked by [[tasks/meta-plugin-mcp-single-owner-policy]].
- 2026-07-02: Task completed after final audit verified clean KB state, clean source state, peer clean state, frontdoor proof across all 15 contexts, and explicit follow-up KB tasks for remaining gaps.
