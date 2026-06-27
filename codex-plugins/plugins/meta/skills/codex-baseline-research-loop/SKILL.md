---
name: codex-baseline-research-loop
description: Use when researching or upgrading the FlexNetOS Codex baseline from official Codex docs, Codex ecosystem repositories, or meta/envctl runtime evidence.
---

# Codex Baseline Research Loop

Use this skill to keep the meta Codex baseline current without importing unvetted ecosystem noise.

## Source order

1. Current local evidence: `codex --version`, `$CODEX_HOME/config.toml`, `codex features list`, `codex plugin list`, `codex mcp list`, `envctl --json auto-detect`, and `rtk meta git status`.
2. Official OpenAI Codex docs/manual for GitHub Action, permissions, subagents, hooks, plugins, MCP, and non-interactive execution.
3. Community repositories only as pattern sources:
   - `RoggeOhta/awesome-codex-cli` for ecosystem survey and candidate discovery.
   - `Yeachan-Heo/oh-my-codex` for workflow-loop, worktree, doctor/smoke, hook, and durable-state ideas.

## Loop

1. Cross-reference every candidate against FlexNetOS invariants:
   - meta is a workspace of independent git repos;
   - strict upgrade only, never rollback-first;
   - preserve user-owned dirty state;
   - commit/push/PR every completed chunk.
2. Prefer native Codex primitives before third-party runtime layers:
   - permission profiles before ad hoc shell allowlists;
   - `.codex/agents/*.toml` before large external agent catalogs;
   - `codex-action` for CI review/checks;
   - envctl-generated global config for persistent baseline state;
   - plugin skills for reusable workflow instructions.
3. Classify each idea as `implement-now`, `defer`, `reject`, or `document-only` with evidence.
4. Validate with TOML/JSON parsing, Codex CLI list commands, envctl detect/verify/lock, and workflow syntax checks when available.
5. Store ICM progress for significant upgrades.

## Default upgrade candidates

- Add/update read-only and workspace-edit permission profiles with network allowlists and env-file deny rules.
- Add focused custom agents: `pr_explorer`, `reviewer`, `docs_researcher`, and `codex_baseline_researcher`.
- Keep subagent `max_threads = 6`, `max_depth = 1` unless a concrete workflow needs deeper recursion.
- Add GitHub Action review workflow using `openai/codex-action@v1` with read-only sandbox, `drop-sudo`, trusted event boundaries, structured output, and artifact capture.
- Add a durable research-loop prompt that keeps official docs primary and community repos secondary.
