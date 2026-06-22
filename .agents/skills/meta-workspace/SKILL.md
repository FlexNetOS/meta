---
name: meta-workspace
description: Use when operating in the FlexNetOS meta workspace, discovering repos, planning cross-repo work, or deciding whether to use meta project/git/exec commands.
---

This workspace is a meta-repo: independent child git repositories managed by `rtk meta`, not a monorepo.

Workflow:

1. Run `rtk meta project list --json` at session start or before cross-repo assumptions.
2. Run `rtk meta git status` before editing, committing, summarizing, or stopping.
3. Prefer `rtk meta exec`, `rtk meta git`, `rtk meta project`, `rtk meta rust`, and `rtk meta plugin` over ad hoc per-repo loops.
4. Read `.claude/skills/meta-workspace.md` and `claude-plugin/skills/meta-workspace/SKILL.md` when you need the full Claude-era operating guide.
5. Do not edit `.claude/` as part of Codex parity work unless the user explicitly asks for `.claude` changes.

Meta-worker parity:

- Claude's `.claude/agents/meta-worker.md` maps to Codex subagent prompts that explicitly ask for a `meta-worker` style worker.
- Worker runs must create an isolated meta worktree with `rtk meta git worktree create <name> --repo . --repo <repo> --json`.
- Workers stay inside that worktree, run tests, commit there, do not push, and do not destroy the worktree.
