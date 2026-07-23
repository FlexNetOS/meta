---
id: 019f2173-49ba-7910-8a1a-12453a243eb9
slug: tasks/meta-cli-claude-meta-safety-ordered-drift
title: "Fix stale --ordered guidance in meta-safety skill"
type: task
status: completed
priority: medium
tags: [docs, claude, meta-cli]
---

# Summary

`meta_cli/.claude/skills/meta-safety.md` repeatedly documents `meta --ordered exec`, which is not a current live CLI flag.

# Source Evidence

- `meta_cli/.claude/skills/meta-safety.md` examples use `meta --ordered exec -- cargo build` and `meta --tag backend --exclude legacy --ordered exec -- make deploy`.
- The same file says `meta --ordered exec -- cargo build` builds in correct dependency order automatically.
- Live `meta --help` does not expose `--ordered`.

# Acceptance Criteria

- Replace stale `--ordered` examples with supported current command forms or an explicit future/compatibility note.
- Add validation coverage for stale `--ordered` examples in generated Claude skills.
