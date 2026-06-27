---
id: 019ebd80-0c27-7250-8fa9-be3832c8ea49
slug: incidents/release-please-token-unavailable
title: "Release Please token empty in meta workflows (org secret not granted to parent repo)"
type: incident
status: investigating
priority: high
tags: [ci, secrets, release-please, org]
---

## Symptoms

`On Push to Main` is the only red on an otherwise-green meta main: the **Release Please** job dies
in ~0.2s with `release-please failed: Input required and not supplied: token` (run 27439121673 on
b12f3c7ab; same on every main push). Exposed for the first time on 2026-06-12 once the quality gates
went green — previously the job was *skipped* behind the failing quality jobs (masked since 2026-06-04).

## Root cause

`.github/workflows/on-push-main.yml` passes `token: ${{ secrets.PARENT_REPO_PAT }}`, but that **org
secret's repository-access policy does not include `FlexNetOS/meta` itself** — it serves the child
repos (where it authenticates parent-repo clones). In meta's own workflow context the expression
resolves to an empty string, and `googleapis/release-please-action@v4` treats empty as "not supplied"
(its `token` input has no default).

Note the second-order trap: the `quality` job (reusable `ci.yml` call) passes *without*
`secrets: inherit` because all 14 workspace-member clones are public — so the secret gap was
invisible until a job actually consumed the PAT.

## Mitigation (shipped)

meta PR **#14** (`release-please-token` branch, f55c39f): `token: ${{ secrets.PARENT_REPO_PAT ||
secrets.GITHUB_TOKEN }}` — the workflow's top-level `permissions` already grant `contents: write` +
`pull-requests: write`, so the job can run and create release PRs. Picks the PAT up automatically
once granted.

## Residual risk / durable fix (human required)

PRs created with `GITHUB_TOKEN` **trigger no CI runs**, so release PRs cannot pass required checks
or auto-merge until a human grants the org secret to the parent repo (exact `gh api PUT` command in
NEEDS-HUMAN.md item 2). Same grant likely needed for `REPO_WRITE_PACKAGES_PAT` (Trigger Release
Build job) — it will surface the same way on the first actual release.

## Resolution

Move to `resolved` when: PR #14 merged AND the first post-fix `On Push to Main` run shows Release
Please green. The PAT grant remains tracked in NEEDS-HUMAN item 2 (org access is classifier-blocked
for agents).
