---
id: 019f80db-43f4-7730-8671-f8c061006f42
slug: tasks/envctl-github-worktree-consolidation
title: "Consolidate Envctl worktrees pull requests and branches"
type: task
status: active
priority: critical
---

## Objective

Integrate all valid Envctl worktree changes, resolve and merge every open
Envctl pull request through the FlexNetOS SSH organization account, and leave
only approved long-lived branches and clean required worktrees.

## Acceptance criteria

- Every dirty Envctl worktree is either integrated through its owning branch
  and pull request or is shown invalid by repository-owned verification.
- Every open Envctl PR is reproduced locally, conflict-resolved semantically,
  checked, merged, and confirmed closed.
- Merged feature branches and completed worktrees are safely removed; only
  existing approved long-lived branches remain and track origin.
- Agent-env ownership, hook policy, lock discipline, no-C boundary, and
  required gates remain intact.
- Final SSH remote, branch, worktree, open-PR, and clean-tree evidence is
  recorded before completion.
