# Codex advanced baseline research — 2026-06-27

## Sources checked

- OpenAI Codex GitHub Action docs: `openai/codex-action@v1` runs `codex exec` in CI, supports prompt files, output files, sandbox selection, `safety-strategy`, trigger allowlists, and structured output through `codex-args`.
- OpenAI Codex permissions docs: beta permission profiles are the newer least-privilege surface. They should not be mixed with older top-level sandbox settings. Built-ins are `:read-only`, `:workspace`, and `:danger-full-access`; custom profiles can define workspace roots, filesystem rules, and network domain rules.
- OpenAI Codex subagents docs: Codex only spawns subagents when explicitly asked; built-ins include `default`, `worker`, and `explorer`; custom agents live under `~/.codex/agents/` or `.codex/agents/` and require `name`, `description`, and `developer_instructions`. Defaults are `agents.max_threads = 6` and `agents.max_depth = 1`.
- `RoggeOhta/awesome-codex-cli`: useful as an ecosystem map for official docs, subagent collections, plugins, hooks, MCP servers, session/workflow tools, and CI/CD patterns; not authoritative for FlexNetOS policy.
- `Yeachan-Heo/oh-my-codex`: useful patterns include worktree-first high-power sessions, doctor/smoke checks, durable planning/execution loops, research-before-planning, and plugin-scoped skills/hooks. Avoid wholesale adoption; keep Codex/envctl as the owner of the baseline.

## Decisions

| Candidate | Decision | Rationale |
| --- | --- | --- |
| Codex GitHub Action PR review | Implement now | Official action gives repeatable read-only PR review with artifact/output capture and sandbox controls. |
| Permission profiles | Implement now | Matches current Codex docs and gives least-privilege defaults for meta work while denying env files. |
| Focused custom subagents | Implement now | Official subagent TOML format fits meta-worker, review, docs research, and baseline research without importing huge catalogs. |
| Awesome ecosystem catalogs | Document-only | Good discovery source, but repo-specific baseline should stay small and verified. |
| oh-my-codex workflow loop | Adapt patterns | Adopt research/plan/goal/worktree/smoke principles, not the whole runtime layer. |

## Implemented baseline upgrades

- Project `.codex/agents/` now includes focused read-only/review/docs/baseline research agents in addition to `meta-worker`.
- Envctl `codex-global-baseline` now generates global permission profiles and global agent TOML files under `$CODEX_HOME/agents`.
- Project and global Codex config use `default_permissions = "meta-workspace"` with `meta-read-only`, `meta-workspace`, and `meta-full-trusted` profiles.
- Added `.github/workflows/codex-pr-review.yml` and `.github/codex/prompts/review.md` for official Codex Action PR review.
- Added `.codex/prompts/codex-baseline-research-loop.md` plus a plugin skill so the research/upgrade loop is reusable.
