---
id: 019f236e-71e6-7de0-b942-c28c7887dc83
slug: tasks/meta-kb-agents-command-path-drift
title: "Align .kb/AGENTS.md with git-kb command and workspace path"
type: task
status: completed
priority: high
tags: [gitkb, agents, docs, workspace, commands]
---

# Summary

`.kb/AGENTS.md` is the central project agent guide, but it still used the legacy `git kb` command spelling, the old `.kb/workspace/` checkout path, `git-kb checkout --path context/`, and `git-kb list --slug tasks`. The current local binary is bare `git-kb 0.2.12`, and live help shows checkout pathspec/glob behavior and no `list --slug` option.

# Source Evidence

- During [[tasks/meta-foundation-live-proof-gitkb-parity]], the 2026-07-02 receipt found `git-kb 0.2.12` behind a now-retired per-user shadow. The exact obsolete path is intentionally absent from this active document. On 2026-07-20, `command -v git-kb` resolves `/home/flexnetos/.nix-profile/toolbin/git-kb`; the strict owner is the Nix profile.
- `git-kb checkout tasks/meta-gitkb-skill-workspace-path-drift tasks/meta-foundation-live-proof-gitkb-parity` reported checkout to `/home/flexnetos/FlexNetOS/src/meta/.kb/workspaces/main`.
- `git-kb checkout --help` shows pathspec/glob checkout arguments and no `--path` option.
- `git-kb list --help` shows `--path <PATH>` and no `--slug` option.
- Pre-fix `rg` found many legacy `git kb` and `.kb/workspace/` entries in `.kb/AGENTS.md`.

# Acceptance Criteria

- [x] Replace legacy `git kb` command spelling in `.kb/AGENTS.md` with `git-kb`.
- [x] Replace stale `.kb/workspace/` wording with `.kb/workspaces/main/`.
- [x] Replace `git-kb checkout --path context/` examples with `git-kb checkout 'context/*'`.
- [x] Replace `git-kb list --slug tasks` with a live supported command form.
- [x] Verify the stale patterns are gone from `.kb/AGENTS.md`.
- [x] Commit the KB task evidence after the source/docs change.

# Completion Evidence

- Edited `.kb/AGENTS.md` to use `git-kb`, `.kb/workspaces/main/`, `git-kb checkout 'context/*'`, and `git-kb list --path tasks/`.
- `rg -n 'git kb|\.kb/workspace|git-kb set .*--status|git-kb link --child|--container|checkout --path|list --slug' .kb/AGENTS.md .kb/skills/gitkb/SKILL.md` reported no stale matches after the edit; remaining output in the broader scan was corrected `.kb/workspaces/main/` wording.
- Source commit `0e60540` updates `.kb/AGENTS.md` and `.kb/skills/gitkb/SKILL.md`.

# Related

- [[tasks/meta-foundation-live-proof-gitkb-parity]]
- [[tasks/meta-gitkb-skill-workspace-path-drift]]
