---
id: 019f9288-bfc3-76e3-8ab7-54f4e36da10e
slug: tasks/gha-runner-implement-metaharness-task-dispatch
title: "Implement Real Metaharness Task Dispatch"
type: task
status: active
priority: high
tags: [gha-runner, metaharness, agentic, github-actions, security, gap-hunt]
---

## Overview

Turn the shipped Metaharness scaffold into the task-bearing workflow agent layer described by the Nix flake and README. The standard GitHub runner substrate already executes workflows; this task is specifically about the optional agent step actually consuming and executing its task input.

## Observed Evidence

- `harness/.github/actions/flexnetos-runner/action.yml` exports `TASK` but runs only `echo "Running flexnetos-runner..."`.
- `harness/bin/cli.js` supports only `init`, `doctor`, version, and help.
- Neither `TASK` nor `agentic-flow` is referenced by executable harness code.
- Existing tests prove module resolution and doctor only, so arbitrary task input succeeds without work.
- The scaffolded `issue_comment` template attaches provider keys without a commenter authorization check; it must not become active in that form.

## Implementation Plan

1. Ground the intended call in the installed `@metaharness/host-github-actions` and kernel APIs, then implement a bounded non-interactive task command.
2. Define a structured input/result/error contract and use Bun from the exact Nix closure.
3. Invoke the command from the composite action; propagate exit status and emit a non-secret result artifact/summary.
4. Add actor/repository/ref trust checks before any provider credential is available.
5. Add unit, integration, and workflow-fixture tests that prove task-dependent behavior.

## Acceptance Criteria

- [ ] The composite action passes `inputs.task` to executable harness code rather than an echo-only step.
- [ ] Distinct fixture tasks produce distinct structured results; an unknown or failed task exits nonzero.
- [ ] The implementation exercises the GitHub Actions host adapter and records its host context.
- [ ] Untrusted issue comments/fork contexts cannot reach provider credentials or task execution.
- [ ] Tests fail if `TASK` becomes unused or the action stops invoking the harness.
- [ ] A safe live workflow step proves one deterministic task end to end.

## Tracking

- Beads: `lifeos-runner-implement-metaharness-dispatch-7om`
- Supersedes the functional assumption in [[tasks/gha-runner-expand-polish]]