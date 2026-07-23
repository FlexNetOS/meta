---
id: 019f21d2-8ad5-75c1-9979-8c70d2e2cc2e
slug: tasks/meta-retire-stale-claude-kb-commands
title: "Retire stale Claude kb command wrappers"
type: task
status: completed
priority: high
---

# Summary
Audit and retire stale Claude `kb-*` command wrappers if the current GitKB docs and Claude integration now load those workflows as skills.

# Evidence
- Extracted GitKB docs say `kb-*` command-style workflows are now skills loaded from `.kb/skills`, not separate `.claude/commands` or `.codex/commands` directories.
- Current Claude Code docs say `.claude/commands/` is legacy, still loaded when present, and that `.claude/skills/<name>/SKILL.md` is the recommended format for the same slash-command name with autonomous invocation support.
- Root `.claude/commands/` previously contained `kb-board.md`, `kb-commit.md`, `kb-context.md`, `kb-status.md`, and `kb-tasks.md`; those legacy wrappers are now retired.
- `.kb/skills/` contains canonical `kb-*` skills, and both `.codex/skills/*` and `.claude/skills/*` symlink into those canonical skills.

# Acceptance Criteria
- [x] Verify whether current Claude Code still requires or loads `.claude/commands/kb-*` for this repo.
- [x] Compare each `.claude/commands/kb-*` wrapper against the matching `.kb/skills/kb-*` skill.
- [x] Remove, archive, or redirect stale command wrappers only after proving skill-based workflows cover the behavior.
- [x] Keep `.kb/skills` as the canonical workflow source.
- [x] Document the final Claude adapter model.

# Progress

- Not removed in this slice. `claude` is not installed in this environment (`claude: command not found` from the prior audit), so the current loader behavior cannot be verified live.
- 2026-07-02 live check: `claude --version` still fails with `claude: command not found`; `command -v claude`, `command -v oh-my-claudecode`, and `command -v omc` returned no binary path, so current Claude loader behavior remains unverified locally.
- 2026-07-02 live check: `.claude/commands/` contains exactly five `kb-*` wrappers: `kb-board.md`, `kb-commit.md`, `kb-context.md`, `kb-status.md`, and `kb-tasks.md`.
- 2026-07-02 live check: each wrapper has a matching canonical skill under `.kb/skills/<name>/SKILL.md`.
- Diff evidence: the wrappers are not identical to the canonical skills. The canonical `.kb/skills` versions add GitKB skill frontmatter (`name:`), stronger `--json` guidance, scoped KB commit behavior, `kb_smart_context` enrichment, and current `blocked_by` terminology; the `.claude/commands` wrappers still carry Claude command `allowed-tools` frontmatter.
- 2026-07-02 live check: `.codex/skills/kb-*` entries are symlinks to `../../.kb/skills/kb-*`, proving Codex already uses `.kb/skills` as the canonical workflow source for these task workflows.
- 2026-07-02 live check: `meta plugin harness --harness claude --json` exits 0 and reports Claude GitKB skill adapters as 3 dirty direct paths (`gitkb`, `explore`, `understand`) plus 14 missing adapter symlinks, including the `kb-*` skills. No files were overwritten.
- 2026-07-02 live check: `git status --short -- .claude/commands .kb/skills .claude/settings.json .claude/skills` returned no output, so the prior note that root `.claude/commands/kb-*` files were already dirty is stale and no longer matches current git state.
- `docs/agent_plugin_control_plane.md` now records the migration rule from official Claude docs: migrate standalone assistant config into plugin payloads, then retire originals only after proving the plugin covers the behavior.
- 2026-07-02 current Claude Code docs proof: https://code.claude.com/docs/en/skills states that skills are invoked with `/skill-name`, that a `.claude/commands/deploy.md` file and `.claude/skills/deploy/SKILL.md` both create `/deploy`, and that existing `.claude/commands/` files keep working. The same docs state that project skills load from `.claude/skills/`, and that files in `.claude/commands/` still work but skills are recommended.
- 2026-07-02 current Claude Agent SDK docs proof: https://code.claude.com/docs/en/agent-sdk/slash-commands states that `.claude/commands/` is the legacy format, `.claude/skills/<name>/SKILL.md` is the recommended format, the CLI continues to support both formats, and the SDK `system/init` slash command list includes custom commands when present.
- 2026-07-02 implementation proof: `meta plugin harness --harness claude --write --backup-dir .meta/backups/harness-20260702-claude-gitkb` generated valid `.claude/skills/*` symlink adapters for all 17 canonical GitKB skills.
- 2026-07-02 preservation proof: the previous direct Claude skill files for `gitkb`, `explore`, and `understand` are preserved under `.meta/backups/harness-20260702-claude-gitkb/.claude/skills/`.
- 2026-07-02 retirement proof: `.claude/commands/kb-board.md`, `.claude/commands/kb-commit.md`, `.claude/commands/kb-context.md`, `.claude/commands/kb-status.md`, and `.claude/commands/kb-tasks.md` were removed after the matching `.claude/skills/kb-*` adapters existed and validated.
- 2026-07-02 final model proof: `docs/agent_plugin_control_plane.md` now documents the Claude GitKB skill model: `.kb/skills/<skill>/SKILL.md` is canonical, `.claude/skills/<skill>` is a generated adapter symlink to `../../.kb/skills/<skill>`, and `.claude/commands/kb-*.md` wrappers are retired after adapter validation.
- 2026-07-02 git commit proof: `dc19b8a` (`Retire Claude GitKB command wrappers`) removes the five legacy command wrappers, adds generated Claude skill adapter symlinks for all 17 canonical GitKB skills, preserves previous direct Claude skill files under `.meta/backups/harness-20260702-claude-gitkb/`, and documents the final adapter model.

# Completion Evidence

Close after verifying: no `.claude/commands/kb-*.md` files remain, `meta plugin harness --harness claude --json` reports all Claude adapters valid, `git-kb verify --json` passes, and the root git diff contains only the adapter migration, backup preservation, documentation update, and this task evidence.
