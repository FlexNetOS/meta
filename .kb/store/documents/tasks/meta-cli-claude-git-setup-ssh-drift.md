---
id: 019f2173-49c9-7740-8dca-e2d2cda3381d
slug: tasks/meta-cli-claude-git-setup-ssh-drift
title: "Fix stale setup-ssh guidance in meta-git skill"
type: task
status: completed
priority: medium
tags: [docs, claude, meta-git]
---

# Summary

`meta_cli/.claude/skills/meta-git.md` still documents `meta git setup-ssh`, but the current git plugin help/tests indicate that command is not exposed.

# Source Evidence

- `meta_cli/.claude/skills/meta-git.md` SSH Optimization section shows `meta git setup-ssh`.
- `meta_git_cli/src/lib.rs` has an assertion that help does not contain `meta git setup-ssh`.
- Live command surface should route users to supported update/status/snapshot/pass-through behavior instead.

# Acceptance Criteria

- Remove or replace the stale `setup-ssh` skill guidance.
- If SSH multiplexing remains supported elsewhere, document the current supported entrypoint.
- Add validation coverage for `meta git setup-ssh` in generated docs.
