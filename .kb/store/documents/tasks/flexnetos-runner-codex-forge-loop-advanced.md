---
id: 019f0917-8e8b-7f91-8b23-c1f13e54dbd2
slug: tasks/flexnetos-runner-codex-forge-loop-advanced
title: "Upgrade flexnetos_runner Codex forge-loop from deep research"
type: task
status: completed
priority: medium
---

## Overview

Upgrade `flexnetos_runner`'s repo-local `.codex` forge-loop using the required OpenAI Codex docs and community target repositories. The goal is to mine the requested sources into concrete `.codex` loop surfaces, add machine guards, and enable auto-compaction continuity for long-running local/action/nested Codex sessions.

## Acceptance Criteria

- [x] Required research targets are exhausted into source, application, and guard evidence.
- [x] `.codex` forge-loop enables auto-compaction/continuity for long sessions.
- [x] Codex invocation/config/docs/tests reflect the upgraded loop.
- [x] Validation gates pass.
- [x] Changes are committed, pushed, and PR opened.

## Completion Evidence

- Research report: `flexnetos_runner/docs/forge-loop/deep-research-exhaustion-2026-06-27.md`.
- Auto-compaction surfaces: `.codex/config.toml`, `.codex/prompts/compact-forge-loop.md`, `codex_invocation()`, `.github/workflows/codex-forge-loop.yml`, compact hooks, structured output schema.
- Machine guards: `fxrun forge-loop components-audit --strict`, `target-mining-audit --strict`, `docs-drift --json`, and runner-cli unit tests.
- Validation run 2026-06-27: TOML/JSON/YAML parse, 35 forge-loop tests, components audit, target mining audit, docs drift, cargo fmt, full workspace tests, clippy, and cargo audit.
