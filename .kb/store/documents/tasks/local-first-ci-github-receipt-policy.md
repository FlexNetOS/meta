---
id: 019f20a6-74f7-74a3-9b5f-280baf8e93fd
slug: tasks/local-first-ci-github-receipt-policy
title: "Document local-first CI and GitHub receipt policy"
type: task
status: completed
priority: high
parent: tasks/gitkb-local-agent-platform
tags: [ci, github-actions, tokens, docs, meta, policy]
---

# Overview

Document the FlexNetOS local-first validation policy and update the Meta agent surfaces so future agents do not blindly duplicate expensive local CI, GitHub Actions, and token-consuming AI checks.

This task was opened after an operator clarification that FlexNetOS is currently a single-user, single-admin-owned organization and that full GitHub cloud reruns are often slower and more expensive than local validation.

# Problem

Current guidance does not clearly separate:

- local developer validation as the fast source of engineering feedback,
- GitHub Actions as an independent merge/status receipt,
- self-hosted runners as the preferred way to get GitHub check receipts without burning hosted compute,
- and LLM/Codex/AI jobs as token-consuming checks that must be opt-in unless guarding releases.

The result is duplicate validation and unnecessary cloud/token spend.

# Desired policy

Document a default hierarchy:

1. Run full heavy validation locally when the operator is the only committer or when the work is being developed interactively.
2. Keep GitHub PR/push CI lightweight by default: format, compile/check, fast smoke, and essential guards only.
3. Run expensive GitHub workflows only on release tags, manual `workflow_dispatch`, scheduled/nightly jobs, critical-path labels, or self-hosted runners.
4. Treat GitHub CI as a recorded receipt for the exact pushed commit, not as the primary local TDD loop.
5. Never run token-consuming AI/Codex checks in GitHub by default unless a release or explicit opt-in policy says so.

# Acceptance criteria

- Add or update docs in `meta` explaining local-first CI versus GitHub CI receipt semantics.
- Update relevant Codex/Claude/meta prompt or skill surfaces so agents know when to use local validation, GitHub Actions, and self-hosted runners.
- Include exact examples for `meta exec`, scoped validation, and manual/label-triggered full CI.
- Document that `git-kb init` is the KB/project bootstrap command and `git-kb init codex` installs Codex integration files.
- Document that `meta exec` is a fleet command runner; there is no `meta exec init` subcommand in current `meta 0.2.22`.
- Add a drift/checklist item so future CI or agent-surface changes keep the policy synchronized across docs, `.codex`, `.claude`, and `.kb`.


# Next implementation steps

1. Add or update durable Meta documentation that defines local-first validation, GitHub Actions as a receipt for the exact pushed commit, self-hosted runners as the preferred GitHub check executor, and token-consuming AI/Codex checks as opt-in by default.
2. Update relevant Codex, Claude, and Meta agent surfaces so agents choose local validation first, keep GitHub CI lightweight, and only request full cloud/release validation when policy says it is needed.
3. Include exact operator examples for scoped `meta exec` validation, local full validation, lightweight PR smoke checks, manual `workflow_dispatch`, label-triggered full CI, and self-hosted-runner receipt checks.
4. Document bootstrap semantics clearly: `git-kb init` creates/configures a KB, `git-kb init codex` installs Codex integration files, `meta init` owns Meta integrations such as Claude in current `meta 0.2.22`, and `meta exec` is only a fleet command runner; there is no `meta exec init` subcommand.
5. Perform a hook audit across `.codex`, `.claude`, `.github`, `.kb`, and Meta hook surfaces to ensure no hook silently triggers expensive GitHub cloud CI or token-consuming AI checks without an explicit release/manual/label/self-hosted policy gate.

# Evidence collected

- `/home/flexnetos/FlexNetOS/usr/bin/git-kb --version` reports `git-kb 0.2.12`.
- `/home/flexnetos/FlexNetOS/usr/bin/git-kb init --help` exposes `claude`, `codex`, `cursor`, `windsurf`, and `git` init targets.
- `/home/flexnetos/FlexNetOS/usr/bin/meta --version` reports `meta 0.2.22`.
- `/home/flexnetos/FlexNetOS/usr/bin/meta init --help` exposes `claude` only in the installed binary.
- `/home/flexnetos/FlexNetOS/usr/bin/meta exec --help` describes `meta exec` as running a command across repositories, not initializing integrations.
- `flexnetos_runner` currently has `.codex`, `.github`, and `.handoff`, but no `.kb`, `.meta`, or `.beads` directory.

# Progress Log

## 2026-07-02

- Added `docs/local-first-ci.md` with local-first validation hierarchy, GitHub receipt semantics, self-hosted runner preference, manual/label/release gates, AI-token opt-in policy, scoped `meta exec` examples, bootstrap semantics, and a drift checklist.
- Added `docs/hook-audit-local-first-ci.md` with a root hook/workflow audit across `.codex`, `.claude`, `.github`, `.kb`, `claude-plugin`, and `codex-plugins` surfaces.
- Updated `README.md`, `docs/agent_workflows.md`, and `docs/claude_code_skills.md` to point agents/operators at the local-first policy.
- Updated Codex instructions under `.codex/` with local-first CI, bootstrap semantics, and hook-audit requirements.
- Updated Claude/Meta surfaces in `.claude/`, `claude-plugin/skills/`, and `meta_cli/.claude/` with local-first validation and bootstrap semantics.
- Updated GitKB guidance in `.kb/AGENTS.md` and `.kb/skills/gitkb/SKILL.md` for current `git-kb 0.2.12` command forms and bootstrap semantics.
- Fixed `.claude/agents/meta-worker.md` command typo from `meta project list --jsons` to `meta project list --json` while adding local-first CI discipline.

# Completion Evidence

- Hook audit command wrote `/tmp/local-first-hook-audit.txt` and found no explicit token-hook hits for `openai_api_key`, `sk-proj`, `api.openai.com`, `codex exec`, or `codex run` in audited hook surfaces.
- Fleet hook/workflow surface count was exercised through `meta --json exec` and saved to `/tmp/local-first-meta-exec-hook-count.json`.
- Documentation and agent surfaces now include the 1-5 implementation plan requested by the operator, including the hook audit as step 5.
