---
id: 019f2168-bd03-7832-91cd-fbfc3445629c
slug: tasks/agent-score-hook-log-guard-effectiveness
title: "Implement guard effectiveness scoring from hook logs"
type: task
status: completed
priority: medium
tags: [agent, hooks, metrics]
---

# Summary

Implement the guard-effectiveness scoring metric from actual hook log data instead of leaving the score as a placeholder.

# Source Evidence

- `agent/src/score.rs` defines guard-effectiveness fields (`destructive_blocked`, `destructive_allowed`) but labels Metric 5 as a placeholder that requires hook logs.
- `agent/src/score.rs` computes guard effectiveness from those counters when present, but the collection path still needs hook-log parsing.
- The repeat-14 hook audit found this while reading the `agent` guard hook implementation and score model.

# Acceptance Criteria

- Define the hook log source and schema used for guard-effectiveness scoring.
- Parse blocked/allowed destructive-command outcomes from hook logs without requiring source-tree mutation.
- Add tests covering no-log, all-blocked, all-allowed, and mixed outcomes.
- Keep fail-open hook behavior separate from metric collection semantics.
