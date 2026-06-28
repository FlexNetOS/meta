# Evidence-gate amendment (2026-06-28)

This report is now amended because the first correction pass repeated the same class of error it described. The pre-compact transcript shows the correction pass hit failed/no-output retrieval while trying to open exact obsolete KB docs, then still said it had found the root cause and patched/committed. That behavior was wrong.

Hard correction: **evidence retrieval gates claims, writes, commits, and completion.** If a source lookup fails, returns no output, or only gives a truncated display, the claim stays `UNVERIFIED` and the agent must not write a confident correction from it.

The source ledger below was re-run after that failure and now records opened evidence, not inferred evidence.

# Correction: Harmony source-of-truth gap hunt audit

- Date: 2026-06-28
- Incident: `incidents/harmony-source-truth-gap-hunt-correction`
- Status: correction applied to plan/ADR/KB; no production code changed.

## Verdict

The previous Meta Harmony gap hunt contained useful architecture work, but its evidence discipline was incomplete. The correction is:

1. `.context/` is **legacy-active source evidence**, not obsolete.
2. `obsolete/` KB namespace means **archival namespace**, not “ignore.” Those docs still contain live migration and source-of-truth lessons until superseded by a verified current document.
3. `harmony-labs/*` redirects to `gitkb/*`; the real lineage is `harmony-labs → gitkb → FlexNetOS`, and release/distribution references must be treated as migration evidence.
4. `FlexNetOS/meta-harmony` is a **new placeholder/release-orchestrator repo**, not a pre-existing meta-defined truth. Its initialization/adoption is blocked until lineage reconciliation is complete.

## Source-of-truth trace

### Evidence opened in the fix-now pass

| Evidence class | Opened source / command result | What it proves | Status |
|---|---|---|---|
| KB search exact slugs | `git kb list --json` and `git kb search harmony --json` returned `obsolete/meta-as-source-of-truth-meta-generated-ci-dashboar` and `obsolete/integrate-top-gitkb-migration-finds-atc-gh-config`. | The previous truncated table was not enough; exact slugs must come from JSON or full output. | OPENED |
| Archival KB source | `git kb show obsolete/meta-as-source-of-truth-meta-generated-ci-dashboar` lines 14-24, 80-111, 153-180. | `.meta.yaml`/typed workspace model as source truth; prior harmony-labs -> gitkb org migration; gitkb -> FlexNetOS hardcoded-ref drift; generated CI/protection plan. | OPENED |
| Archival migration task | `git kb show obsolete/integrate-top-gitkb-migration-finds-atc-gh-config` lines 14-22, 24-55, 102-116, 141-148. | Migration primitive, history-preserving FlexNetOS repo creation, re-pointing `gitkb/` and `harmony-labs/`, and related Homebrew/CI migration scope. | OPENED |
| `.context` release surface | `.context/CONTEXT.md` lines 36-40 and `.context/tasks/cicd-distribution-gaps.md` lines 23-33, 37-75, 91-130. | Existing distribution strategy: install script, Homebrew, cargo-binstall, cargo install, GitHub Releases, crates/Homebrew tokens, and harmony-labs URLs. | OPENED |
| `.handoff` lineage | `.handoff/census-workspace-arch.md` and `.handoff/census-workspace-arch.json` matches for `harmony-labs`, `gitkb`, `FlexNetOS`. | Multiple repos record harmony-labs -> gitkb -> FlexNetOS lineage and origin-only FlexNetOS remotes. | OPENED |
| GitHub redirects | `gh repo view harmony-labs/meta` resolves as `gitkb/meta`; `harmony-labs/homebrew-tap` resolves as `gitkb/homebrew-tap`; `FlexNetOS/meta-harmony` is private and empty. | `harmony-labs/*` is redirect/migration evidence, while `FlexNetOS/meta-harmony` is a new empty placeholder. | OPENED |
| Registry/key ownership | No crates.io/npm ownership or key-state command was run in the fix-now pass. | Any FlexNetOS crates/npm ownership/key statement remains design guidance only, not verified current state. | UNVERIFIED |
| Bundle measurement | No Yazelix portable bundle build or benchmark was run. | Speed/hardware/container-benefit statements remain hypotheses until measured. | UNVERIFIED |


| Surface | Evidence | Correct interpretation |
|---|---|---|
| `.context/CONTEXT.md:36-40` | Distribution lists cross-platform binaries, Homebrew formula, install script, GitHub Actions release workflow. | Legacy-active product/distribution requirements. Must be read before release gap hunts. |
| `.context/tasks/cicd-distribution-gaps.md:23-33` | Install methods priority: install script, Homebrew, cargo-binstall, cargo install, GitHub Releases. | Existing distribution strategy, not superseded by Meta Harmony. |
| `.context/tasks/cicd-distribution-gaps.md:37-75` | `harmony-labs/meta` install URLs and release URL. | Historical upstream now redirects to `gitkb/meta`; migration evidence for release paths. |
| `.context/tasks/cicd-distribution-gaps.md:91-130` | Manual setup: `CARGO_REGISTRY_TOKEN`, `HOMEBREW_TAP_TOKEN`, `harmony-labs/homebrew-tap`; success criteria. | The prior crates/npm/key model missed existing crates/Homebrew setup work. |
| `obsolete/meta-as-source-of-truth-meta-generated-ci-dashboar` | Explains prior harmony-labs→gitkb→FlexNetOS org migration and source-of-truth CI drift. | “Obsolete” namespace is archival; content remains source-truth evidence until actively superseded. |
| `.handoff/census-workspace-arch.*` | Multiple repos record harmony-labs/gitkb lineage and origin-only FlexNetOS remotes. | Confirms lineage must be reconciled in release planning. |
| GitHub `gh repo view harmony-labs/meta` | Resolves to `gitkb/meta`. | `harmony-labs/meta` is not missing; it redirects to `gitkb/meta`. |
| GitHub `FlexNetOS/meta-harmony` | Private empty repo created 2026-06-28. | New placeholder only; not yet adopted as source of truth. |

## What was wrong

- I said I searched `.kb`, but I did not open the returned archival docs before executing.
- I did not read `.context/` before creating the Meta Harmony repo/report.
- I treated “obsolete/” as semantically stale instead of as a namespace needing verification.
- I overstated “verified container benefits”; no benchmark or artifact measurement exists.
- I implied “meta-harmony as defined by meta-kb”; evidence only supports it as a new repo created from the user's requested direction, not a pre-existing KB-defined repo.
- I verified docs for npm/crates/napi, but not actual FlexNetOS npm/crates ownership or key state.

## Why it happened

The immediate bug was **search-result triage by label**, not by source authority:

```text
git kb search harmony -> returned obsolete/* docs
agent assumption      -> obsolete == irrelevant/stale
correct rule          -> archival namespace != refuted evidence
```

A second bug was **KB-only tunnel vision** after reading `.kb/AGENTS.md`. The local repo also has `.context/`, and previous truth audit showed `.context` contains release/distribution requirements. The right behavior is to reconcile `.kb`, `.context`, `.handoff`, docs, and live repo/GitHub state before making outward-facing changes.

## Anti-repeat rule

For any future “gap hunt,” “source of truth,” “foundation,” “release,” “harmony,” “migration,” or “distribution” task, the preflight must include:

1. `git kb search <topic> --json` and open every returned high-signal doc, including archival/obsolete namespaces.
2. `rg <topic> .context .handoff docs .kb/store .meta.yaml` and open the matching source files before creating repos or plans.
3. Treat path/namespace/status labels as metadata, not truth. A doc is obsolete only if a current authoritative source explicitly supersedes the specific claim.
4. For external org/repo claims, verify redirects/remotes with `gh repo view` or equivalent before declaring missing.
5. Separate **created placeholder** from **pre-existing source-of-truth** in reports and ADRs.
6. **Failed/no-output/truncated retrieval is a stop condition:** record it as `UNVERIFIED`; do not patch, commit, or mark complete from that source until the exact evidence is opened or the report explicitly scopes the claim out.

## Corrected planning stance

- Meta Harmony remains useful as a release-orchestrator placeholder because the user explicitly requested it and it now exists.
- But its design must be reconciled with existing `.context` distribution strategy: install script, GitHub Releases, Homebrew tap, cargo-binstall, crates.io publishing.
- The next implementation step is not “build Meta Harmony from scratch”; it is **initialize it as a migration-aware release orchestrator** that imports the existing harmony-labs/gitkb/FlexNetOS distribution lineage.
- Adoption into `.meta.yaml` should remain blocked until the local clone exists and `.context`/KB/handoff lineage decisions are encoded.
