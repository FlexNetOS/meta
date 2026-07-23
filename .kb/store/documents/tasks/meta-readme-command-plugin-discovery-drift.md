---
id: 019f2173-49ed-70d3-8796-1714c11810be
slug: tasks/meta-readme-command-plugin-discovery-drift
title: "Fix stale command and plugin discovery docs in README"
type: task
status: completed
priority: high
tags: [docs, readme, plugins]
---

# Summary

The root README still contains stale command and plugin-discovery guidance.

# Source Evidence

- `README.md` lists `meta git setup-ssh`.
- `README.md` says plugins are discovered from `.meta-plugins/` and `~/.meta-plugins/`.
- Current Makefile install flows copy built-in plugins to `.meta/plugins/` and `~/.meta/plugins/`.
- Current `meta_git_cli/src/lib.rs` asserts `meta git setup-ssh` is absent from help.

# Acceptance Criteria

- Update README command tables and plugin-discovery docs to the current supported forms.
- Add README examples to command-surface validation where practical.
