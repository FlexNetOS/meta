---
id: 019f21a6-b50e-76b0-8dda-dfa86abe30c6
slug: tasks/meta-git-setup-ssh-root-remote
title: "Include meta root SSH remote in setup-ssh"
type: task
status: completed
priority: high
---

# Summary
setup-ssh should include the meta root repository origin when the root is itself an SSH remote, in addition to child repos from .meta.yaml.

# Completion Evidence
- Converted local root and child origin remotes from HTTPS to SSH, preserving the existing FlexNetOS codex-plugins push remote.
- Updated meta_git_cli/src/ssh.rs so discovery starts with the current repo origin fetch/push URLs before walking .meta.yaml projects.
- Extended the focused SSH discovery test to assert git@github.com:gitkb/meta.git is included for a meta root with project config.
- Verified cargo test -p meta_git_cli ssh -- --test-threads=1 passed 21 tests.
- Verified cargo test -p meta_git_cli setup_ssh -- --test-threads=1 passed 2 tests.
- Verified live ./target/debug/meta --dry-run git setup-ssh lists 16 SSH URLs, including git@github.com:gitkb/meta.git and git@github.com:FlexNetOS/codex-plugins.git.
- Verified no root or child origin remote URLs contain http:// or https://.

# Acceptance Criteria
- [x] Root meta origin SSH URL is included by setup-ssh.
- [x] Child declarative SSH remotes remain included.
- [x] Existing org push SSH remote remains preserved.
- [x] No local root or child origin remotes remain on HTTP(S).