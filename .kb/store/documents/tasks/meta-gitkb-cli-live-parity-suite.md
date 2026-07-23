---
id: 019f21fc-572a-7753-81c4-bee23c6c941e
slug: tasks/meta-gitkb-cli-live-parity-suite
title: "Build live parity suite for GitKB CLI docs"
type: task
status: completed
priority: high
parent: tasks/meta-gitkb-docs-command-config-extraction
---

# Summary

Build a live parity suite proving installed `git-kb` command behavior against the extracted CLI docs before relying on commands for meta-plugin implementation.

# Source Evidence

- `docs/gitkb/cli-reference.md` says it is generated from `git-kb 0.2.6`.
- The current shell required `PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH` for `git-kb`.
- The docs expose commands across start/init, documents, graph/views, workspace, sync/auth, export/recovery, integrations, code intelligence, AI, and env vars.

# Command Families Covered

- Core: `git-kb --version`, `git-kb --help`, `git-kb <command> --help`
- Init/health: `init`, `doctor`, `repair`, `upgrade`, `info`
- Documents: `create`, `show`, `list`, `search`, `rm`, `set`, `assign`, `unassign`, `mv`, `templates`
- Graph/views: `link`, `unlink`, `reorder`, `graph`, `board`, `view`
- Workspace: `checkout`, `status`, `diff`, `commit`, `stash`, `reset`, `clear`, `log`
- Sync/auth: `remote`, `push`, `pull`, `conflict`, `rebase`, `bundle`, `login`, `logout`, `auth`, `whoami`, `ping`, `org`
- Export/recovery: `export`, `backup`, `restore`, `filter`, `schema`, `reindex`, `verify`, `fsck`, `uncommit`
- Integrations: `daemon`, `events`, `serve`, `mcp`, `context`, `ready`, `resolve`, `repo`, `config`
- Code: `code index`, `symbols`, `callers`, `callees`, `impact`, `dead`, `refs`, `stats`, `doctor`, `entrypoints`, `flows`, `flow`, `query`, `dump-ast`, `prune`, `detect-default-branches`
- AI: `ai embed`, `ai semantic`
- Env: `GITKB_ROOT`
- Option-level parity: [[tasks/meta-gitkb-cli-option-level-parity]]

# Acceptance Criteria

- [x] Record live `git-kb --version` and compare to docs' `0.2.6` claim.
- [x] Generate a machine-readable command inventory from live `--help` output.
- [x] Compare live command inventory against this task's family list.
- [x] Compare live option inventory through [[tasks/meta-gitkb-cli-option-level-parity]].
- [x] Mark missing docs-only commands as blocked before implementation depends on them.
- [x] Mark live-only commands as documentation drift before adding adapter behavior.
- [x] Prefer `--json` or dry-run flags for verification where available.
- [x] Never run destructive commands (`rm --hard`, `reset --hard`, `filter`, `restore`, `upgrade` mutation, `repair canonicalize`) outside dedicated safety tasks.

# Completion Evidence

- 2026-07-02: `git-kb --version` returned `git-kb 0.2.12`; extracted CLI docs are generated from `git-kb 0.2.6`, so docs/runtime drift is confirmed.
- 2026-07-02: Live help inventory walked `git-kb --help` plus subcommand help pages: 121 help pages, 0 help collection failures.
- 2026-07-02: Live-only top-level commands recorded before adapter use: `git-kb slug`, `git-kb sync`, `git-kb app`.
- 2026-07-02: Verification used read-only/help, `--json`, and dry-run paths where available; destructive commands were not executed.

# Progress Log

### 2026-07-02
- Completed live CLI parity proof and recorded version drift plus live-only command drift for downstream adapter work.
