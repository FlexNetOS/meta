---
id: 019f223d-8754-7a40-b66e-2400b210fa53
slug: tasks/meta-gitkb-assignment-field-mismatch
title: "Fix GitKB assign and unassign field mismatch"
type: task
status: draft
priority: medium
---

# Summary

Fix the live mismatch between `git-kb assign` and `git-kb unassign` field
handling observed during the Documents page execution.

# Evidence

- `git-kb assign views/active-tasks codex-docs-pass --json` returned success and
  wrote `assignee: codex-docs-pass` into the checked-out view document.
- `git-kb unassign views/active-tasks --json` returned `changed:false` with
  message `Already unassigned`.
- `git-kb diff` showed the workspace still had `assignee: codex-docs-pass`.
- Removing that field from `.kb/workspaces/main/views/active-tasks.md` returned
  `git-kb status --json` to clean.
- Repeated against this task document itself: `git-kb assign
  tasks/meta-gitkb-assignment-field-mismatch codex-repeat-docs --json` wrote
  `assignee: codex-repeat-docs`, while `git-kb unassign
  tasks/meta-gitkb-assignment-field-mismatch --json` again returned
  `changed:false` and left the `assignee` field in the workspace diff.

# Acceptance Criteria

- [ ] `git-kb assign <slug> <agent>` and `git-kb unassign <slug>` use the same
  canonical frontmatter field.
- [ ] `unassign` clears the field written by `assign` for task documents.
- [ ] `unassign` behavior for non-task documents is either supported
  consistently or rejected before writing.
- [ ] JSON responses report the persisted field accurately.
- [ ] Regression tests cover assign/unassign round trip and idempotent unassign.
