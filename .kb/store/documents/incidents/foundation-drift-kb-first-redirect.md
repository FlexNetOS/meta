---
id: 019f0ef2-9067-7e72-873e-0e22b6c73ac7
slug: incidents/foundation-drift-kb-first-redirect
title: "Foundation drift requires KB-first redirect"
type: incident
status: draft
priority: medium
tags: [meta, gitkb, drift, foundation, claude]
---

# Foundation drift: KB-first redirect required

## Evidence
- Original upstream is `https://github.com/gitkb/meta/tree/main/.claude` at commit `fe19560b210eeb3a101565ccd021ab63aff71f8c` (`chore: add codex plugins marketplace repo (#92)`).
- Local FlexNetOS `origin/main` is `38c9b4b603`; comparison `origin/main...gitkb-upstream/main` is `93 1`, proving this fork has diverged substantially from original `gitkb/meta` main.
- Upstream `.claude` contains the compact baseline: `agents/`, `commands/`, `rules/`, `skills/`, `agent-guard.toml`, and `settings.json`.
- Upstream `.kb/AGENTS.md` names `context_source: gitkb`, uses `.kb/workspace/`, and requires KB-first workflow: detect KB state, create incident/task before code exploration, and load required context docs.
- Local `.kb/AGENTS.md` has drifted to `context_source: FlexNetOS` and `.kb/workspaces/main/`.
- Local `.claude` has additional layers not in upstream: handoff steward, handoff/checkpoint/resume/fleet/mint/speak commands, hook scripts, statusline, ollama/verifier/ide-index/handoff skills, and broader settings hooks.

## Redirect decision
Treat upstream `gitkb/meta` as the foundation contract and FlexNetOS additions as overlays. Do not delete overlays blindly. Route recovery through GitKB database-first workflow:
1. Establish an upstream-proof ledger document in GitKB.
2. Split surfaces into: foundation baseline, FlexNetOS overlay, Codex parity, and handoff/harness overlay.
3. Reconcile with additive/redirecting adapters, not destructive rollback.
4. Add verifiers that compare local `.claude`, `.kb/AGENTS.md`, `.context`, and meta commands against upstream baseline and record deviations.
5. Make KB documents the source of decisions; generated files may mirror but must not be the source of truth.

## Immediate safety notes
- Primary meta checkout was restored to `main` and verified in sync with `origin/main` before this audit.
- Pre-existing dirty tracked state was preserved in stash `preserve-meta-dirty-context-before-main-sync-20260628T154309Z`.
- Real `meta exec -- init` was not run because it resolves to `/usr/sbin/init -> systemd`; only dry-run expansion was used.