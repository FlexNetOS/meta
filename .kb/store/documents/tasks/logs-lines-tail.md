---
id: 019e963e-8386-7d61-a947-0cca333b3667
slug: tasks/logs-lines-tail
title: "lane logs -n/--lines N (tail last N matching records)"
type: task
status: active
priority: medium
tags: [feature, cli, logs]
---

## Overview
Add a `-n`/`--lines N` flag to `lane logs` that prints only the last N access-log
records matching the active domain filter (the tail), instead of streaming the whole
file from the start. Standard `tail -n` affordance. Full spec:
`_workspace/01_intent-analyst_spec.md` (in the `feat-logs-lines` worktree).

Branch `feat-logs-lines` is from `origin/main` and does NOT contain the `--json`
flag (separate open PR #6). Implement against the human render path only; keep
forward-compatible (do not require/assume `--json`).

## Goals
- `lane logs -n N` prints the last N records after the domain filter is applied,
  formatted via the existing `format_log_line`, then exits.
- `lane logs -n N --follow` prints last N matching first, then streams new matching
  records (`tail -n N -f`).
- N validated as a positive integer; bounded memory (ring buffer ≤ N).
- No regression when `--lines` is absent.

## Key decisions
- N semantics: tail of the MATCHED set (filter first, then last N, oldest→newest).
- N validation: N >= 1. N=0 and N<0 rejected.
- N > available matching lines → print all (no error/padding).
- `--lines` + `--flush` → rejected.
- Exact error strings (mirror `validate_logs_flags` style):
  - `--flush cannot be used with --lines`
  - `--lines must be a positive integer`

## Affected areas
- `src/cli/logs.rs` — tail collection + extended `validate_logs_flags`, in-module tests.
- `src/cli/mod.rs` — `LogsArgs.lines: Option<i64>` with `#[arg(short = 'n', long)]`
  (`-f` already = `--follow`). i64 validation per port-validation convention.

## Acceptance criteria
- [ ] `-n`/`--lines <N>` appears in `logs --help`; absent `--lines` still works.
- [ ] Tail returns exactly last N matching records, oldest→newest, non-matching excluded (unit).
- [ ] `lane logs -n 2` prints last 2 matching and exits 0 (no hang).
- [ ] Filter + lines: only filter-matching lines counted toward N.
- [ ] N > available → prints all, no error.
- [ ] Missing file → existing `No logs yet...` message, exit 0; empty file → nothing, exit 0.
- [ ] Fewer-than-N matching → prints just those.
- [ ] `lane logs -n 0` exits non-zero, msg contains `--lines must be a positive integer`.
- [ ] `lane logs -n -1` rejected with same `--lines must be a positive integer`.
- [ ] `lane logs --flush -n 3` exits non-zero with `--flush cannot be used with --lines` (unit + binary).
- [ ] `lane logs -n 2 --follow`: prints last 2 first, then streams appended record after.
- [ ] No regression: existing logs tests pass; `logs`/`--follow`/`--flush` unchanged without `--lines`.
- [ ] Bounded memory: helper retains ≤ N lines (code inspection).
- [ ] `cargo fmt --check` / `clippy -D warnings` / `cargo test` green.

## Context
- Spec: `_workspace/01_intent-analyst_spec.md`
- Source of truth for current behavior: `src/cli/logs.rs`, `src/cli/mod.rs` (LogsArgs).
- Crew: feeds solution-architect → rust-implementer ⇄ verification-engineer + rust-native-guardian.
