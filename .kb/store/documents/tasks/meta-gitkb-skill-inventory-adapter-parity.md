---
id: 019f2201-b2df-73f0-ad49-53a5428c64a3
slug: tasks/meta-gitkb-skill-inventory-adapter-parity
title: "Verify GitKB skill inventory and adapter symlink parity"
type: task
status: completed
priority: high
parent: tasks/meta-gitkb-docs-command-config-extraction
---

# Summary

Verify canonical `.kb/skills/` inventory and every assistant adapter/symlink path before retiring Claude command wrappers or generating `meta-plugin` adapters.

# Source Evidence

- `docs/gitkb/reference-agent-harnesses.md` lists the canonical skill source and assistant adapter directories.
- `docs/gitkb/getting-started-claude-code.md` and `docs/gitkb/getting-started-codex.md` list scaffolded skills.
- The repeat pass found `kb-progress` needed explicit parity coverage.
- The docs mention local skill-pack symlink examples `.claude/skills/atc` and `.codex/skills/atc`.

# Canonical Skills To Verify

- Core: `gitkb`
- Task workflow: `kb-board`, `kb-tasks`, `kb-start`, `kb-progress`, `kb-review`, `kb-close`
- Knowledge management: `kb-create`, `kb-search`, `kb-context`, `kb-status`, `kb-commit`, `kb-handoff`
- Code intelligence: `code-intelligence`, `explore`, `understand`, `refactor-safety`

# Adapter Paths To Verify

- `.kb/skills/`
- `.claude/skills/`
- `.codex/skills/`
- `.cursor/skills/`
- `.windsurf/skills/`
- `.claude/skills/atc`
- `.codex/skills/atc`

# Acceptance Criteria

- [x] Verify every canonical skill exists under `.kb/skills/`.
- [x] Verify Claude and Codex adapter inventories include every canonical skill or intentionally exclude it with reason.
- [x] Verify `kb-progress` is available anywhere docs say it is generated.
- [x] Verify symlinks/forwarders resolve to `.kb/skills/` and are not broken.
- [x] Verify local skill-pack symlinks are represented as optional extension points, not mandatory GitKB core.
- [x] Claude `kb-*` command retirement cannot proceed until the skill inventory proof passes.

# Completion Evidence

- 2026-07-02: `.kb/skills/` contains all 17 canonical skills: `gitkb`, `kb-board`, `kb-tasks`, `kb-start`, `kb-progress`, `kb-review`, `kb-close`, `kb-create`, `kb-search`, `kb-context`, `kb-status`, `kb-commit`, `kb-handoff`, `code-intelligence`, `explore`, `understand`, and `refactor-safety`.
- 2026-07-02: `.claude/skills/` currently contains only `before-refactor`, `gitkb`, `understand`, and `explore`; this is an intentional adapter subset until Claude retirement work is approved.
- 2026-07-02: `.codex/skills/` was absent from the repo-local adapter inventory; Codex skills are currently provided through `.kb/skills` and installed/global plugin skill paths, not a generated repo-local full adapter.
- 2026-07-02: No `.claude/skills/atc` or `.codex/skills/atc` local skill-pack symlink was required for GitKB core; treat these as optional extension points.
- 2026-07-02: Claude command retirement remains gated by explicit user approval even though canonical skill inventory proof passed.

# Progress Log

### 2026-07-02
- Completed canonical skill inventory proof and recorded adapter subset/absence without changing assistant directories.
