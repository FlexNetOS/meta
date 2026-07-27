---
id: 019f9288-c341-7e03-9197-ac94469997af
slug: tasks/meta-reindex-promoted-runner-peer
title: "Converge Path Maps and Reindex the Promoted Runner Peer"
type: task
status: active
priority: medium
tags: [meta, gitkb, gha-runner, path-authority, code-intelligence, gap-hunt]
---

## Overview

Finish the Meta-root promotion across branch maps, code intelligence, and repository-scoped Codex path rules so the physical peer move has one authority everywhere.

## Observed Evidence

- Meta PR #114 removed `path: src/flexnetos_runner`, so discovery correctly finds `/home/flexnetos/meta/flexnetos_runner`.
- `.kb/config.toml [code.repo_default_branch_map]` still keys `src/flexnetos_runner = main`.
- `git kb code detect-default-branches --dry-run` reports root `flexnetos_runner main (new)`.
- `git kb code symbols --path "*flexnetos_runner*" --count` returns zero while code doctor lists the root as an index root.
- Canonical `.codex/config.toml` and permission blueprint still name the retired source path.

## Implementation Plan

1. Update active Meta GitKB and canonical Codex path maps to the root execution-peer exception.
2. Audit tracked operational docs/config for authority-bearing old paths, distinguishing archives/evidence.
3. Prune stale branch symbols and index the promoted repository at `main`.
4. Add a parity check comparing `.meta.yaml` discovered paths with branch and permission maps.

## Acceptance Criteria

- [ ] No active branch map or Codex permission rule names `/home/flexnetos/meta/src/flexnetos_runner`.
- [ ] Default-branch detection reports root `flexnetos_runner` as configured/unchanged.
- [ ] A known Rust symbol from `runner-cli` resolves through GitKB under the root path.
- [ ] Code doctor lists the root peer and no stale old-path files/symbols remain.
- [ ] A deterministic check fails when a Meta peer move is not reflected in authority-bearing maps.

## Tracking

- Beads: `lifeos-meta-reindex-promoted-runner-peer-o77`
- Promotion source: [[tasks/flexnetos-runner-canonical-promotion]]