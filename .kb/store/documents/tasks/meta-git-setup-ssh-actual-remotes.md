---
id: 019f219a-ee26-7482-aa48-5bf852069166
slug: tasks/meta-git-setup-ssh-actual-remotes
title: "Include actual org SSH remotes in setup-ssh"
type: task
status: completed
priority: high
tags: [meta-git, ssh, github, remotes]
---

# Summary

`setup-ssh` should include already-configured GitHub org SSH remotes from checked-out repositories, not only the declarative `.meta.yaml` URLs.

# Completion Evidence

- Updated `meta_git_cli/src/ssh.rs` so SSH discovery keeps `.meta.yaml` SSH URLs and also reads actual child repo `origin` fetch and push URLs.
- Added tests for a checked-out repo with HTTPS fetch plus `git@github.com:FlexNetOS/...` push URL.
- Verified `cargo test -p meta_git_cli ssh -- --test-threads=1` passed 21 tests.
- Verified `cargo test -p meta_git_cli setup_ssh -- --test-threads=1` passed 2 tests.
- Rebuilt and refreshed the ignored local `.meta/plugins/meta-git`.
- Verified live `./target/debug/meta --dry-run git setup-ssh` now lists 15 SSH URLs, including `git@github.com:FlexNetOS/codex-plugins.git`.

# Acceptance Criteria

- [x] Include SSH origin fetch and push URLs from existing child repos.
- [x] Keep `.meta.yaml` SSH URL coverage.
- [x] Deduplicate discovered URLs.
- [x] Focused tests verify configured and actual remotes.
