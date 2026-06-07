---
description: Apply strict-upgrade policy to dirty meta workspace state.
argument-hint: [TARGET="files or repos"]
---

Apply the strict-upgrade policy in `.codex/policies/strict-upgrade.md`.
Do not propose rollback as the default for `.claude/settings.json`, root `Cargo.lock`, or child-repo manifest drift.
Inspect diffs, identify missing companion work, implement the missing upgrade follow-through, validate, and commit in scoped repos.
Target: $TARGET
