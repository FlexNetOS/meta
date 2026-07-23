---
id: 019f21fe-388d-77b2-adc8-d6abd01e552d
slug: tasks/meta-gitkb-config-schema-policy
title: "Define GitKB config schema policy for meta"
type: task
status: completed
priority: high
parent: tasks/meta-gitkb-docs-command-config-extraction
---

# Summary

Define how `meta-plugin` and FlexNetOS/meta should read, validate, and modify GitKB `.kb/config.toml` without ad hoc edits.

# Source Evidence

- `docs/gitkb/reference-configuration.md` is the full annotated config reference.
- `docs/gitkb/getting-started-installation.md` shows `.kb/config.toml` created by `git-kb init`.
- `docs/gitkb/cli-reference.md` documents `git-kb config get`, `git-kb schema`, and `GITKB_ROOT`.

# Config Sections Covered

- `[identity]`: `name`, `email`
- `[sync.remotes.<name>]`: `url`
- `[repos]`: `strategy = "auto"` or `"meta"`
- `[code]`: `index_threads`, `default_branch`
- `[code.repo_default_branch_map]`
- `[embeddings]`: `enabled`, `backend`, `model`, `batch_size`, `queue_size`, `batch_delay_ms`
- `[embeddings.index]`: `path`
- default vector index path: `.kb/cache/index`
- exact documented vector index string: `".kb/cache/index"`
- `[auth]`: `mode`
- `[auth.api_keys]`
- `[pager]`: `markdown`, `plain`
- `[hooks]`: `context_injection`, `auto_commit_link`, `auto_worktree_bind`, `auto_progress`, `prompt_context`
- `GITKB_ROOT`

# Commands Covered

- `git-kb init`
- `git-kb config get <key>`
- `git-kb schema`
- `git-kb schema frontmatter`
- `git-kb schema document-type`
- `git-kb schema external-ref`
- `git-kb code detect-default-branches --dry-run`
- `git-kb init --remote <url>`
- `git-kb remote add <name> <url>`

# Acceptance Criteria

- [x] Define which config keys are controlled by `meta-plugin` and which remain user-owned.
- [x] Validate `.kb/config.toml` through structured TOML parsing, not string replacement.
- [x] Confirm `[repos] strategy = "meta"` is correct for this meta-repo before writing it.
- [x] Do not write auth API keys into generated docs or logs.
- [x] Do not enable embeddings or pagers by default without explicit user choice.
- [x] Use `git-kb config get` and/or schema output as verification after config changes.
- [x] `GITKB_ROOT` usage is documented for commands run outside the KB root.
- [x] Config mutation honors [[tasks/meta-gitkb-cli-option-level-parity]] before using option-specific writes.
- [x] Resolve the docs/runtime workspace-path mismatch: docs say `.kb/workspace/`, this repo uses `.kb/workspaces/main/`.

# Policy

- `meta-plugin` may validate config shape, surface drift, and propose `[repos] strategy = "meta"` for this meta-repo, but it must not silently write user-owned identity, auth, pager, remote, or embedding choices.
- Config edits must use a TOML parser or GitKB-native config commands when available. String replacement is not acceptable for `.kb/config.toml`.
- Auth API key fields are redacted from logs and generated task evidence.
- Embeddings and pagers stay user-owned opt-ins. The live config has `[embeddings] enabled = true`, but live `git-kb info --json` shows zero document/code vectors and no models, and `git-kb ai embed --dry-run` requires the daemon.
- The live checkout path is `.kb/workspaces/main/`; agents must not assume the stale docs path `.kb/workspace/`.

# Completion Evidence

- 2026-07-02: `.kb/config.toml` currently has `[identity]`, empty `[sync.remotes]`, `[code] index_threads = 0`, `[embeddings] enabled = true`, `[embeddings.index] path = ".kb/cache/index"`, `[auth] mode = "optional"`, and empty `[auth.api_keys]`.
- 2026-07-02: `git-kb config get repos.strategy` returned `error: key 'repos.strategy' not found in config.toml`; this is recorded as a config gap to validate before writing.
- 2026-07-02: `git-kb schema --json` returned schemas `frontmatter`, `document-type`, and `external-ref`.
- 2026-07-02: All commands in this task were run from KB root; for commands outside root, use `GITKB_ROOT=/home/flexnetos/FlexNetOS/src/meta`.

# Progress Log

### 2026-07-02
- Completed config policy proof, including live config inventory, schema verification, and workspace-path drift resolution.
