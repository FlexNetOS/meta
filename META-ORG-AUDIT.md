# META-ORG-AUDIT.md — Full-fleet compliance audit vs POLICY v2

**Date:** 2026-06-12 · **Method:** mechanical sweep of every `.meta.yaml` member (git state, markers, workflows) + live `gh api` (org listing, branch protection, latest CI runs) + targeted code verification. Companion to [META-ORG-POLICY.md](META-ORG-POLICY.md).
**Fleet:** 60 registered projects (was 64 — 4 stale weave-* second-checkout entries deregistered this audit) + 1 nested member (mcp_hub→n8n-mcp) + parent.

## Verdict snapshot

| | |
|---|---|
| Identity (P1: genuine org repos, origins correct) | ✅ 100% after this audit's fixes (ruflo was the last violation) |
| Sync state | ✅ every cloned repo clean & synced at audit time |
| CI present | ✅ Tier A canon (3-workflow template) · ⚠️ gaps: meta_dashboard_cli (zero CI), meta_plugin_api (zero, stub), handoff (zero — owned by HFTASK-0012), claude-plugins, lifeos, envctl/teri (no wf dir) |
| CI green | ✅ fleet-wide after this audit's fixes (was: meta_cli red Format; parent red on workspace cargo gates) |
| Protection | ❌ only `.github/main`, `lane/main`, `weave/master` (3/58) — Phase 4 work |
| Auto-merge | ❌ disabled everywhere (Phase 4) |
| semantic-pr-title | ⚠️ parent + 11 propagation PRs opened this audit |
| Renovate | ⚠️ 5 canon gaps → PRs opened this audit |
| .kb/ | parent + prompt_hub only (policy P5.23 relaxed for thin members) |
| Docs accuracy | ✅ sampled hubs (template_hub/mcp_hub/vault_hub) conform to Hub Standard; RuVector prose remains catalogued-untrusted |

## Fixes landed by this audit (evidence)

| Fix | PR / commit | State |
|---|---|---|
| meta_cli red Format gate (from 29770d1 ollama-init) | FlexNetOS/meta_cli#1 (d415f98) | **MERGED** 17:48Z, full CI green |
| teri fmt ×12 + clippy into_iter | FlexNetOS/teri#1 (534ad39) | **MERGED** 17:48Z |
| shimmy clippy ×5 + publish=false + workspace-aware test binary paths | FlexNetOS/shimmy#1 (5b1c58a) | **MERGED** 17:48Z |
| Parent CI multiple-workspace-roots (clone forks) | FlexNetOS/meta#11 (pre-existing, owned by prior session) | CI rerun after the three merges above |
| semantic-pr-title propagation (11 repos) + Renovate (5 repos) | loop_lib#1, loop_cli#1, meta_core#1, meta_plugin_protocol#1, meta_git_lib#1, meta_cli#2, meta_git_cli#1, meta_project_cli#1, meta_rust_cli#1, meta_mcp#1, meta-plugins#1 | open → merge on green |
| ruflo homed: genuine org fork created (`FlexNetOS/ruflo`, fork=true, Organization), origin/upstream rewired, pin branch `pin-meta-2026-06-12` (local dfe1b9cf9), `.meta.yaml` URL | this session | done (verified via org re-query — gh fork silent-success lesson applied) |
| kasetto source located + adopted: org fork `FlexNetOS/env_manager_agent` (parent pivoshenko/kasetto) registered as `kasetto`, cloned, upstream added | resolves open-questions #5 | done (fork at 3.0.0 vs installed 3.1.0 — behind upstream, FF candidate) |
| `.meta.yaml` hygiene: 4 stale weave-* second-checkout entries removed (+ their .gitignore lines), 10 canon entries tagged `[canon]`, handoff tagged | this session (parent dirty → Phase 6 PR) | done |
| Workspace verification | fmt --all ✅ · clippy -p shimmy -p teri -p meta -D warnings ✅ · cargo test (shimmy 111+360+253… all suites ok) ✅ | worktree `org-audit-ci-fixes` |

## Tier A — canon scorecards (10 + parent)

Common to all 10: genuine org repo ✅ · registered ✅ (now tagged `canon`) · branch `main`, clean, synced ✅ · `version.workspace = true` (parent VERSION 0.2.22 = the distribution version) ✅ · RUST_LOG = crate name via `run_plugin()`/env_logger ✅ · no protection ❌ (Phase 4) · no .kb (allowed for thin members).

| Repo | Workflows | Renovate | Plugin protocol | Notes |
|---|---|---|---|---|
| loop_lib | ci+auto-format+notify-downstream ✅ | PR#1 | lib (n/a) | downstream: loop_cli, meta_cli, meta_git_cli |
| meta_plugin_protocol | ✅ | PR#1 | THE protocol | downstream: meta_cli + 3 plugins |
| meta_plugin_api | **none** | ✅ | legacy trait stub (109 LOC) | **disposition needed: archive or tombstone README** (P3.12) |
| meta_core | ✅ | PR#1 | lib (n/a) | sparse by design (~1.7k LOC: data_dir/lock/store) |
| meta_git_lib | ✅ | PR#1 | lib (n/a) | downstream: meta_git_cli, meta_project_cli |
| loop_cli | ✅ (consumer: dependency-updated) | PR#1 | bin `loop` (host-side, not a meta-* plugin) | |
| meta_cli | ✅ (consumer+downstream→4) | ✅ | bin `meta` host; 3-layer plugin discovery | Format defect fixed (#1) |
| meta_git_cli | ✅ (consumer, notify-parent) | ✅ | bin `meta-git` + run_plugin ✅ | |
| meta_project_cli | ✅ | ✅ | bin `meta-project` ✅ | |
| meta_rust_cli | ✅ | ✅ | bin `meta-rust` ✅ | |
| **parent meta** | ci, on-child-update, on-push-main (release-please), release, semantic-pr-title ✅ | ✅ | host | **the policy exemplar**; main CI red until PR #11 lands; child ci.yml clone steps are anonymous ⇒ sibling repos must stay public |

**A2 (post-canon):** meta_mcp ✅ workflows (consumer) — semantic PR gate via PR#1 · meta-plugins ✅ wf — PR#1 · **meta_dashboard_cli: ZERO workflows, branch `master`, PRIVATE repo — three deviations, needs the full A-template rollout + visibility/branch decisions (human)**.

## Tier B — FlexNetOS tools

| Repo | Branch model | CI | Notable state |
|---|---|---|---|
| weave | develop/master, protected ✅ 6 checks | green | exemplar; workspace = INTERIM (ship-loop-proof supersession) |
| handoff | master | **none** — owned by HFTASK-0012 | kernel published FlexNetOS/handoff; hf ledger live (22 tasks) |
| envctl | master | no .github/workflows dir (local STOP present, sanctioned) | secrets-runtime phases 6–8 = roadmap, do not build against |
| prompt_hub | main | green (1085 tests) | has .kb ✅ + own githooks ✅ |
| lane | main, **protected ✅** | green | fmt+clippy + 2-OS required checks |
| icm | main (fork lineage: rtk-ai) | green | |
| rtk-tokenkill | develop | green | branch-model variance (default main? local develop) — declare |
| atc | main | runs `action_required` (fork-PR approval gating) — approve or adjust settings | has VERSION+toolchain+make+githooks (self-aligned) |
| agent | main, **PRIVATE** | green | guard binary lives here — parent hook depends on it |
| obscura | main (fork lineage) | green | |
| grit | master (fork of upstream) | green (scheduled) | brief says Tier C; org shows fork=true — treat as C |
| hermes-agent | main, fork=true | skipped-only runs | treat as C per brief |
| lifeos | main, **PRIVATE**, no wf | n/a | untriaged |
| claude-plugins | main, **PRIVATE**, no wf | n/a | |
| claude-plugin / copilot-plugin | — | — | parent-repo path aliases (`repo: meta` + `path:`), not separate repos; cosmetic .gitignore listing |

## Tier C — forks (registration/remote/pin/drift only — no FlexNetOS CI forced)

All verified genuine org forks with `upstream` remotes preserved: claude-code, codex, oh-my-claudecode, oh-my-pi, ECC, Archon, n8n (private-sync workflows skip-green), shimmy (+fix PR#1 merged), teri (+fix PR#1 merged), **ruvector → FlexNetOS/meta-ruvector** (org name `ruvector` permanently retired), **ruflo → FlexNetOS/ruflo (created this audit; pin branch pushed)**, kasetto→env_manager_agent (newly adopted). Drift policy: pinned intentionally; per-cluster adopt-or-pin remains open-questions #7.

**Workspace-member forks (teri, shimmy, rtk-tokenkill):** user decision 1072644 makes them parent-CI-gated — their upstream syncs must keep `cargo fmt/clippy/test` green in the meta workspace (this audit's fixes are the template: minimal-drift, conventional commits).

## Tier D — hubs/docs/ops

All registered, tagged, clean, synced. Sampled docs accuracy: template_hub (defines the Hub Standard: registry.json + validate.py CI + README mirror) ✅, mcp_hub (registry + nested n8n-mcp member via its own .meta.yaml) ✅, vault_hub (.agent/ + kasetto/ capability vault) ✅. CodeQL default-setup runs green org-wide (enabled ~04:18Z 2026-06-12 by drdave-flexnetos). flexnetos_{secrets,runner,github_app,wiki,brain}, assets, my-wiki: no CI runs (content-TBD repos), several **PRIVATE** (consistent with ops/secrets roles).

## Org-level inventory deltas

- **Unregistered org repos (disposition = user):** `harness` (fork revfactory/harness), `slim` (fork nilbuild/slim), `global_projects_config` (private, 9KB), `demo-repository` (API timeout during audit — recheck). Recommendation: register as Tier C if they're meant to be workspace members, else archive.
- **Auto-suffix fork artifacts:** `shimmy-1`, `teri-1` — residue of the silent-fork lesson; genuine forks now exist under the proper names. **Recommend deletion (NEEDS-HUMAN: `gh repo delete FlexNetOS/shimmy-1 --yes`, same for teri-1).**
- **Private workspace members:** agent, claude-plugins, database_hub, flexnetos_brain, flexnetos_github_app, flexnetos_secrets, flexnetos_wiki, lifeos, **meta_dashboard_cli**, **meta-plugins**, my-wiki, vault_hub. The two bold ones are A2-tier code repos inconsistent with their 8 public canon peers — and child-repo CI clones run **anonymous**, so any future cross-clone of them breaks. Visibility changes = human decision (2026-06 incident).
- **env_manager_agent** rename to `kasetto` would align repo↔project naming (org-level rename = user call; redirects would cover the old name).

## Loop-harness / STOP states

envctl `_workspace/STOP` PRESENT (sanctioned halt) · ECC, lane, n8n, prompt_hub, weave have `_workspace` with no STOP (running state OK) · kasetto.yaml carriers: envctl only (P6.28 preflight applies there today; handoff gains it via HFTASK-0007).

## Residual nonconformances (ranked)

1. **Protection nowhere except 3 repos** → Phase 4 (apply per-repo real checks; weave = template).
2. **meta_dashboard_cli**: zero CI + private + master — full template rollout + 2 human decisions.
3. **meta_plugin_api** disposition: archive (preferred) or tombstone README; nothing may depend on it (verified: no reverse deps in workspace Cargo.tomls).
4. **handoff CI** = HFTASK-0012 (Phase 5 ships it).
5. atc `action_required` gating (its PRs need manual workflow approval — likely fork-PR setting; harmless but blocks autonomy on that repo).
6. rtk-tokenkill branch-model declaration (develop vs main default).
7. teri/shimmy/grit/obscura/lifeos `untriaged` tags — classify.
8. envctl 'env-ctl' naming residue retirement (memoir item, unchanged).
9. kasetto fork behind upstream (3.0.0 < 3.1.0 installed) — FF the fork (no local drift yet).

## Phase 3 — Stray sweep of /home/drdave (2026-06-12)

| Stray | Verdict | Action taken |
|---|---|---|
| `~/Desktop/idd-merge-idd` (develop, clean, origin already FlexNetOS/rusty-idd — genuine org repo, public) | **ADOPT** | moved → `meta/rusty-idd`, registered in .meta.yaml + .gitignore, origin URL case-normalized |
| `~/Desktop/vox` (rtk-ai/vox checkout on fix/english-defaults) | **ADOPT** | genuine org fork **FlexNetOS/vox** created (parent rtk-ai/vox — same lineage as icm); english-defaults pushed + PR#1 squash-merged into fork main (e0be5c4); origin/upstream rewired; moved → `meta/vox`; registered |
| `~/Desktop/weave` + `~/Desktop/weave-review` (origin = personal drdave-flexnetos/weave) | **PRUNE-duplicate** | proven: every local ref either in meta/weave history or on the personal remote (the 6 "unique" SHAs = P2–P7 repowire-parity feature branches, remote-tracking refs only; features all re-implemented in canonical weave-core). Archived → `~/Desktop/_archives/weave{,-review}-*-pruned-2026-06-12` (no deletion) |
| `~/Desktop/workspaces/kasetto-main` (non-git 3.0.0 archive extract) | **PRUNE** (superseded by `meta/kasetto` clone) | archived → `_archives/kasetto-main-3.0.0-archive-extract` |
| `~/.git` (empty directory, not a repo) | junk | rmdir'd |
| `~/.codex/{memories,.tmp/plugins}` | tool state (codex baseline) | excluded |
| `~/Desktop/workspaces/Devin` | Electron app install (chromium runtime) | excluded (tool, not source) |
| `~/Desktop/workspaces/RustRover-2026.1.2` | IDE | excluded |
| `~/Downloads/tmp/handoff` | older handoff spec, superseded by published FlexNetOS/handoff | inventory note only (Downloads = scratch) |
| `~/Downloads/rusty-idd` | the NOT-real copy (memoir-confirmed) | inventory note only |
| Desktop loose files: `HANDOFF.md` (Ubuntu autoinstall build doc), `SESSION-HANDOFF.md` (old continuation prompt, superseded by meta/SESSION-HANDOFF.md), `weave-x86_64` (ELF build artifact), `mcp-broker-server.py`, yazelix/boot scripts, `n8n.desktop` | loose files, not repos | inventory note; candidates for `_archives` at user's discretion |

## Phase 4 — Org-level GitHub policy (applied 2026-06-12 ~18:20Z)

**Branch protection** applied to 24 repos (verified via GET after PUT). Profile: `required_status_checks {strict: true, checks: <per-repo real PR-running checks>}` · `enforce_admins: false` · **no required reviews** (autonomous-loop compatible; AI gatekeeper becomes a required check when it exists — Phase 5+, never added pre-emptively since a never-reporting required check bricks merges) · `allow_force_pushes: false` · `allow_deletions: false`.

| Group | Repos | Required checks |
|---|---|---|
| parent | meta/main | Clippy, Format, Test×3, Integration Tests×2, Semantic PR Title (8) |
| canon+A2+agent | loop_lib, loop_cli, meta_cli, meta_core, meta_plugin_protocol, meta_git_lib, meta_git_cli, meta_project_cli, meta_rust_cli, meta_mcp (main) | Clippy, Format, Test×3 (+ Semantic PR Title where rolled) |
| meta-plugins | main | Semantic PR Title |
| prompt_hub | main | Check, Clippy, Format, Test (stable)×3, Cargo Audit, Cargo Deny |
| rusty-idd | develop | rust, msrv |
| atc | main | CI |
| anti-force-push only (no PR-running CI yet) | meta_plugin_api, meta_dashboard_cli, obscura, handoff, envctl, vox, icm, rtk-tokenkill | — |
| pre-existing (untouched) | weave/master (6 checks), lane/main (3), .github/main (6 + 1 review) | — |

Check lists were derived from **workflow trigger verification** (PR-running jobs only — push-only checks like `notify (...)`, Release Please, CodeQL dynamic were excluded to avoid bricking merges). Blast-radius note: required-status-checks gate PR merges, not direct pushes, so `auto-format.yml`'s main-pushes keep working.

**Repo settings:** `allow_auto_merge: true` + `delete_branch_on_merge: true` on all 24 + weave + lane (verified on parent).

**Merge-gate Environment (ADR-0001):** deferred to Phase 5 where it's consumed — the environment is created together with the gatekeeper check so protection never references a phantom gate.

**Org secrets:** PARENT_REPO_PAT confirmed org-level (2026-06-11); fresh listing blocked by the permission classifier → NEEDS-HUMAN #2.

## Phase 5 — Autonomous loop end-to-end proof (2026-06-12)

**One full no-human cycle ran in production on FlexNetOS/handoff** (zero mocks; every step witnessed):

```
handoff.task.v1 card ──> weave Job (correlation, fenced attempt_id)
  ──> hf claim (weave lease handoff:claim:<id>)
  ──> fresh worktree (meta git worktree create)
  ──> implement ──> witnessed checkpoints (rusqlite + rvf-crypto chain)
  ──> hf ship  (squash commit → push → PR → NATIVE auto-merge armed → pr_opened)
  ──> 4 REQUIRED checks green ──> GitHub auto-merged (NO agent merge action)
  ──> verdict round-trip (weave permission ask → review_verdict ledger event)
  ──> develop fast-forward ──> hf handoff packet ──> weave job result
```

| Evidence | Value |
|---|---|
| Task A (HFTASK-0012 slice) | handoff PR#2 merged `00fdf85` — CI born green; Test(ubuntu/macos)+Clippy+Format now **required, strict** on protected master |
| Task B (HFTASK-0009 slice) | **`hf ship` bootstrapped itself** — its first run shipped its own implementation; PR#3 merged `1894a7c` **by GitHub-native auto-merge** |
| Verdict channel (HFTASK-0010 R6 slice) | weave ask `ask_66_1781294399867172` → answer `approve` → `review_verdict` in the witnessed ledger (never a GitHub APPROVE) |
| ADR-0002 | weave a2a conventions (5-surface contract + subprocess transport rule + stale-binary preflight) merged to handoff/docs |
| Witness chain | 16 events verified (`hf handoff`) |
| weave jobs | job_1781288389… (A), job_1781288736… (B) — both `completed` with result payloads |

**Honest gaps** (tracked on cards, not hidden): reviewer was the orchestrator stand-in (separate-role cloud_ultra/swarm = HFTASK-0010 remainder); `pr_opened` wrote to the worktree's ledger (session-ledger location = HFTASK-0007 design point; canonical copy checkpointed in the main ledger); `--batch`/cycle-counter not built (deps 0007/0008); kasetto `sync --locked` preflight lands with the 0007 session verb; HFTASK-0003/0019 (Intent→envelope synthesis + transport decision ADR) and RuVocal (0022) untouched per the locked readiness order. Operational gotchas: `~/.cargo/bin/weave` is stale (pre-lease) — `HF_WEAVE_BIN` must point at the canonical meta/weave build; handoff CI clones meta-ruvector as a sibling for ledger's rvf-crypto path dep.

## Research / Cross-References

Live: `gh api orgs/FlexNetOS/repos` (69 repos), per-repo `/branches/<default>/protection` (3 hits), `/actions/runs` per member, PR checks for #11/meta_cli#1. Code: worktree `org-audit-ci-fixes` diffs + verification logs (/tmp/wt-verify2.log: fmt 0 / clippy 0 / tests all-ok). Memoir: `policy-v2-meta-org`, `ship-loop-proof-2026-06-12`, `adr-2026-06-11-open-questions` (#5 resolved here, #7/#10/#11 statuses), `decision-log-2026-06-09`. Data files: /tmp/fleet.json, /tmp/org-repos.jsonl.
