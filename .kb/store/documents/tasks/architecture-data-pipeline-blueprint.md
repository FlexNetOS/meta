---
id: 019f8089-443c-7ad1-b431-6ed8a7a4ec0d
slug: tasks/architecture-data-pipeline-blueprint
title: "Build and verify expanded RuVector architecture blueprint"
type: task
status: active
priority: critical
---

## Objective

Build, integrate, and verify every implementable requirement in the immutable architecture anchor at `/home/flexnetos/Downloads/Architecture_Data_Pipeline_Blueprint_RUVECTOR_FULLY_EXPANDED_VERIFIED (1).md`, treating every optional feature as mandatory except owner-approved Tier-B session toggles.

## Authority order

1. Current owner instructions and applicable AGENTS.md, RULES.md, RTK, and repository contracts.
2. The named immutable architecture anchor.
3. Owner-ratified architecture decisions and maintained implementation contracts.
4. Canonical task, claim, proof-ledger, and source records.
5. Generated indexes, graphs, reports, and navigation artifacts as projections only.

## Acceptance criteria

- [ ] Immutable anchor has a complete digest, heading, line-range, and requirement receipt.
- [ ] Every first-party repository and applicable contract is inventoried and hashed.
- [ ] Every anchor requirement has stable provenance and implementation/proof crosswalk entries.
- [ ] PostgreSQL plus RuVector is canonical durable macro-state for all durable product data.
- [ ] redb remains transient/pass-through and preserves established dual-mode behavior.
- [ ] AgentDB owns per-agent cognition; envctl remains bridge/projection, not canonical storage.
- [ ] RTK, GitKB, ICM, and applicable code-intelligence surfaces are configured, healthy, and used.
- [ ] The exact Figma file/node is connected through a repository-approved upgrade workflow.
- [ ] All implementation, security, recovery, observability, deployment, upgrade, rollback, and mandatory formerly-optional branches are implemented and verified.
- [ ] A clean checkout/worktree build is reproduced by each installed and authorized Claude/Codex runtime.
- [ ] All repository-native gates pass with raw proof and no unresolved blockers or stale projections.
- [ ] Git/GitHub finish-state policy is satisfied for every changed repository.

## Execution record

This document is the canonical task spine. Requirement, conflict, decision, source, implementation, and proof documents/links will be added after the immutable anchor and repository registry are fully receipted.

### 2026-07-20 immutable-source receipt

- Owner source: `/home/flexnetos/Downloads/Architecture_Data_Pipeline_Blueprint_RUVECTOR_FULLY_EXPANDED_VERIFIED (1).md`
- SHA-256: `c54063110be8bebb07469cbc0f76fecab142cd636e98950a36a3ee02b766a62c`
- Size: `974321` bytes; `6340` lines.
- Normative graph: `/home/flexnetos/Downloads/Architecture_Data_Pipeline_Graph_ANCHORED_VERIFIED.md`
- Graph SHA-256: `abd36f1c2bd9d62e4fdb522e5290d93d4e7017b1b478c13dbf0a5da939c5b663`; `34773` bytes; `560` lines.
- Complete read coverage: lines `1-2200`, `2201-4400`, and `4401-6340` were read as contiguous, non-overlapping chunks. The repository-native section inventory independently covers `ARCHANCHOR-001-SECTION-001..108`, lines `1-6340`, with per-section digests.
- Repository-native immutable copies are byte-identical under `planning-spine-v0/1.0_VISION/Architecture_Anchors/` in `FlexNetOS/lifeos`.
- Canonical requirement/proof projection: `anchor_claim_task_crosswalk.csv` (`ANCHOR-REQ-001..016`).
- Canonical conflict projection: `anchor_conflict_ledger.csv` (`ANCHOR-CONFLICT-001..015`).
- No source or runtime edit preceded this receipt.

### Four-repository Yazelix execution slice

Meta registry identifies exactly four independent repositories:

| Repository | Path | Role | Baseline after fetch |
|---|---|---|---|
| `FlexNetOS/yazelix` | `/home/flexnetos/meta/src/yazelix` | Nix/profile owner, `yzx`, Zellij/Nushell/Yazi/Helix composition, release/runtime contracts | local `1b1db7ac`; `origin/main` `0f39a238`; clean main, two preserved dirty task worktrees |
| `FlexNetOS/yazelix-helix` | `/home/flexnetos/meta/src/yazelix-helix` | standalone Helix fork and explicit Yazelix bridge hooks | `c2819ed223c5e8909a3568af193ded22d495cbbc`, clean and synchronized |
| `FlexNetOS/yazelix-terminal-support` | `/home/flexnetos/meta/src/yazelix-terminal-support` | pure terminal metadata only; never launcher/renderer/runtime owner | `a7ee555aa4bcd154649b2d53d4fb7eb3c0467413`, clean and synchronized |
| `FlexNetOS/yazelix-yazi-assets` | `/home/flexnetos/meta/src/yazelix-yazi-assets` | reusable Yazi assets plus packaged ccboard/CodeDB runtime tools | `54a4dee3b9696d546cf26a876e83b3290143a363`, clean and synchronized |

All four remotes are organization SSH remotes. Every discovered `README*` and applicable `AGENTS.md` in these repositories was read completely before implementation.

### Yazelix requirement/provenance crosswalk

| Requirement | Anchor provenance | Owner | Implementation/proof surface | Baseline status |
|---|---|---|---|---|
| Profile-owned Engine Room and `yzx enter` | `ANCHOR-REQ-002/003`, D03-D12, lines 62-115, 5736, 6072 | main Yazelix | `runtime/yzx`, flake package, Zellij layout, `yzx status/doctor`, Nix profile | One profile element and sole profile `yzx` proven; `yzx inspect` command absent and is a RED contract |
| Helix bridge with standalone child behavior | lines 596-599, 6090; R14 | `yazelix-helix`, consumed by main | child flake package and main Helix contracts | Child latest is clean; main currently consumes upstream `luccahuguet/yazelix-helix`, requiring owner/pin reconciliation |
| Terminal metadata remains data-only | lines 596-599, 6073; R04 | `yazelix-terminal-support` | TOML + Rust/Nix pure readers | Child is at blueprint-pinned/latest SHA; main consumption must be proven without assigning launcher ownership |
| Yazi assets and formerly optional runtime tools | component register, lines 5705-6257; README package contract | `yazelix-yazi-assets`, consumed by main | asset manifest/render plan; ccboard and CodeDB packaged tools | Child latest is clean; main flake pins older `0935209c`, so latest pin parity is RED |
| RTK/GitKB/ICM/Beads code-intelligence tools available through one profile | `ANCHOR-REQ-011/013/015`, D21/D23, lines 5676-5703, 6065-6072, 6309-6318 | main Yazelix profile composition; products retain independent ownership | profile `bin`/`toolbin`, health, live operations, GitKB code index, ICM integrations | RTK/GitKB/ICM/br resolve through profile; `bv` is absent and is RED |
| Durable Codex rules follow editable-input/generated-output ownership | lines 1222-1231, 6309-6318 plus Meta AGENTS | main Yazelix | reviewed `agent_configs/codex/*.src`, Nu materializer, provenance tests, `/home/flexnetos/.config/yazelix` to `/home/flexnetos/.codex` | Preserved task worktree implements candidate; independent review and landing required |
| envctl remains bridge/projection and never a duplicate truth owner | `ANCHOR-REQ-007/011/013`, D11-D12/D21/D23 | envctl product owner; main profile may expose only an approved frontdoor | candidate profile bridge and foundation contracts | Preserved task worktree exists; architecture review must accept or reject the delegating wrapper before landing |
| Classic/old Yazelix is recoverable but inactive; Nova is latest active source | install/migration/release doctrine plus current README | main Yazelix Git/Nix owner | Nova lineage, `v17.12` tag/archive evidence, Meta inventory, single profile | Only four canonical Meta repos found; current active source is Nova; remote archive/branch and recovery proof still being reconciled |
| PR #77 receives a definitive disposition | repository/GitHub finish-state policy | `FlexNetOS/yazelix` | PR metadata/diff, current README history, comment/close or replacement | Pull ref is recoverable; its one-line semantic change is already on current main through PR #81, making evidence-backed obsolescence reviewable |

### Current RED evidence before implementation

1. `bv --version` fails because `bv` is not on PATH.
2. `yzx inspect` fails with `unknown command: inspect`.
3. Main Yazelix is one commit behind `origin/main`.
4. The main flake pins an older Yazi-assets revision and a non-FlexNetOS Helix source.
5. The durable Codex rules and envctl-frontdoor task worktrees are dirty and not landed.
6. PR #77 remains open with GitHub mergeability `UNKNOWN`, despite its change already existing on current main.

These are executable gaps, not optional/deferred items. They must turn green or be rejected by a higher-authority ownership contract with exact evidence before this slice is complete.

### Owner-requested execution notes — 2026-07-20

- [ ] Speed up the LifeOS TypeScript/Vue verification path without weakening type safety.
  - Enable persistent `vue-tsc --noEmit --incremental` state in an ignored build-cache location.
  - Run the cached type-check and Vite bundle concurrently through a Bun-owned orchestration script that preserves both logs and fails if either child fails.
  - Add a long-lived incremental watch path for the developer loop and a correctly keyed CI cache while retaining a cold, clean-checkout equivalence gate.
  - Measured receipt before implementation: one-shot type-check average `2.061s`; warm incremental average `1.207s`; current complete build average `2.710s`; cached parallel check plus bundle average `1.193s` (`56%` wall-time reduction, `2.27x` speedup).
  - Verification: cold and warm diagnostics must be equivalent; repository tests, production build, and clean-checkout CI must remain green.
- [ ] Reauthorize Claude's access to the exact LifeOS Figma design through the envctl secrets boundary.
  - Use only the profile-owned installed front door; do not promote the repository checkout, Meta runtime projection, user-local wrapper, or raw store path into an active selector.
  - Enter the refreshed Figma credential only through an interactive stdin/GUI vault surface; never place it in argv, shell history, logs, GitKB, ICM, source control, or generated receipts.
  - Store the credential as broker-only, create or refresh the least-privilege Figma relay policy, mint a short-lived peer-bound relay bearer for Claude, and verify access to file `z7aJ8uZrOsvfnWlsApN0Bu`, node `0:1` without revealing either credential.
  - Record only metadata-safe proof: profile/runtime identity, vault and daemon health, secret name/version/broker-only flag, relay policy name/status/scope, token identifier/expiry, authenticated Figma file/node receipt, and audit-chain verification.

### Yazelix execution progress — 2026-07-20 22:31Z

- Terminal-support schema-2 Mars metadata landed through
  `FlexNetOS/yazelix-terminal-support#2` as `873f64b77...`; the child remains a
  pure metadata owner.
- The authoritative Helix upstream synchronization and retained short bridge
  root landed through `FlexNetOS/yazelix-helix#2` as `2657bf0f8...`.
- Durable Codex config plus `RULES.md` ownership landed through
  `FlexNetOS/yazelix#89` as `977897551...`, including source provenance,
  exact-profile selection, runtime-table preservation, and interruption
  recovery.
- Main Yazelix blueprint implementation is pushed at `6397e1a4...`: `yzx
  inspect`, standard profile desktop ownership, latest child pins, complete
  Yazi sidecars, Helix bridge selection, Bun/Bunx-only JS ownership, Neovim,
  `bv`, current RTK plus `rtk_nu`, current ICM, and the repository requirement
  ledger. It remains gated on merging the profile convergence first.
- Literal `/home/flexnetos/.nix-profile` convergence is independently approved
  at `a81ceeec...` in `FlexNetOS/yazelix#90`. Review found and corrected a
  chained-generation archive gap. Focused fixtures now prove dry-run inventory,
  self-resolving archive topology, execute cutover, and exact rollback. A live
  non-mutating receipt enumerates all 23 current selector/generation links.
- Classic `v17.12`, the Nova beta boundary, stale Envctl-era branch history,
  and its unpublished diff are preserved in a verified complete-history bundle
  and recovery manifest at
  `/home/flexnetos/.cache/flexnetos/archives/yazelix/blueprint-cutover-20260720/`.
  The stale worktree and local branch are no longer active.
- PR #77 is definitively resolved: its exact one-line change and Lucca Huguet
  attribution were already merged by #81 as `cd7379ff...`; raw GitHub/pull-ref
  evidence was archived, a proof comment was added, and #77 was closed as
  superseded.
- Remaining gates for this Yazelix slice are #90 Linux CI/merge, final feature
  integration and review, installed single-profile cutover/materialization,
  complete tool/runtime proof, and four-repository cleanup receipts.

### vault_hub convergence receipt — 2026-07-20 22:29Z

- `FlexNetOS/vault_hub` PRs #6, #7, and #8 are merged. PR #8 passed the
  repository-owned `repository-integrity` workflow, received a formal
  no-blocking-findings review, and landed on `main` as
  `1bda2dc81edfde0cf525093660736f4750d8661e`.
- `main` is synchronized and has zero visible status records. All three merged
  task worktrees were clean and patch-equivalent to `main` before their local
  worktrees/branches were removed; the remaining stale remote branch was
  deleted, automatic merged-branch deletion was enabled, the stash inventory is
  empty, and the open-PR inventory is empty.
- Live databases, keyfiles, exports, runtime state, scratch captures, and
  downloaded proprietary source remain preserved locally as 27 ignored
  operator records. The known live KeePass database and keyfile are both mode
  `0600`; no secret value is recorded in this receipt.
- The repository now enforces raw-secret-shaped path rejection plus a staged
  content scanner that reports only path, line, and rule metadata. Sandbox
  coverage proves bearer, provider-token, private-key, and inline-login
  rejection without value disclosure, along with placeholder and synthetic
  template acceptance. The same tests, JSON parse, `git diff --check`, and
  `git fsck --strict` passed from a detached clean worktree.
- The proprietary Cognitum Claude plugin download is not vendored. Its upstream
  repository is commit-pinned in `registry.json` at
  `83f7adb33194bed33ee552b24423e5117f527687`, with the observed archive digest
  retained as provenance.
- GitNexus 1.6.9 was repaired through profile-owned Bun lifecycle trust for its
  disposable LadybugDB dependency and indexed the merged patch source at 213
  nodes, 285 edges, four clusters, and five flows. Change mapping reported low
  risk and zero affected execution processes; shell-hook coupling is proven by
  the repository-owned integration test.
- External installed-runtime blocker: the newly committed agent-environment
  audit contract cannot execute because profile-owned `envctl` is absent.
  Exact command:
  `/home/flexnetos/.nix-profile/toolbin/nu -l -c '^/home/flexnetos/.nix-profile/bin/rtk proxy -- envctl agent audit --config agent-env.yaml --scope project --locked'`.
  Exact output: `rtk: Failed to execute command: envctl: No such file or directory (os error 2)`.
  `/home/flexnetos/.nix-profile/bin/yzx run envctl --version` also fails with
  `failed to exec yzx run: No such file or directory (os error 2)`. Ownership is
  the Yazelix/Nix profile input; no user-local wrapper, repository build output,
  or raw Nix-store path was promoted as a substitute.
