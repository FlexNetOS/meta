---
id: 019f5325-ea4d-7d30-93e3-2a99d40036dc
slug: codex-compact-lifecycle-hooks-disabled-in-lifeos-a
title: "Codex compact lifecycle hooks disabled in LifeOS and nu_plugin sessions"
type: incident
status: draft
priority: medium
---

# Overview

The user reported that the active Codex sessions rooted at
`/home/flexnetos/meta/src/lifeos` and `/home/flexnetos/meta/src/nu_plugin` were
not compacting like Claude sessions.

## Findings

- Live global config is `/home/flexnetos/.codex/config.toml`.
- It currently contains `hooks = false`.
- Live `/home/flexnetos/.codex/hooks.json` contains `PreCompact` and
  `PostCompact` entries, but those entries cannot run while the `hooks` feature
  is disabled.
- Codex feature inspection reports `remote_compaction_v2` enabled and
  `local_thread_store_compression` enabled.
- Saved rollout evidence shows backend compaction did occur:
  - LifeOS session `019f52be-32c7-7c03-be85-a389e8814e68` compacted at
    `2026-07-11T21:40:12.803Z`.
  - Nu plugin session `019f5076-73bd-7c02-85e8-28448685d6ca` compacted at
    `2026-07-11T10:17:10.332Z` and again at `2026-07-11T19:26:23.867Z`.

## Root Cause

The sessions are compacting at the Codex backend level, but the configured
Codex lifecycle hooks are disabled globally. The visible compact-hook
checkpoint/status behavior therefore does not run.

## Acceptance Criteria

- [x] Archive `/home/flexnetos/.codex/config.toml` before mutation.
- [x] Enable the global Codex `hooks` feature without changing unrelated
  feature flags.
- [x] Verify config parsing and effective feature state.
- [x] Verify the existing `PreCompact` and `PostCompact` hook definitions are
  still present.
- [x] Record the resulting archive and verification evidence.

## Resolution Evidence

- Archive:
  `/home/flexnetos/.codex/config-backups/20260711T214727Z/config.toml`
- Mutation command: `codex features enable hooks`
- Effective config: `/home/flexnetos/.codex/config.toml:92` is now
  `hooks = true`.
- `codex features list` reports:
  - `hooks stable true`
  - `remote_compaction_v2 stable true`
  - `local_thread_store_compression under development true`
- `codex doctor --json --summary` reports `config.load` status `ok` and
  `config.toml parse` `ok`.
- `/home/flexnetos/.codex/hooks.json` still contains both `PreCompact` and
  `PostCompact` entries routed to the envctl Codex harness hook.

Existing processes must be restarted or resumed as new Codex processes to load
the changed global feature flag. The saved rollout files prove that backend
compaction was already occurring in both named sessions; the missing behavior
was the disabled lifecycle-hook execution.

## Concurrency Note

The host had another Codex writer active during verification. The archived
snapshot was created before the explicit `codex features enable hooks`
command, but it already contains `hooks = true`; its comparison with the live
file shows only unrelated `model` and `model_reasoning_effort` changes. Keep
the archive for recovery, but do not treat it as a byte-for-byte snapshot of
the earlier `hooks = false` state.
