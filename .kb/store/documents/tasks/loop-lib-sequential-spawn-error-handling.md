---
id: 019f2159-5eab-7631-9989-e6c12f93176c
slug: tasks/loop-lib-sequential-spawn-error-handling
title: "Return errors instead of panicking in loop_lib sequential spawn path"
type: task
status: completed
priority: high
tags: [loop_lib, errors, verification]
---

# Summary

The sequential execution path in loop_lib should return structured errors instead of panicking when process spawn or wait fails.

# Evidence

The initial-10 source walk found `loop_lib/src/lib.rs` using `spawn().with_context(...).expect("Failed to execute command")` and `child.wait().expect("Failed to wait on child process")` in the sequential path, while other execution paths return `Result`/`CommandResult`-style failures.

# Acceptance Criteria

- Spawn and wait failures in sequential execution are returned through the public `Result` path without panic.
- Existing capture and dry-run behavior remains unchanged.
- Focused tests cover a failing command/spawn case for sequential `run_commands`.
