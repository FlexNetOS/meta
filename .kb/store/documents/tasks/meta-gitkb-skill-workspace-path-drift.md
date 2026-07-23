---
id: 019f236b-249b-78d2-94db-72395a7954d1
slug: tasks/meta-gitkb-skill-workspace-path-drift
title: "Align GitKB skills with .kb/workspaces path"
type: task
status: completed
priority: high
tags: [gitkb, skills, docs, workspace, commands]
---

# Summary

The checked-in GitKB skill taught stale workspace and command forms while the installed `git-kb 0.2.12` materializes checked-out documents under `.kb/workspaces/main/` and uses the current `FIELD=VALUE`, pathspec, and link syntax.

# Source Evidence

- During [[tasks/meta-foundation-live-proof-gitkb-parity]], `git-kb checkout tasks/meta-foundation-live-proof-gitkb-parity` reported checkout to `/home/flexnetos/FlexNetOS/src/meta/.kb/workspaces/main`.
- `.kb/skills/gitkb/SKILL.md` still says documents are materialized to `.kb/workspace/` and gives edit examples such as `.kb/workspace/tasks/my-task.md`.
- `.kb/.gitignore` ignores `workspaces/`, confirming the local runtime path is accounted for inside the KB directory.
- `docs/gitkb/getting-started-quick-start.md`, `docs/gitkb/guides-team-collaboration.md`, and `docs/gitkb/reference-mcp-tools.md` already use `.kb/workspaces/main/`, so the remaining drift is in the skill/instruction layer.
- `git-kb set --help` shows `Usage: git-kb set [OPTIONS] <PATHSPEC> <FIELD=VALUE>...`, so `git-kb set <slug> --status active` was stale.
- `git-kb checkout --help` shows pathspec/glob arguments and no `--path` option, so `git-kb checkout --path context/` was stale.
- `git-kb link --help` shows `Usage: git-kb link [OPTIONS] <CHILD>` with `--to <CONTAINER>`, so `git-kb link --child ... --container ...` was stale.

# Acceptance Criteria

- [x] Update canonical `.kb/skills/gitkb/SKILL.md` to describe `.kb/workspaces/main/` for this installed CLI.
- [x] Check related skill docs for stale `.kb/workspace/` examples.
- [x] Update stale `git-kb set`, `git-kb checkout`, and `git-kb link` command examples to the installed CLI forms.
- [x] Verify `git-kb checkout <slug>` still materializes under `.kb/workspaces/main/`.
- [x] Commit the KB task evidence after the source/docs change.

# Completion Evidence

- `git-kb checkout tasks/meta-gitkb-skill-workspace-path-drift tasks/meta-foundation-live-proof-gitkb-parity` reported checkout to `/home/flexnetos/FlexNetOS/src/meta/.kb/workspaces/main`.
- `git-kb set --help`, `git-kb checkout --help`, and `git-kb link --help` proved the live command forms.
- `rg -n 'git kb|\.kb/workspace|git-kb set .*--status|git-kb link --child|--container|checkout --path|list --slug' .kb/AGENTS.md .kb/skills/gitkb/SKILL.md` reported no stale matches after the edit; only corrected `.kb/workspaces/main/` lines remained in the wider verification pass.
- Source commit `0e60540` updates `.kb/skills/gitkb/SKILL.md` to the live workspace path and command forms.

# Related

- [[tasks/meta-foundation-live-proof-gitkb-parity]]
- [[tasks/meta-gitkb-docs-command-config-extraction]]
- [[tasks/meta-kb-agents-command-path-drift]]
