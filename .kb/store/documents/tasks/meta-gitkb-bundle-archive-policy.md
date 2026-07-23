---
id: 019f2201-d193-7270-980e-e299fd96561c
slug: tasks/meta-gitkb-bundle-archive-policy
title: "Define GitKB bundle archive and replay policy"
type: task
status: completed
priority: high
parent: tasks/meta-gitkb-docs-command-config-extraction
---

# Summary

Define policy and proof requirements for GitKB bundle archive creation/application, because bundles replay commit history across KBs and can bypass ordinary remote sync assumptions.

# Source Evidence

- `docs/gitkb/cli-reference.md` documents `git-kb bundle`, `bundle create`, and `bundle apply`.
- The repeat pass found `.kbbundle` and `.kbbundle.gz` paths were not represented in the first task rail.

# Commands And Formats Covered

- `git-kb bundle`
- `git-kb bundle create`
- `git-kb bundle apply`
- `.kbbundle`
- `.kbbundle.gz`
- `delta.kbbundle`
- `--output`
- `--slugs`
- `--commits`
- `--since`
- `--author`
- `--json`
- `--dry-run`
- `--force`
- `--no-verify`

# Acceptance Criteria

- [x] Treat bundle application as recovery/sync-sensitive, not ordinary document editing.
- [x] Require `git-kb bundle apply --dry-run` before applying any bundle.
- [x] Require clean KB workspace or explicit backup before bundle apply.
- [x] Define where bundle artifacts may be stored and whether they are tracked or ignored.
- [x] Verify `bundle create --json` output shape before using it in automation.
- [x] Prohibit `bundle apply --force` in routine automation.

# Policy

- Bundle application is sync/recovery-sensitive and is never routine task editing.
- `git-kb bundle apply --dry-run --json <bundle>` is required before any apply, followed by clean workspace proof or explicit backup proof.
- Bundle artifacts are temporary transfer/recovery artifacts. Store outside tracked source unless the user explicitly approves an archival path.
- `bundle apply --force` is prohibited in routine automation.

# Completion Evidence

- 2026-07-02: `git-kb bundle --help` confirms bundle subcommands `create` and `apply`.
- 2026-07-02: `git-kb bundle create --help` confirms `--output`, `--slugs`, `--commits`, `--since`, `--author`, and `--json`.
- 2026-07-02: `git-kb bundle apply --help` confirms input path/stdin plus `--dry-run`, `--force`, `--no-verify`, and `--json`.
- 2026-07-02: No bundle was created or applied during this policy proof; live output shape for `bundle create --json` must be captured only when an approved archive target exists.

# Progress Log

### 2026-07-02
- Completed bundle policy and verified live create/apply command surfaces without creating or applying bundle artifacts.
