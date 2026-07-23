---
id: 019f2144-1a1e-7a73-b417-55427d7b71ba
slug: tasks/meta-org-migration-cleanup
title: "Clean legacy organization references"
type: task
status: completed
priority: medium
tags: [docs, org-migration]
---

# Summary

Clean or explicitly classify legacy organization references so the upstream `gitkb/meta` mirror no longer carries accidental `harmony-labs` or `mateodelnorte` residue.

# Source Evidence

- `.context/CONTEXT.md` and `.context/tasks/cicd-distribution-gaps.md` still reference `harmony-labs` URLs.
- Makefile clone targets use `git@github.com:mateodelnorte/meta.git`.
- `claude-plugin/.claude-plugin/plugin.json` author metadata still says Harmony Labs and links to harmony-labs while repository/homepage fields point at gitkb.

# Acceptance Criteria

- Search source for old organization/name references.
- Update unintended stale references to current upstream ownership.
- Preserve only intentionally historical references, with clear context.
- Final verification records the exact search commands and remaining intentional hits.
