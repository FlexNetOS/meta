---
id: 019f2196-10af-7b13-a18c-44f8704c8ede
slug: tasks/meta-git-setup-ssh-restore
title: "Restore meta git setup-ssh command surface"
type: task
status: completed
priority: high
tags: [meta-git, ssh, plugins, docs]
---

# Summary

`meta git setup-ssh` is intended and needed. Prior alignment work incorrectly treated it as stale docs.

# Completion Evidence

- Restored `git setup-ssh` in `meta_git_cli` command dispatch and plugin metadata.
- Added focused tests for no-SSH-remotes and dry-run SSH URL discovery.
- Rebuilt `meta` so `meta init claude --update` embeds the corrected setup-ssh guidance.
- Re-ran root and 14-peer `meta init claude --update` after rebuilding.
- Installed local development plugins into ignored `.meta/plugins` with `make build-plugins` through the Nix cargo toolchain.
- Verified `./target/debug/meta plugin list --local` sees `git`, `project`, and `rust`.
- Verified `./target/debug/meta --dry-run git setup-ssh` lists the 14 SSH remotes from `.meta.yaml`.
- Verified root is the only `.claude/settings.json`; it still uses `agent guard` and `git-kb daemon ... --background`.
- Verified `cargo test -p meta_git_cli -- --test-threads=1` passed all 73 tests.

# Acceptance Criteria

- [x] Expose `setup-ssh` in `meta_git_cli`.
- [x] Document it in root and packaged Claude skills/docs.
- [x] Keep automatic SSH multiplexing behavior intact.
- [x] Verify help/tests plus hook status.
