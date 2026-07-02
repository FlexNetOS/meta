# Hook Audit: Local-First CI Policy

Date: 2026-07-02
Task: `tasks/local-first-ci-github-receipt-policy`

## Scope

Audited root `meta` hook and automation surfaces that can run commands or start
GitHub work:

- `.codex/`
- `.claude/`
- `.github/`
- `.kb/`
- Meta plugin/worktree hook docs and plugin payloads

## Findings

| Surface | Finding | Local-first impact |
|---|---|---|
| `.codex/instructions/*` | Guidance only; no lifecycle command hooks. | No cloud or token-consuming trigger found. |
| `.claude/settings.json` | Session/compact hooks run `meta context`, GitKB service/daemon startup, and `./target/debug/agent guard` for Bash. | Local-only hooks; no GitHub dispatch or AI-token call found. |
| `.claude/agent-guard.toml` | Destructive command guard patterns only. | Local safety guard; no cloud trigger found. |
| `.github/workflows/ci.yml` | Push/PR workflow runs format, clippy, tests, and integration jobs on GitHub-hosted runners. | Declared GitHub receipt surface. It is not token-consuming, but future changes should keep default PR/push jobs lightweight or route heavy jobs to manual/label/self-hosted gates. |
| `.github/workflows/on-push-main.yml` | Push to `main` calls CI and release-please, then dispatches release build only when release-please creates a release. | Release path is explicit; no AI-token use found. |
| `.github/workflows/release.yml` | Runs on tags or `release-tagged` dispatch and builds release artifacts. | Release-only cloud work; acceptable under policy. |
| `.github/workflows/on-child-update.yml` | Repository dispatch creates sync PRs and enables auto-merge. | Explicit dispatch automation; not an AI/token hook. Keep separate from default validation policy. |
| `.github/workflows/semantic-pr-title.yml` | PR title validation only. | Lightweight receipt; acceptable. |
| `.kb/config.toml` | `[hooks]` enables GitKB context/linking behavior; no command hook dispatch target in this config. | Local KB behavior; no cloud or AI-token trigger found. |
| `claude-plugin/hooks/hooks.json` | Plugin payload contains Claude guard hooks. | Local guard hooks; no GitHub dispatch or AI-token call found in root audit. |
| `codex-plugins/plugins/gitkb` | README states the marketplace package ships no lifecycle command hooks and defers lifecycle to `git-kb init codex`. | Good: avoids duplicate Codex hook execution. |

## Required guardrail

Any future hook or workflow that can run expensive GitHub cloud work or an
LLM/Codex/OpenAI call must be gated by at least one explicit signal:

- release tag,
- `workflow_dispatch`,
- approved PR label such as `run-full-ci`,
- scheduled maintenance window,
- self-hosted runner routing,
- or an operator-authored task that names the cost.

## Follow-up

The current root GitHub CI matrix is visible and non-token-consuming, but it is
larger than a minimal smoke receipt. If FlexNetOS wants strict local-first cost
control in this repo, split CI into:

1. default PR/push receipt workflow, and
2. full matrix workflow gated by `workflow_dispatch`, release tags, label, or
   self-hosted runners.

## Audit commands run

```bash
python3 - <<'PY' | tee /tmp/local-first-hook-audit.txt
# scanned .codex, .claude, .github, .kb, claude-plugin, and codex-plugins
# for hook/workflow/AI-token trigger strings
PY

meta --json exec -- /bin/sh -c 'find . -maxdepth 3 ... hook/workflow surfaces ... | wc -l' \
  > /tmp/local-first-meta-exec-hook-count.json
```

Root scan summary:

- `.codex`: 2 files scanned, 1 guidance hit, no lifecycle command hook found.
- `.claude`: 23 files scanned, settings/hooks and local guidance hits found.
- `.github`: 6 workflow files scanned, push/PR/repository-dispatch/tag triggers found.
- `.kb`: 39 files scanned, config/guidance hits found.
- `claude-plugin`: 9 files scanned, local hook payload and guidance hits found.
- `codex-plugins`: package-policy and plugin payload guidance hits found; no active root lifecycle command hook was found.
- Explicit token-hook search for `openai_api_key`, `sk-proj`, `api.openai.com`, `codex exec`, and `codex run` returned no hook-surface hits.

The audit evidence supports the policy docs: root hooks are local guidance/guard
hooks, GitHub workflows are declared automation surfaces, and token-consuming AI
checks are not currently wired into default PR/push hooks.
