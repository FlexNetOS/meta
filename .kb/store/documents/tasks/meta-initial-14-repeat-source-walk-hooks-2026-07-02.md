---
id: 019f2165-daf6-7a12-9636-0e735a8945dd
slug: tasks/meta-initial-14-repeat-source-walk-hooks-2026-07-02
title: "Repeat source walk for initial 14 meta repos and hooks"
type: task
status: completed
priority: high
tags: [meta, source-walk, hooks, gitkb, memory]
---

# Summary

Repeat the manual source walk for the initial 14 meta repos at every depth and every tracked file, find hook surfaces, add any newly needed GitKB tasks, and save key findings to Codex memory as progress is made.

# Scope

Initial 14 repos: agent, claude-plugins, codex-plugins, loop_cli, loop_lib, meta-plugins, meta_cli, meta_core, meta_git_cli, meta_git_lib, meta_mcp, meta_plugin_protocol, meta_project_cli, meta_rust_cli.

# Constraints

- Preserve the upstream mirror source trees.
- Treat each child repo as an independent git repository.
- Add only evidence-backed KB tasks.
- Explicitly locate hooks: git hooks, workflow hooks/dispatches, lifecycle hooks, and plugin/agent hook entrypoints.
- Save concise key findings to memory as progress is made.

# Completion Evidence

Completed the repeat source walk and hook audit for the initial 14 peer repos listed in scope. The initial 10 source repos had already been manually walked in the immediately preceding repeat task (`tasks/meta-initial-10-repeat-source-walk-2026-07-02`); this pass rechecked their hook-bearing surfaces and fully read the four added peer repos (`agent`, `claude-plugins`, `codex-plugins`, `meta-plugins`) plus the root hook/workflow files.

# Hook Inventory

- Root tracked git hooks: `.githooks/commit-msg`, `.githooks/pre-commit`, and `.githooks/pre-push`.
- Root workflow hooks/triggers: `.github/workflows/ci.yml`, `.github/workflows/on-child-update.yml`, `.github/workflows/on-push-main.yml`, `.github/workflows/release.yml`, and `.github/workflows/semantic-pr-title.yml`.
- Child update dispatch: `.github/workflows/on-child-update.yml` listens for `repository_dispatch` type `child-repo-updated`, creates a sync branch/PR, and auto-merges when possible.
- Release dispatch: `.github/workflows/on-push-main.yml` sends `repository_dispatch` type `release-tagged`; `.github/workflows/release.yml` also accepts that dispatch and publishes artifacts, crates, Discord notification, and Homebrew tap updates.
- Agent hook: `agent/README.md`, `agent/.claude/agent-guard.toml`, and `agent/src/guard.rs` define the Claude `PreToolUse` guard behavior for Bash and path tools.
- Claude integration generation: `meta_cli/src/init.rs` generates Claude `SessionStart` and `PreCompact` hooks that run `meta context 2>/dev/null`, and a Bash `PreToolUse` hook that runs `agent guard`.
- Codex plugin hooks: `codex-plugins/plugins/gitkb/hooks/hooks.json` wires `SessionStart`, `UserPromptSubmit`, Bash `PreToolUse`, Bash `PermissionRequest`, and Bash `PostToolUse` to `git-kb hook codex`.
- Worktree lifecycle hooks: `meta_git_cli/src/commands/worktree/create.rs`, `remove.rs`, and `prune.rs` call `meta_git_lib/src/worktree/hooks.rs`, which reads `.meta` `worktree.hooks.post-create`, `post-destroy`, and `post-prune` command strings and sends JSON payloads on stdin.
- No tracked `.git/hooks` template directory was found in the peer source trees.

# Tasks Routed

- Existing `tasks/meta-worktree-hook-trust-boundary` covers the `.meta` worktree hook command trust boundary.
- Existing `tasks/meta-verification-parity` covers local hook, CI, and release verification parity.
- Existing `tasks/meta-command-surface-docs-reconciliation` continues to cover stale generated/docs command surfaces. The `meta context` Claude hook was verified as a real installed command, so no new task was needed for it.
- New `tasks/agent-score-hook-log-guard-effectiveness` records the source-backed gap that `agent/src/score.rs` has a guard-effectiveness metric placeholder requiring hook-log parsing.

# Memory

Saved key findings during progress to `/home/flexnetos/.codex/memories/extensions/ad_hoc/notes/2026-07-02-meta-repeat-14-progress.md`.
