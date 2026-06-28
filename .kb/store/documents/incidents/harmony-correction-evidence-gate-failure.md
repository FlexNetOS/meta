---
id: 019f0f63-2670-7bb3-ab3d-5e5879945559
slug: incidents/harmony-correction-evidence-gate-failure
title: "Fix Harmony correction evidence-gate failure"
type: incident
status: draft
priority: medium
---

# Overview

The prior Harmony correction repeated the same mistake it documented: failed/empty source retrieval during the correction was followed by confident patching, commit/push, and goal completion. This incident tracks the fix: evidence retrieval must gate claims, correction writes, commits, and completion.

## Acceptance Criteria

- [x] Prior correction report records that the correction pass itself had failed lookup/no-output evidence before it patched.
- [x] Reports/ADR/spec/KB distinguish opened evidence from unverified or failed retrieval.
- [x] Source evidence ledger lists exact opened sources for .context, obsolete KB docs, .handoff census, and GitHub redirects.
- [x] Anti-repeat rule says failed retrieval means stop/no claim/no completion.
- [x] Root commit and PR head verified after fix.

## Links

- Parent/related: [[incidents/harmony-source-truth-gap-hunt-correction]]

## Evidence opened before this fix

- `git kb list --json` and `git kb search harmony --json` produced exact archival slugs.
- `git kb show obsolete/meta-as-source-of-truth-meta-generated-ci-dashboar` was opened and showed `.meta.yaml` as shared truth, previous harmony-labs -> gitkb migration, gitkb -> FlexNetOS drift, and generated-CI/protection plans.
- `git kb show obsolete/integrate-top-gitkb-migration-finds-atc-gh-config` was opened and showed the migration primitive, repo creation as outward-facing, and required `gitkb/`/`harmony-labs/` re-pointing.
- `.context/CONTEXT.md`, `.context/VISION_PLAN.md`, and `.context/tasks/cicd-distribution-gaps.md` were opened and showed distribution requirements plus Homebrew/crates setup gaps.
- `.handoff/census-workspace-arch.*` was searched for lineage evidence.
- `gh repo view` verified `harmony-labs/meta` -> `gitkb/meta`, `harmony-labs/homebrew-tap` -> `gitkb/homebrew-tap`, and `FlexNetOS/meta-harmony` as private empty placeholder.

## Fix applied

- Added an evidence-gate amendment to `meta-harmony-source-truth-correction.md`.
- Updated the gap report and ADR to downgrade unverified registry/key and bundle-performance claims.
- Updated KB incident/task/spec so failed retrieval blocks claims, commits-as-complete, and completion.


## Completion Evidence

- Root commit: `5d8479a3c345a28bf120028ed0719805889f1cc8` (`docs: add Harmony evidence gate correction`).
- PR: https://github.com/FlexNetOS/meta/pull/91 at head `5d8479a3c345a28bf120028ed0719805889f1cc8` when verified.
- Verification: `git diff --cached --check` passed before commit; branch push updated origin; `gh pr view` reported PR #91 head and last commit as `5d8479a3c345a28bf120028ed0719805889f1cc8`.
