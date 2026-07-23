---
id: 019f2170-583c-78b2-bff5-3a3d74a11774
slug: tasks/meta-initial-14-alignment-code-intel-prep-2026-07-02
title: "Repeat initial 14 alignment audit and prepare code intelligence"
type: task
status: completed
priority: high
tags: [meta, source-walk, alignment, code-intelligence, memory]
---

# Summary

Repeat the initial-14 meta repo source walk and create a task for every document or code source that is not aligned or is out of sync. Preserve the clean upstream mirror while preparing command evidence for `meta exec init` and GitKB code-intelligence usage.

# Scope

Initial 14 peer repos: `agent`, `claude-plugins`, `codex-plugins`, `loop_cli`, `loop_lib`, `meta-plugins`, `meta_cli`, `meta_core`, `meta_git_cli`, `meta_git_lib`, `meta_mcp`, `meta_plugin_protocol`, `meta_project_cli`, and `meta_rust_cli`.

# Constraints

- Treat every peer as an independent git repository.
- Do not mutate source files during this audit.
- Add or update GitKB tasks for every source-backed alignment drift found.
- Save key findings to Codex memory as progress is made.
- Prepare, but do not blindly execute destructive or setup commands, for `meta exec init` and GitKB code-intelligence workflows.

# Progress

- Created this task before the repeat walk.
- Loaded required GitKB context and reviewed the task board.
- Re-inventoried all 14 peer repos from `meta project list --recursive --json` and `git -C <repo> ls-files`.
- Ran targeted alignment searches across root docs, root Claude assets, workflows, hooks, and all 14 peer repos.
- Ran GitKB code-intelligence prep commands:
  - `/home/flexnetos/FlexNetOS/usr/bin/git-kb code doctor --json`
  - `/home/flexnetos/FlexNetOS/usr/bin/git-kb code index`
  - `/home/flexnetos/FlexNetOS/usr/bin/git-kb code symbols --json`
  - `/home/flexnetos/FlexNetOS/usr/bin/git-kb code impact meta_cli/src/main.rs --json`
- Checked `meta exec --help`, `meta init --help`, and live `meta --help`.
- Accidental prep finding: `/home/flexnetos/FlexNetOS/usr/bin/meta init claude --help` executed init/merge behavior instead of printing help; the transient `.claude/settings.json` source mutation was restored immediately.

# Alignment Tasks Added

- `tasks/meta-root-claude-meta-worker-jsons-drift`
- `tasks/meta-root-claude-code-intelligence-command-drift`
- `tasks/meta-root-claude-settings-hook-command-drift`
- `tasks/meta-cli-claude-meta-exec-ordered-drift`
- `tasks/meta-cli-claude-meta-safety-ordered-drift`
- `tasks/meta-cli-claude-git-setup-ssh-drift`
- `tasks/meta-cli-claude-meta-plugins-command-discovery-drift`
- `tasks/meta-readme-command-plugin-discovery-drift`
- `tasks/meta-docs-plugin-discovery-location-drift`
- `tasks/meta-docs-architecture-workspace-version-drift`
- `tasks/meta-git-cli-help-include-only-drift`
- `tasks/meta-git-lib-missing-project-update-drift`
- `tasks/meta-release-workflow-meta-rust-artifact-drift`
- `tasks/meta-child-ci-synthesized-workspace-version-drift`
- `tasks/meta-code-intelligence-rust-index-coverage`

# Existing Task Reused

- `tasks/agent-score-hook-log-guard-effectiveness` already covers the `agent/src/score.rs` guard-effectiveness placeholder found again in this repeat pass.

# Prepared Commands

Safe discovery/prep commands verified:

- `/home/flexnetos/FlexNetOS/usr/bin/meta exec --help`
- `/home/flexnetos/FlexNetOS/usr/bin/meta init --help`
- `/home/flexnetos/FlexNetOS/usr/bin/git-kb code doctor --json`
- `/home/flexnetos/FlexNetOS/usr/bin/git-kb code index`
- `/home/flexnetos/FlexNetOS/usr/bin/git-kb code symbols --json`
- `/home/flexnetos/FlexNetOS/usr/bin/git-kb code impact <path> --json`

Do not run `/home/flexnetos/FlexNetOS/usr/bin/meta init claude --help` as a harmless help command until `tasks/meta-root-claude-settings-hook-command-drift` is fixed; it mutates tracked settings.
