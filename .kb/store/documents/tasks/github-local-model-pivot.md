---
id: 019ed8fd-db3f-7671-897d-10561cb53a05
slug: tasks/github-local-model-pivot
title: "Move GitHub automation to local model + cost-safety + remaining gap-closure"
type: task
status: draft
priority: medium
---

**Owner directive (top priority):** move GitHub automation to a **LOCAL MODEL**. A cloud-token
burn happened (see Incident) and must not recur. Do **not** run cloud-Claude on every PR.

## Status — what IS done (committed + merged)

- `.github_org` → `.github` **rename complete** (org defaults provider live; public; default `main`).
- meta inherits the org reusable: meta `#39` merged (semantic-pr-title → org reusable caller).
- **Overlooked-gaps program Bands B + C COMPLETE and on `main`** (FlexNetOS/.github):
  - `#170` build-provenance (SLSA L2) + OpenSSF Scorecard
  - `#171` cargo-deny + cargo-audit + `deny.toml`
  - `#172` zizmor Actions static-analysis gate + 3 real fixes
  - `#173` `persist-credentials:false` sweep (37 checkouts) + harden-runner (audit) on 7 jobs + zizmor→medium
  - `#174` reusable-rust-quality: cargo-semver-checks + typos + nextest + MSRV (opt-in)
  - `#175` promote → main (main == develop, verified).

## INCIDENT (2026-06-18) — root cause

Org CI froze ("PRs blocked everywhere, CI not running"). Root cause (owner-identified): a **local
self-hosted runner named `claude` that is improperly set up** ran up the token count fast, **plus**
the `.github` rename made `claude-code-review.yml`'s OIDC trust (`repo:FlexNetOS/.github:pull_request`)
valid again so it actually runs now. It auto-fires on **every non-draft PR** touching
`.github/**,scripts/**,runner/**,github-app/**,tools/**,*.md`. My 6 gap-closure PRs each triggered a
full Claude review + `auto-review-merge` → token burn on the bad runner. (A GitHub Actions
minute/spending overage was a secondary symptom — macOS jobs bill at 10×, see P0.2.)
Mitigation done: cancelled all my queued runs (62 in `.github` + meta) + active claude/auto-review runs.

## P0 — cost safety + local-model pivot (do FIRST; land cost-safety as DRAFT PRs — drafts skip claude-code-review)

1. **Move GitHub agent automation OFF cloud Anthropic API → local model.**
   - Targets: `.github/workflows/claude.yml` (the `@claude` interactive agent) and
     `.github/workflows/claude-code-review.yml` (per-PR review). Both use
     `anthropics/claude-code-action` with `CLAUDE_CODE_OAUTH_TOKEN` (cloud, paid).
   - Approach: point them at a **local model server** on the self-hosted runner — ollama or
     **shimmy** (both in the meta workspace; shimmy has an OpenAI-compatible endpoint). Investigate
     `claude-code-action`'s base-URL / model override (e.g. `ANTHROPIC_BASE_URL` or `--model`), or
     replace the review step with a small script that calls the local OpenAI-compatible endpoint.
   - Fix the `claude` self-hosted runner setup (owner is on this) so it doesn't loop/burn.
2. **Make `claude-code-review.yml` opt-in** — trigger only on a `claude-review` label / `@claude`
   mention / `workflow_dispatch`, NOT automatically on every PR. (Control-plane repo with frequent
   agent PRs must not auto-spend a review per PR.) Also review `auto-review-merge.yml` auto-trigger.
3. **Gate the expensive runner matrices to release tags only.** macOS = 10× minutes, Windows = 2×.
   Biggest burners (June billing): `loop_lib` macOS 20,048 min, `meta_plugin_protocol` Windows
   20,987 min, plus the meta release matrix. Restrict macOS/Windows build+test to `push: tags v*` /
   release, not every push/PR.

## P2 — remaining overlooked-gaps program (Bands A, D) + wiring

- **Band A — org governance (needs org-admin creds; BLOCKED, see threads):** define repo **custom
  properties** (tier/language/is-hub) → **org-level rulesets** targeted by property (push protect-main
  fleet-wide) → enable **secret-scanning/advanced-security for NEW repos** → **security configurations**
  + CodeQL default-setup auto-enroll. (Audit: org is single-seat; these are the real wins.)
- **Band D — only the sensible subset:** sub-issues + org issue-types. **SKIP** merge-queue and
  deployment "prevent-self-review" — they fight a single-admin org.
- **Wire new gates into fleet required checks** (cargo-deny, rust-quality) once fleet repos adopt the
  opt-in reusables; update `.github/policies/templates/rust-canon/rulesets.json` + apply.

## Open cross-session threads (do not lose)

- **envctl App-enroll → `mint-github`** (weave #126, #130): unblocks `POLICY_DRIFT_TOKEN` strict drift.
  BLOCKED on owner pointing at the **canonical secretd daemon** — only one visible on this box
  (`env-ctl.service` → `~/.cargo/bin/secretd` → `/run/user/1000/env-ctl/secretd.sock`, sqld backend);
  owner said that's the wrong one. Enroll needs the raw App PEM (vaulted copy is broker-only).
  App id `4044997`, installation id `140063898`.
- **flexnetos_github_app CI-mint mechanism** (weave #125): choose create-github-app-token-with-key /
  deployed OIDC broker / self-hosted-runner-local-mint for the drift token.

## References

- ICM topics: `context-github-org`, `decisions-github-org`, `errors-resolved` (incident + corrections).
- `.github` repo: `TODO.md`, `architecture/plan/2026-06-17-pre-rename-finish-plan.md`,
  `architecture/plan/2026-06-17-deep-review-upgrade-plan.md`.
- meta `#39` (semantic-pr-title reusable caller) is the inheritance pattern other repos can copy.
