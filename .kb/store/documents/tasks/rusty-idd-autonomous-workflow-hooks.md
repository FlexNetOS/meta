---
id: 019eec67-2821-7661-8e52-75e3e4da4fc7
slug: tasks/rusty-idd-autonomous-workflow-hooks
title: "Add Rusty IDD autonomous workflow pre/post hooks"
type: task
status: active
priority: high
tags: [rusty-idd, codex, hooks, autonomous-workflow]
---

Implement repo-local Codex pre and post hooks that force agents through the full autonomous Rusty IDD workflow: recall, worktree from develop, graph plan-context, OpenSpec readiness, task claim/checkpoint, validation/evidence, PR feature branch push to develop, and auto-merge. Scope: rusty-idd Codex environment surfaces and tests/docs only.