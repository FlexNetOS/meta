---
id: 019f21fc-7e3e-77f3-80b4-352cf7b1f51a
slug: tasks/meta-gitkb-recovery-safety-policy
title: "Define safe GitKB recovery and destructive-command policy"
type: task
status: completed
priority: high
parent: tasks/meta-gitkb-docs-command-config-extraction
---

# Summary

Define safety policy for GitKB recovery, repair, upgrade, and destructive commands so future automation cannot erase state while trying to "fix" the KB.

# Source Evidence

- `docs/gitkb/reference-troubleshooting.md` includes stale workspace cleanup, semantic search repair, conflict resolution, stale socket removal, and issue-report diagnostics.
- `docs/gitkb/cli-reference.md` documents destructive or high-risk commands and flags such as `rm --hard`, `reset --hard`, `filter`, `restore`, `upgrade`, `repair canonicalize`, `clear --force`, and `bundle apply --force`.
- The user explicitly experienced history/log damage from reset-style work and wants proof before change.

# Commands And Configs Covered

- `git-kb doctor --json`
- `git-kb doctor --fix`
- `git-kb repair projection`
- `git-kb repair manifest`
- `git-kb repair lineage`
- `git-kb repair canonicalize`
- `git-kb upgrade --check`
- `git-kb upgrade --dry-run`
- `git-kb upgrade --rollback`
- `git-kb backup`
- `git-kb restore <file>`
- `git-kb verify --json`
- `git-kb verify --full --json`
- `git-kb fsck --json`
- `git-kb reindex`
- `git-kb uncommit`
- `git-kb rm --hard --dry-run`
- `git-kb reset --hard --dry-run`
- `git-kb checkout --force`
- `git-kb clear --dry-run`
- `git-kb clear --force`
- `git-kb filter --rm ...`
- `git-kb bundle create`
- `git-kb bundle apply --dry-run`
- `git-kb bundle apply --force`
- `.kb/backups/`
- `.kb/cache/gitkb.sock`

# Acceptance Criteria

- [x] Recovery workflow starts with `git-kb status --json`, `git-kb doctor --json`, `git-kb info --json`, and a backup where available.
- [x] Commands with dry-run/check modes must run dry-run/check first.
- [x] Destructive commands require exact pathspec/slug, explicit approval, and evidence that backup exists.
- [x] `restore`, `filter`, `rm --hard`, `reset --hard`, `upgrade --adopt-*`, `upgrade --drop-*`, and `repair canonicalize` are prohibited in routine automation.
- [x] `checkout --force`, `clear --force`, `push --force`, and `bundle apply --force` are prohibited in routine automation.
- [x] Stale socket removal requires ownership and daemon-state proof.
- [x] Troubleshooting instructions are adapter guidance, not automatic cleanup hooks.
- [x] Issue reports redact API keys from `.kb/config.toml`.

# Policy

- Recovery begins with status, doctor, info, and backup proof. If a command has `--dry-run` or `--check`, that mode runs first.
- Destructive GitKB commands require exact slug/pathspec, explicit user approval, and backup evidence.
- The following are prohibited in routine automation: `restore`, `filter`, `rm --hard`, `reset --hard`, `upgrade --adopt-*`, `upgrade --drop-*`, `repair canonicalize`, `checkout --force`, `clear --force`, `push --force`, and `bundle apply --force`.
- Stale socket cleanup requires daemon-state proof and ownership/staleness proof before removing any file.
- Troubleshooting docs are guidance; they are not permission for automatic cleanup hooks.

# Completion Evidence

- 2026-07-02: `git-kb status --json` showed only the active checked-out KB task docs in the workspace during this workflow.
- 2026-07-02: `git-kb doctor --json` returned overall KB checks ok, with one non-mutating warning that `.kb/config.toml` has no `[repos]` section.
- 2026-07-02: `git-kb info --json` reported 78 documents, 34 commits, 0 stashes, 434 symbols, and no embedding vectors/models.
- 2026-07-02: `git-kb verify --json` returned `ok: true`, 78 documents checked, 34 commits checked, and no errors or warnings.
- 2026-07-02: `git-kb fsck --json` returned `clean: true` and `issue_count: 0`.
- 2026-07-02: `git-kb backup --help` confirms backup can write to `.kb/backups/YYYY-MM-DDTHH-mm-ss.json` or `--stdout`; no backup file was created because no destructive command was approved or attempted.

# Progress Log

### 2026-07-02
- Completed recovery policy proof with status/doctor/info/verify/fsck evidence and no destructive cleanup.
