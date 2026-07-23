---
id: 019f2159-5ed9-7c03-abed-1dca46a3a2bb
slug: tasks/meta-worktree-hook-trust-boundary
title: "Define trust boundary for meta worktree hooks"
type: task
status: completed
priority: medium
tags: [meta_git_lib, hooks, safety]
---

# Summary

Worktree hook execution should be documented and guarded as trusted configuration execution.

# Evidence

The initial-10 source walk found `meta_git_lib/src/worktree/hooks.rs` executing hook commands from `.meta` configuration through `sh -c` with JSON stdin. This is intentional automation power, but the trust boundary should be explicit for agents and users working from shared meta configs.

# Acceptance Criteria

- Hook docs/rules state that configured hooks execute shell commands and require trusted workspace configuration.
- Dry-run and failure behavior are documented.
- Tests or docs checks cover the hook execution contract where practical.
