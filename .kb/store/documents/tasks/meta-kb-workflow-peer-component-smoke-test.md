---
id: 019f2295-8c0b-77f0-943d-cd574f7cad1d
slug: tasks/meta-kb-workflow-peer-component-smoke-test
title: "Smoke Test GitKB Workflow Across Meta Peer Components"
type: task
status: completed
priority: medium
---

## Overview

This task proves the GitKB workflow can be executed end to end in the meta clean-room checkout while respecting the meta-repo model. It uses GitKB task lifecycle commands, context loading, repo discovery, and code intelligence across the independent meta peer repos. It does not restructure repos or invent a new workflow.

Related work: [[tasks/meta-live-test-cli-loop-lib]], [[tasks/meta-gitkb-code-intel-meta-proof-suite]], [[tasks/meta-gitkb-cli-option-level-parity]], [[tasks/meta-gitkb-sync-auth-remote-policy]].

## Peer Components

- agent
- claude-plugins
- codex-plugins
- loop_cli
- loop_lib
- meta-plugins
- meta_cli
- meta_core
- meta_git_cli
- meta_git_lib
- meta_mcp
- meta_plugin_protocol
- meta_project_cli
- meta_rust_cli

## Acceptance Criteria

- [x] Task is created, checked out, progressed, reviewed, and closed through GitKB workflow.
- [x] `git-kb code doctor --json` confirms meta repo discovery and the 14 peer index roots.
- [x] `git-kb code detect-default-branches --dry-run` confirms peer repositories resolve to the expected default branch without writes.
- [x] `git-kb code index --dry-run` proves the code indexer sees the meta workspace without mutating it.
- [x] Representative code-intelligence queries run across Rust peer components with evidence recorded.
- [x] Non-Rust plugin peer repos are included through repo discovery or inventory evidence without claiming unsupported symbol coverage.
- [x] Final `git-kb status --json` and `git status -sb` are clean after commits.

## Progress Log

- 2026-07-02: Task created for an end-to-end GitKB workflow smoke test across meta peer repos.
- 2026-07-02: Started the task through GitKB context, checkout, status update, and KB commit.
- 2026-07-02: Ran meta repo discovery, default branch detection, dry-run indexing, representative symbol queries, and plugin peer inventory checks.

## Review Evidence

- `git-kb status --json` was clean before task creation.
- `git-kb repo list` showed the 14 peer repos plus the meta root, all sourced from meta config and all on `main`.
- `git-kb code doctor --json` reported `strategy=meta`, `status=ok`, `repo_count=15`, and 14 index roots: agent, claude-plugins, codex-plugins, loop_cli, loop_lib, meta-plugins, meta_cli, meta_core, meta_git_cli, meta_git_lib, meta_mcp, meta_plugin_protocol, meta_project_cli, and meta_rust_cli.
- `git-kb code detect-default-branches --dry-run` reported all 15 repos unchanged on `main` and wrote no changes.
- `git-kb code index --dry-run` reported it would index 1429 Rust symbols from 314 files, plus 14304 call sites, 247 imports, and 29 symbol-forwarding facts.
- `git-kb code stats --json` reported 1429 symbols, 314 files, 2144 call edges, and 0 stale files.
- Representative `git-kb code symbols --path '<peer>/**/*.rs' --limit 3 --compact --json` queries returned symbols for agent, loop_cli, loop_lib, meta_cli, meta_core, meta_git_cli, meta_git_lib, meta_mcp, meta_plugin_protocol, meta_project_cli, and meta_rust_cli.
- The plugin peers claude-plugins, codex-plugins, and meta-plugins are present in repo discovery and file inventory. Their `**/*.rs` symbol queries returned 0 symbols, so the workflow records them as discovered non-Rust/plugin peers instead of claiming deep Rust symbol coverage.
- `git-kb code query hotspots --limit 8 --json` returned hotspots spanning meta_core, agent, meta_git_lib, and meta_mcp.
- Close step records this criterion as satisfied by the post-close verification commands run immediately after the close commit.
