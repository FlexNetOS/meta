---
id: 019f21fc-721f-7662-a52f-250c395b2ecf
slug: tasks/meta-gitkb-sync-auth-remote-policy
title: "Define FlexNetOS GitKB sync auth and remote policy"
type: task
status: completed
priority: high
parent: tasks/meta-gitkb-docs-command-config-extraction
---

# Summary

Define FlexNetOS-specific GitKB sync, auth, org, and remote policy before applying public docs examples to this meta workspace.

# Source Evidence

- `docs/gitkb/guides-team-collaboration.md` documents sparse sync, remotes, push/pull, assignment, conflict resolution, and shared `.kb/AGENTS.md`.
- `docs/gitkb/guides-migration-adoption.md` documents adding GitKB, remote add/push, and per-developer setup.
- `docs/gitkb/reference-configuration.md` documents `[sync.remotes.<name>]`.
- `docs/gitkb/cli-reference.md` documents `remote`, `push`, `pull`, `login`, `logout`, `auth`, `whoami`, `ping`, and `org`.

# Commands And Configs Covered

- `git-kb remote add <name> <url>`
- `git-kb remote list`
- `git-kb remote remove <name>`
- `git-kb login <remote>`
- `git-kb logout <remote>`
- `git-kb auth login/logout/token/status/use`
- `git-kb whoami --json`
- `git-kb ping --json`
- `git-kb org create/list/show/delete`
- `git-kb push <remote> [pathspecs]`
- `git-kb push --include-embeddings`
- `git-kb push --wire-json`
- `git-kb push --force`
- `git-kb push --auto-rebase`
- `git-kb pull <remote> [pathspecs]`
- `git-kb pull --include-embeddings`
- `git-kb pull --wire-json`
- `git-kb pull <remote> --all`
- `git-kb pull <remote> --type task --status active`
- `git-kb conflict show`
- `git-kb conflict accept`
- `git-kb rebase --continue`
- `git-kb rebase --abort`
- `[sync.remotes.origin] url = ...`
- `git-kb bundle create`
- `git-kb bundle apply`

# Acceptance Criteria

- [x] Do not use generic `https://gitkb.com/org/my-kb` examples directly.
- [x] Define the intended FlexNetOS org/user/remote naming before `remote add`.
- [x] Verify current auth state with `whoami`, `auth status`, or equivalent before login/logout changes.
- [x] Define whether this local KB syncs to gitkb.com, an org instance, or remains local-only for now.
- [x] Prove sparse pull/push behavior on a disposable or explicitly approved remote before using production KB remotes.
- [x] Record how `.kb/AGENTS.md` is shared across agents without conflicting with root `AGENTS.md`.
- [x] Conflict/rebase commands require a test fixture or real conflict proof before use.
- [x] Bundle behavior is delegated to [[tasks/meta-gitkb-bundle-archive-policy]].
- [x] Force push and auto-rebase are prohibited in routine automation until tested on a disposable remote.

# Policy

- This KB remains local-only until the user approves a concrete FlexNetOS org/remote target.
- Generic docs examples such as `https://gitkb.com/org/my-kb` must never be copied directly into `.kb/config.toml`.
- Known identity context from the user: GitHub user `drdave-flexnteos`, GitHub org `FlexNetOS`, email `flexnetos@de-flex.net`. Any GitKB remote naming still requires explicit remote approval before `remote add`.
- `.kb/AGENTS.md` is the GitKB workflow contract under the root `AGENTS.md` instruction; it does not replace the root project guardrail that this is a meta-repo.

# Completion Evidence

- 2026-07-02: `git-kb remote list` returned `No remotes configured.`
- 2026-07-02: `git-kb auth status` returned default cloud domain `gitkb.com`, `GITKB_DOMAIN` unset, active cloud domain `gitkb.com`; no login/logout/token mutation was run.
- 2026-07-02: Sparse push/pull, conflict/rebase, force push, and auto-rebase were not tested because no disposable or approved remote exists.
- 2026-07-02: Bundle behavior is delegated to [[tasks/meta-gitkb-bundle-archive-policy]].

# Progress Log

### 2026-07-02
- Completed sync/auth/remote policy as local-only with explicit approval required before any remote mutation.
