---
id: 019f2143-fb68-7cf3-9b99-30f29e16474d
slug: tasks/meta-command-surface-docs-reconciliation
title: "Reconcile docs with live command surface"
type: task
status: completed
priority: high
tags: [docs, cli, skills]
---

# Summary

Bring README, docs, Claude skills, and local rules back into agreement with the live command surface without inventing compatibility that does not exist.

# Source Evidence

- `.claude/settings.json` and `.claude/skills/gitkb/SKILL.md` reference `git kb service`; installed GitKB rejects `service` and exposes `daemon`.
- `.claude/agents/meta-worker.md` says `meta project list --jsons`; the command is `--json`.
- `.claude/skills/meta-exec.md`, `.claude/skills/meta-safety.md`, and `claude-plugin/skills/*` reference `meta --ordered exec`; installed `meta` rejects `--ordered`.
- README examples use `meta exec npm install`; current help documents `meta exec -- <command>`.
- README/FAQ/Claude skills describe `meta git setup-ssh` as SSH multiplexing setup; current help treats it as generic `git setup-ssh` pass-through.
- The initial-10 source walk found `meta_cli/.claude/skills/meta-exec.md` still documenting `--ordered`, and showing `meta exec -- cargo update --exclude large-monorepo` even though `--exclude` is a meta-level filter and is not extracted from explicit `exec` command arguments after the command separator.
- The same walk found `meta_cli/.claude/skills/meta-git.md` and `meta_cli/.claude/skills/meta-plugins.md` documenting `meta git setup-ssh`, while `meta_git_cli` intentionally does not expose that command.
- `meta_cli/.claude/skills/meta-plugins.md` references `meta project sync`; `meta_project_cli` tests assert `project sync` is removed and users should use `meta git update`.
- `meta_cli/.claude/skills/meta-plugins.md` documents `.meta-plugins/` and `~/.meta-plugins/`, but subprocess plugin discovery and registry installation use `.meta/plugins/` and `~/.meta/plugins/`.
- `meta_cli/src/init.rs` embeds the stale `.claude` skill content, so `meta init claude` can regenerate outdated command guidance.
- `meta_git_cli/src/lib.rs` help text still lists `--include-only` even though the live global filter is `--include`.
- `meta_git_lib/src/missing.rs` tells users to run `meta project update`; the current update surface is `meta git update`.

# Acceptance Criteria

- Every documented command form is verified against the intended current CLI or an intentional compatibility task is created.
- `service`/`daemon`, `--jsons`, `--ordered`, `--include-only`, `meta exec --`, `setup-ssh`, `project sync`, `project update`, and plugin directory docs are reconciled.
- Claude skills/rules and public docs use the same command forms.
- Tests or doc checks cover the most important command examples where practical.
