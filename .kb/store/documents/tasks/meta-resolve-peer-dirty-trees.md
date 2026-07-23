---
id: 019f21bc-de4a-70d2-ac8d-dbc11ca30e17
slug: tasks/meta-resolve-peer-dirty-trees
title: "Resolve dirty-tree state across meta peer repos"
type: task
status: completed
priority: high
---

# Summary
Several meta peer repos are functional and aligned to FlexNetOS origin/main, but still have pre-existing dirty working tree state from generated Claude/workflow/source edits. Resolve or intentionally commit/ignore these changes repo-by-repo without reverting user work.

# Evidence
- Historical evidence for this task is now stale. A fresh `meta git status --short --sequential` on 2026-07-03 shows most peer repos are clean.
- Current live status:
  - clean: `agent`, `claude-plugins`, `codex-plugins`, `loop_cli`, `loop_lib`, `meta-plugins`, `meta_cli`, `meta_core`, `meta_git_cli`, `meta_git_lib`, `meta_mcp`, `meta_plugin_protocol`, `meta_project_cli`, `meta_rust_cli`, `teri`
  - dirty: root `meta` repo and `envctl`
- Root `meta` repo dirt is a scoped source change in `.meta.yaml` that adds peer registrations for `envctl` and `teri`.
- `envctl` dirt is not random scaffold noise. It contains active source/config/runtime work:
  - `.codex/config.toml`
  - `.gitignore`
  - `crates/cli/src/main.rs`
  - `crates/engine/src/catalog.rs`
  - `crates/engine/src/lib.rs`
  - generated/KB artifacts under `.kb/store/` and `docs/generated/`
- `envctl` KB state is clean, and the live task queue there points at active/next work such as:
  - `tasks/catalog-runtime-closure-and-toolchain-proof`
  - `tasks/envctl-codex-mcp-runtime-import`
- Related meta-owned follow-up tasks already exist for the remaining intentional dirt:
  - `register-envctl-peer-and-refresh-envctl-kb`
  - `register-teri-peer-with-meta`

# Acceptance Criteria
- [x] Inspect each dirty peer repo independently.
- [x] Classify each change as intended source change, generated scaffold, or removable artifact.
- [x] Commit intended changes to the correct peer repo or remove/ignore generated artifacts with explicit approval.
- [x] Verify `git status --short` is clean or intentionally documented for each of the 14 peers.

# Current Classification

## Clean peers

The original broad dirty-tree concern is resolved for the majority of the
workspace. The following peers are currently clean:

- `agent`
- `claude-plugins`
- `codex-plugins`
- `loop_cli`
- `loop_lib`
- `meta-plugins`
- `meta_cli`
- `meta_core`
- `meta_git_cli`
- `meta_git_lib`
- `meta_mcp`
- `meta_plugin_protocol`
- `meta_project_cli`
- `meta_rust_cli`
- `teri`

## Remaining intentional dirt

### Root meta repo

- file: `.meta.yaml`
- classification: intended source change
- owner tasks:
  - `register-envctl-peer-and-refresh-envctl-kb`
  - `register-teri-peer-with-meta`

### envctl

- classification: active source/config/runtime work plus KB/generated artifacts
- owner tasks:
  - `tasks/catalog-runtime-closure-and-toolchain-proof`
  - `tasks/envctl-codex-mcp-runtime-import`

## Conclusion

This task is no longer a blanket cleanup of many peers. It narrowed first to
two intentional dirty surfaces and then to one: `envctl`.

The root `meta` repo dirt was resolved by committing the peer-registration
change in `.meta.yaml`. The remaining `envctl` dirt is intentionally documented
and owned by active envctl tasks rather than by this meta workspace hygiene
task:

- `tasks/catalog-runtime-closure-and-toolchain-proof`
- `tasks/envctl-codex-mcp-runtime-import`

That satisfies the requirement to classify and intentionally account for every
dirty peer without reverting user work or force-cleaning active source changes.
