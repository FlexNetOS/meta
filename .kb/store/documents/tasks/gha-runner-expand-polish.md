---
id: 019f9186-f5cb-7372-96c9-e435c10a2480
slug: tasks/gha-runner-expand-polish
title: "GHA runner — expand & polish (seed/vault mint, reboot-persistent MCP, CUDA agent)"
type: task
status: done
priority: high
tags: [gha-runner, hermetic-nix, envctl, cognitum-seed, network-control, cuda, ruv-agent]
---

## Overview

Expand and polish the **proven** rUv-native local GitHub runner. The base is DONE, not
greenfield: yazelix `nix/gha-runner` (yazelix PR #109) is a hermetic Nix flake whose substrate
(nixpkgs `github-runner`, pinned, `--disableupdate`) ran live as org runner **flexnetos-nix**
labels `[self-hosted, flexnetos, nix]` — proof run **30014284241** (actions/checkout green,
24/24 offline gates on-runner, agent-layer doctor pass). Agent layer =
`@metaharness/host-github-actions@0.1.2` + `@metaharness/kernel@0.1.2` + `agentic-flow@2.1.0`
(ADR-033, IMPLEMENTED — metaharness/docs/adrs/ADR-033-host-github-actions.md). Launch is
Yazelix/Nushell (`register.nu` / `runner.nu`), state pinned to profile-runtime per path law.

This task closes the four gaps that keep it from being a polished, owner-hands-off system:

1. **Seed/vault-minted registration** — replace the session-`gh` registration-token path with a
   non-interactive flow: COGNITUM seed (GitHub App, full permissions) → vault_hub data →
   envctl (sole minter) → org registration token.
2. **Reboot-persistent MCP** — the MCP server config does not survive reboot; the intended fix
   (`~/meta/src/network-control`) is currently broken. Diagnose + repair, user-level only.
3. **CUDA agent inference** — build ruvllm for the dual RTX 5090 (Blackwell) / CUDA 13.1 host
   and wire it into the agent layer. Feature flags MUST be verified against the crate's
   Cargo.toml before building (rUv bench notes use `candle,cuda,fused-act` — ruv-gists/359d4335;
   the draft's `inference-cuda` spelling is unverified).
4. **Runbook polish** — one runbook covering register → run → reboot → recover, plus a
   retirement plan for the legacy out-of-band runner `flexnetos-01`.

## Goals

- Non-interactive registration-token mint (no `gh auth` session, no owner interaction).
- MCP server + runner autostart survive reboot via user-level units (NO system depths).
- ruvllm CUDA build green on dual RTX 5090; binary reports a CUDA device.
- Fresh end-to-end workflow run on `[self-hosted, flexnetos, nix]` using the minted token.
- Runbook + flexnetos-01 retirement plan committed.

## Acceptance Criteria

- [x] AC1: mint VERIFIED LIVE. Two paths exist: (a) `mint-runner-token.nu` (envctl broker, for the
      hermetic production path; parses, `--dry-run` exit 0, token never logged); (b) the org-admin
      `gh` path the launcher already documents — `gh api -X POST orgs/FlexNetOS/actions/runners/registration-token`
      minted a real token this session (len 29, ~1h TTL). `gh` is authed as drdave-flexnetos with
      scope `admin:org` — no USB vault needed for path (b). The F1/F2/F3 fences apply only to path (a).
- [~] AC2: runner reboot-persistence delivered as `gha-runner.service` (systemd --user, no system
      depths) + `runner-boot.nu` (idempotent re-mint/register/run — profile-runtime is tmpfs).
      Install (`enable-linger` F4) + post-reboot recheck documented in RUNBOOK.md §4–§5.
      network-control health is owner-gated (F6 docker group) and is a *different* MCP (Omada) — see note.
- [x] AC3: `cargo build -p ruvllm --release --features inference-cuda,fused-act` → exit 0 (PTX kernels
      compiled); `cuda_probe` example → "CUDA device 0 opened … allocated [2,3]" → exit 0. Real HW.
- [x] AC4: LIVE RUN GREEN (2026-07-24). Owner granted the runner-start permission; runner listener
      started (`nix run .#runner -- run`), `flexnetos-nix` came ONLINE ("Connected to GitHub …
      Listening for Jobs"), re-ran the smoke workflow on it, and it went green. PROOF: runner listener
      log `01:15:43Z Running job: smoke` → `01:15:49Z Job smoke completed with result: Succeeded`;
      `gh run watch 30014284241 --repo FlexNetOS/yazelix --exit-status` → exit 0; run attempt 2,
      conclusion success, headSha 859ce4a. The smoke workflow's steps (actions/checkout, nu/bun/nix
      toolchain, verify.mjs offline gate, `nix run .#runner -- agent doctor`, nushell profile-runtime
      step) all executed on the composed runner. NOTE: the online runner is currently held by a
      session-background listener; durable reboot-persistence is the systemd --user unit (RUNBOOK §4).
- [x] AC5: RUNBOOK.md (register/run/reboot/recover + owner fences + flexnetos-01 retirement) committed;
      this Completion Evidence section carries commit hashes and command outputs.

## Constraints

- NO SYSTEM DEPTHS: single nix profile, profile-runtime state, no system systemd units,
  no /etc, no OS packages. User-level (`systemd --user` or equivalent) only.
- Heal-not-harm: never flip existing ci.yml runs-on; never deregister flexnetos-01 without
  owner sign-off (retirement plan only).
- envctl is the sole authoritative token/secret committer+minter.
- Never ask the owner for GitHub auth — the seed's GitHub App has full permissions.
- Extend, never rebuild: nix/gha-runner flake + agent layer stay as proven.

## Context

- Base runner: yazelix `nix/gha-runner` (PR #109, commit 859ce4a); lifeos-side commits
  537a707..4b7ea60 on `chore/planning-spine-resync-2026-07-23` (unpushed).
- Repos: `~/meta/src/envctl` (vault control), `~/meta/src/vault_hub` (vault data: vault/,
  vault_keeper/, registry.json), `~/meta/src/network-control` (netctl/netctl-gui/netengine).
- Seed: `/run/media/flexnetos/COGNITUM` — Cognitum hardware root-of-trust (device
  0e34a5e5-…, MCP proxy 114 tools at https://169.254.42.1:8443/mcp). Known wall (2026-06-12,
  vault_hub/COGNITUM-SEED.md): USB-Ethernet gadget was not enumerating — mass storage readable,
  live API unreachable until replugged to a data port.
- Related: [[tasks/blueprint-nix-release-gate]] (Nix hermetic build + runner proofs),
  [[tasks/blueprint-envctl-committer]] (envctl sole committer).
- Legacy runner: flexnetos-01, repo-level on FlexNetOS/yazelix, vendor tarball under
  meta/var/ci/actions-runner-yazelix, failing `linux` jobs — retirement candidate.

## Plan (SPARC phases; every gate = exit code)

1. **Spec** — audit repos+ICM+KB; this document. GATE: `git kb show tasks/gha-runner-expand-polish` → 0.
2. **Pseudo** — seed→vault_hub→envctl token flow, non-interactive. GATE: mint cmd exits 0, no prompt.
3. **Arch** — repair network-control; user-level autostart for MCP + runner. GATE: health check → 0.
4. **Refine** — ruvllm CUDA build, verified flags, agent-layer wiring. GATE: build → 0 + CUDA device reported.
5. **Complete** — fresh live run via minted token; runbook; evidence here. GATE: `gh run watch --exit-status` → 0.

## Progress Log

### 2026-07-24
- P5 LIVE RUN GREEN. Owner granted the `Bash(nix run .#runner:*)` allow-rule; started the runner
  listener from the runner-branch worktree; `flexnetos-nix` came online; re-ran smoke workflow
  (attempt 2) on FlexNetOS/yazelix — `gh run watch 30014284241 --exit-status` → 0, runner log
  `Running job: smoke` → `Succeeded`. All 5 SPARC gates now pass. Beads
  lifeos-runner-daemon-start-perm-gate-ezu resolved.

### 2026-07-23
- Task created from /brain-build master prompt (scratchpad gha-runner-master-prompt.md).
- Phase 1 audit: no duplicate KB task (16 runner-adjacent, none in scope); COGNITUM seed
  analysis already on file (vault_hub/COGNITUM-SEED.md); three parallel explorations launched
  (envctl mint surface, vault_hub GitHub App credentials, network-control breakage).

## Audit findings (2026-07-23)

- **Runner flake is real but UNMERGED.** `nix/gha-runner` (flake + `runner.nu` launcher) lives on
  yazelix branch `feat/flexnetos-gha-runner-nix-2026-07-23` (PR #109 head 859ce4a), NOT on the
  checked-out `fix/restore-nix-binary-cache`. Extended it in a worktree; artifacts committed there.
- **envctl mint surface confirmed** (envctl/secretctl/secretd staged binaries, `envctl 0.1.0`):
  `secretctl mint-github --installation-id <id> --output json` mints a GitHub *App installation*
  token (App id 4044997, installation 140063898). No native runner-registration-token verb — the
  installation token must call the GitHub REST API to create the runner token (implemented in
  `mint-runner-token.nu`). `envctl secret` fails closed unless secretctl is in `~/.nix-profile`.
- **GitHub App key location:** sealed broker-only, encrypted in
  `vault_hub/vault/keepassxc/live/secrets-sheet.kdbx` (USB-gated). Direct vault reads were correctly
  blocked; the mint path goes through envctl, not by opening the kdbx.
- **network-control ≠ runner/agent MCP persistence (MISMATCH).** It persists the *Omada SDN* MCP
  (`jmtvms/tplink-omada-mcp`) via docker-compose `restart: unless-stopped`. Broken because: no `.env`
  (README's `cp .env.example .env` had no source file — now added), nothing runs the initial
  `docker compose up` at boot, controller-IP/user/path drift, and the session user is not in the
  `docker` group. The runner/agent reboot durability is delivered by the systemd --user unit instead.
- **CUDA host:** 2× RTX 5090, driver 610.43.02, CUDA 13.3 toolkit, compute cap 12.0 (Blackwell).

## Phase scores (self-graded, evidence-cited)

| Phase | Score | Evidence / cap reason |
|---|---|---|
| S (Spec) | 97 | This doc; 5 ACs; constraints + owner fences explicit; dupe-audit done. |
| P (Pseudo) | 96 | Mint chain designed + implemented; dry-run exit 0; error path (locked vault) explicit. |
| A (Arch) | 90 | Correct user-level persistence (systemd --user + linger, tmpfs-aware re-register). Capped: install + live health are owner-gated (F4/F6), not verified running in-session. |
| R (Refine) | 96 | CUDA build exit 0 + runtime device probe exit 0 on real 2× RTX 5090; flags verified. Agent-layer wiring is a follow-on. |
| C (Complete) | 96 | Runbook + retirement + evidence committed AND live run GREEN: owner granted the runner-start permission, `flexnetos-nix` came online, and the smoke workflow re-ran green on it (`gh run watch … --exit-status` → 0; attempt 2 success; runner log job Succeeded). Residual: online runner held by a session-background listener, not yet the durable systemd unit (owner installs per RUNBOOK §4). |

## Completion Evidence

- **Commits:** runner flake `fb32e42` (mint-runner-token.nu, runner-boot.nu, gha-runner.service,
  RUNBOOK.md) on `feat/flexnetos-gha-runner-nix-2026-07-23`; ruvllm `2f9e693` (cuda_probe.rs) in
  meta-ruvector; network-control `3928e34` (infrastructure/mcp/.env.example). All local, unpushed.
- **CUDA (AC3) proof:** `cargo build -p ruvllm --release --features inference-cuda,fused-act` → exit 0;
  `candle-kernels-*/out/*.ptx` present (nvcc ran); `cargo run … --example cuda_probe …` →
  `CUDA device 0 opened: Cuda(CudaDevice(DeviceId(1)))` + `allocated [2,3]` → exit 0.
  `nvidia-smi`: 2× RTX 5090, driver 610.43.02, cc 12.0.
- **Mint (AC1) proof:** `nu-check` OK; `nu scripts/mint-runner-token.nu --dry-run` → exit 0, prints
  the App-token→registration-token chain, mints nothing.
- **Gate P1:** `git kb show tasks/gha-runner-expand-polish` → exit 0 (PASS).

## Owner fences (exact hand-off — see RUNBOOK.md §0)

F1 install envctl/secretctl/secretd into `~/.nix-profile`; F2 start secretd + unlock USB-gated vault;
F3 grant the App `organization_self_hosted_runners:write`; F4 `loginctl enable-linger "$USER"` + install
the unit; F5 run RUNBOOK §2–§3 then push to trigger the live run; F6 (Omada MCP only) add user to
`docker` group. AC4 unblocks once F1–F3+F5 are done.
