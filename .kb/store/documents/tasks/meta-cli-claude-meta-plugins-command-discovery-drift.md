---
id: 019f2173-49db-7350-9928-22399ed63479
slug: tasks/meta-cli-claude-meta-plugins-command-discovery-drift
title: "Fix stale commands and plugin paths in meta-plugins skill"
type: task
status: completed
priority: high
tags: [docs, claude, plugins]
---

# Summary

`meta_cli/.claude/skills/meta-plugins.md` mixes stale command and plugin-discovery guidance with current plugin concepts.

# Source Evidence

- The file lists `meta git setup-ssh`, while `meta_git_cli/src/lib.rs` asserts that help does not expose that command.
- The file shows `meta project sync`, while `meta_project_cli/src/lib.rs` asserts project sync is removed.
- The file documents `.meta-plugins/` and `~/.meta-plugins/`, while current root install/test flows use `.meta/plugins/` and `~/.meta/plugins/`.

# Acceptance Criteria

- Align commands with current live `meta git`, `meta project`, and `meta plugin` surfaces.
- Align plugin discovery locations with the current implementation/install convention.
- Add validation coverage for `setup-ssh`, `project sync`, and `.meta-plugins` in generated Claude skills.
