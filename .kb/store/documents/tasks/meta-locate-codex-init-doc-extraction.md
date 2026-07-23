---
id: 019f21bb-20d7-74d2-a70a-b756c5d47f82
slug: tasks/meta-locate-codex-init-doc-extraction
title: "Locate extracted Codex doc for git-kb init codex"
type: task
status: completed
priority: high
---

# Summary
Found the extracted gitkb.com docs page that says to run `git-kb init codex` to build the `.codex` directory.

# Completion Evidence
- Located page: `docs/gitkb/getting-started-codex.md`.
- Lines 12-14 show the command block containing `git-kb init codex`.
- Line 16 says this generates the Codex integration into the project.
- Lines 18-40 show the generated `.codex/` tree, including `skills/` and `instructions/`.
- Lines 43 and 53 describe repo-local `.codex/skills/` and repo-local `.codex/` behavior.

# Acceptance Criteria
- [x] Search local docs/gitkb extraction for git-kb init codex.
- [x] Identify the exact file and lines for the command.
- [x] Identify the lines that say it generates the .codex integration.
- [x] Complete task with evidence.
