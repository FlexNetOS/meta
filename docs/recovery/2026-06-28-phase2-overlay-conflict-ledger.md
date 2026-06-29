# Phase 2 Overlay Conflict Ledger and Roadmap — 2026-06-28

## Hard gate

This is a planning artifact only. Do **not** implement any Phase 2 overlay until the owner reviews this ledger and explicitly approves the next PR. The clean-room foundation remains live `gitkb/meta` main at `fe19560b210eeb3a101565ccd021ab63aff71f8c`.

## Evidence used

All classifications below are grounded in the Phase 1 archive at `/home/drdave/Desktop/meta-cleanroom-recovery/archives/20260628T185753Z`.

Primary evidence files:

- `inventory/tracked-overlay-name-status-gitkb-to-flexnetos.txt` — 144 tracked additions and 47 tracked modifications from upstream `gitkb/meta` to current `FlexNetOS/meta` main.
- `inventory/root-git-status-short.txt` — untracked host/runtime roots in the current workspace.
- `inventory/overlay-target-paths.tsv` — targeted overlay path existence, git status, and sizes.
- `inventory/child-repo-inventory.json` — 71 configured projects; 65 independent child repos; 4 missing paths; 2 root-repo subdirs.
- `inventory/cleanroom-foundation-verification.txt` — clean-room foundation proof.
- `logs/archive-integrity-tests.log` — archive checksum and zstd integrity proof.

## Conflict ledger

| # | Intended upgrade area | Classification | Evidence | Known conflicts | Reapply strategy | Required verifier before merge |
| ---: | --- | --- | --- | --- | --- | --- |
| 1 | KB/FlexNetOS docs and tasks (`.kb/store`, `NORTH-STAR.md`, `ARCHITECTURE-TRUTH.md`, `GAP-REGISTER.md`, task/spec docs) | Promote selected docs to KB source truth; archive generated/stale docs | `.kb/AGENTS.md` was modified; `.kb/store/*` has tracked additions; context docs are present in archive | Upstream is GitKB-first (`context_source: gitkb`, `.kb/workspace/`); drifted workspace rewrote this to FlexNetOS and `.kb/workspaces/main/`; some source-truth-looking docs live under `obsolete/` or generated handoff projections | Migrate through `git kb` on the clean foundation. Do not raw-copy `.kb/store` wholesale. Create a slug mapping and mark generated `hf sync` outputs as projections, not source truth. Promote durable planning docs only after source/evidence review. | `git kb list --path context/`, `git kb status`, `git kb board --all`, slug mapping review, and a clean `git diff` showing no generated workspace dump committed |
| 2 | `.kb/workspace/` vs `.kb/workspaces/main/` layout | Reject drifted layout as direct copy; preserve as migration evidence | Current `.kb/AGENTS.md` references `.kb/workspaces/main/`; clean-room `.kb/AGENTS.md` references `.kb/workspace/` | Agents and tooling will disagree about the edit surface if both layouts are treated as canonical | Keep upstream `.kb/workspace/` as the source layout. If compatibility is needed, add a generated compatibility projection or documented shim after verifier proves no silent drop. | `git kb checkout --path context/` materializes exactly where AGENTS says; no stale second workspace is tracked |
| 3 | Source-truth docs under `obsolete/` | Promote or archive-only case-by-case | KB board listed `obsolete/*` tasks; overlay diff adds several planning docs | `obsolete/` cannot be source truth without defeating the clean-room recovery; stale tasks may be mistaken for approved direction | For each doc: classify as active KB task/spec, historical reference, or reject. Move active material into KB with explicit provenance. Keep obsolete originals archive-only unless owner approves resurrection. | Per-doc decision log and `git kb graph` links for promoted docs |
| 4 | Codex path/toolchain config (`.codex`, `.agents`, `.cargo/config.toml`, RTK/front-door notes) | Keep as overlay, not foundation | Tracked additions include `.codex/*`, `.agents/*`, `.cargo/config.toml`; untracked `.codex/tmp/` and tool caches are present | Toolchain config can silently change PATH, Python, Cargo, Codex hooks, or front-door behavior. Owner requires envctl installs target `$META_ROOT/.local`; no symlink frontdoors inside `meta/.local`. | Land a minimal Codex/meta overlay PR that extends upstream rather than replacing it. Source install behavior from envctl, not handwritten root files. Generated temp/cache paths stay ignored. | `type -a codex rtk python python3 cargo`, symlink target checks, PATH-order report, hook dry-run, and no tracked `.codex/tmp/` |
| 5 | `.claude` parity and Claude-era commands/skills | Keep as extension overlay | Tracked modifications and additions under `.claude/*`; clean-room has compact 23-file upstream `.claude` baseline | Overlay currently modifies baseline files and adds hooks/commands. Replacing upstream baseline would be a downgrade. Developer policy says preserve `.claude/settings.json` Bash push permission additions as intentional unless owner asks to remove them. | Merge additively. Keep upstream `.claude` files intact where possible; add FlexNetOS behavior as scoped commands/skills/rules. Any modification needs a before/after rationale and parity verifier. | Diff review proving additive merge, settings permission audit, command smoke tests |
| 6 | envctl/yazelix portable runtime | Convert to generated projection/runtime; source truth in child repos | `envctl` exists as a 126G child repo; `yazelix` exists as a 2.5G child repo; untracked `.local/` is 79G | Runtime payloads can pollute root git status; prior drift mixed install artifacts into root. Strict rule: envctl installs target `$META_ROOT/.local`; only real-home `.local` object may be bridge symlink to `$META_ROOT/.local`. | Do not copy runtime files into source. Recreate from envctl/yazelix installers into `.local` after the source overlay is approved. Track only installer manifests, policy, and verifiers. | `envctl` install dry-run/apply logs, `$META_ROOT/.local` target proof, no tracked `.local`, path/symlink verifier |
| 7 | `.context` and `.handoff` continuity state | Mixed: promote durable decisions; regenerate projections; archive volatile loop state | `.context` 52K; `.handoff` 26M at root; tracked overlay adds `.handoff/*` reports, ADRs, loop files, and ledger event JSONL | `.handoff` contains generated loop outputs and runtime continuity state. Binary ledgers must not be committed; durable decisions should not be trapped in generated packets. | Promote ADRs/NORTH-STAR-style durable decisions into KB/docs. Regenerate `.handoff` via `hf init`/kernel tooling on clean foundation. Keep `loop/HANDOFF.md`, packets, and ledger projections archive-only unless a source-truth policy says otherwise. | `hf resume`, `hf drift`, no committed binary ledger, generated-file marker audit |
| 8 | Meta workspace registration (`.meta.yaml`, Cargo workspace, `.github` workflows) | Keep as overlay after reconciliation | `.meta.yaml`, `Cargo.toml`, `Cargo.lock`, `.github/*`, `Makefile` are modified; child inventory reports missing `assets`, `flexnetos_brain`, `flexnetos_wiki`, `my-wiki` | Missing repos make `meta git status` fail. Cargo lock drift may reflect child workspace upgrades and must not be blindly reversed. GitHub workflow reuse vs duplicate org workflows remains unresolved. | Rebuild `.meta.yaml` from live repo evidence. Remove or mark missing repos only by approved policy, never as destructive cleanup. Preserve lockfile upgrade drift when backed by child manifest changes. Rewire workflows in a dedicated PR if reusable org workflows are source truth. | `rtk meta project check`, `rtk meta git status` with no missing paths, `cargo metadata`, workflow lint/dry-run |
| 9 | Hooks/statusline/vox/ollama/verifier/ide-index | Keep as optional overlay behind fail-closed verifiers | Tracked additions include `.claude/hooks/*`, `.claude/statusline-command.sh`, `ollama-provider`, `verifier-cli`, `ide-index-mcp`; `.codex/hooks.json` exists | Hooks can block or mutate developer workflows; local-model/IDE dependencies may be absent. | Land behind explicit enablement flags. Prefer fail-closed checks for destructive operations and fail-open informational status only where documented. Keep provider assumptions out of foundation. | Hook unit/smoke tests, disabled-by-default check where appropriate, `ollama`/vox/verifier presence probes |
| 10 | Untracked home/runtime roots (`.local`, `.cargo`, `.rustup`, `.config`, `usr`, `etc`, `var`, shell rc files) | Archive-only or generated projection; reject as tracked source | Root untracked status includes `.local/`, `.cargo/registry/`, `.rustup/`, `.config/`, `usr/`, `etc/`, `var/`, shell dotfiles; sizes captured in `overlay-target-paths.tsv` | These paths make root status noisy and can leak machine-specific state. Some contain root-owned container and application runtime data. | Keep out of git. Add/repair ignore and residency policy only after source-truth review. Recreate with envctl/runtime installers; restore from archive only for forensic rollback. | `git status --short --untracked-files=all` excludes generated roots after ignore policy; installer can recreate required state |
| 11 | Python compatibility | Keep as toolchain policy overlay | Archive `tool-versions.txt` records `python3`; plan identified `python` missing while `python3` exists as a conflict class | Scripts may use `python` shebangs and fail on clean machines. | Prefer `python3` in scripts or provide an envctl-managed shim with explicit provenance. Do not assume system `python`. | `grep -R "python" scripts .codex .claude .agents`, `python3 --version`, script dry-runs |
| 12 | LifeOS / Odysseus / front-door planning direction | Promote to KB planning source truth; no runtime overlay yet | Child repo `lifeos` exists; `.local/share/odysseus/*` appeared as runtime data in the archive; owner context says LifeOS is the end-all app and Odysseus should be evaluated as the AI chat UI front door | Runtime app data is not a repo source. The front-door direction is strategic and must not be mixed into foundation files before a planning pass. | Create a KB planning task/spec that maps LifeOS, Odysseus, prompt_hub, meta-ruvector, rusty-idd, weave, handoff, network-control/lane/obscura, envctl, and other meta components. Install/evaluate Odysseus only in an approved runtime PR. | Planning-engineer report, source links for each component, install/evaluation transcript, no `.local/share/odysseus` tracked |
| 13 | Child repo upgrade state and branches | Preserve as evidence; reconcile per repo | Child inventory captured branch, HEAD, upstream, origin, and status; 65 bundles were created | This meta workspace is not a monorepo. Child repo state must not be collapsed into root commits. Many children are on feature branches. | Handle each child repo through its own branch/PR if changes are needed. Root only records registration and policy. | Per-repo `git status`, branch/PR mapping, no child source copied into root |

## Phase 2 implementation roadmap

Each row below is a separate owner-approved PR class. Do not combine classes unless the owner explicitly approves the combined scope.

1. **KB source-truth migration PR**
   - Inputs: `.kb/store`, root planning docs, `obsolete/*` candidates.
   - Output: clean GitKB documents/tasks/specs with slug mapping and provenance.
   - Gate: KB status clean; no raw generated workspace dump.

2. **Workspace manifest and build/CI reconciliation PR**
   - Inputs: `.meta.yaml`, `.github/*`, `Cargo.toml`, `Cargo.lock`, `Makefile`.
   - Output: live repo list with missing-path policy; strict-upgrade lock/manifest proof; workflow reuse decision.
   - Gate: `rtk meta project check`, `rtk meta git status`, `cargo metadata`, workflow validation.

3. **Agent configuration overlay PR**
   - Inputs: `.claude`, `.codex`, `.agents`, `.junie`, `.ai/mcp`.
   - Output: additive agent/command/hook config extending upstream baseline.
   - Gate: command smoke tests, hook dry-run, settings audit.

4. **envctl/yazelix runtime projection PR**
   - Inputs: envctl/yazelix child repos and installer policy.
   - Output: source-controlled installer manifests and verifiers only; generated files remain ignored.
   - Gate: `$META_ROOT/.local` proof, symlink/path verifier, no tracked runtime roots.

5. **Continuity kernel / handoff PR**
   - Inputs: `.handoff` ADRs/reports and `hf` kernel state.
   - Output: durable decisions promoted; generated loop/ledger projections regenerated or ignored.
   - Gate: `hf resume`, `hf drift`, no committed binary ledgers.

6. **Tool hooks and local intelligence PR**
   - Inputs: vox, ollama, verifier-cli, ide-index, statusline, hook scripts.
   - Output: opt-in/fail-closed tools with dependency probes.
   - Gate: provider probes and hook tests.

7. **Runtime/home-root containment PR**
   - Inputs: `.local`, `.cargo`, `.rustup`, `.config`, `usr`, `etc`, `var`, shell dotfiles.
   - Output: ignore/residency policy and restore/regenerate docs; no machine state tracked.
   - Gate: root `git status` no longer reports generated roots after policy application.

8. **LifeOS/Odysseus/front-door planning PR**
   - Inputs: LifeOS, Odysseus runtime evidence, prompt_hub, meta-ruvector, rusty-idd, weave, handoff, network-control/lane/obscura, envctl.
   - Output: KB-backed planning-engineer report for full component integration; no implementation.
   - Gate: cited component map and owner approval for any later install/eval PR.

## Non-negotiable implementation rules after owner approval

- One PR per overlay class unless the owner explicitly combines classes.
- Every overlay must cite Phase 1 archive evidence or live upstream/source evidence.
- No generated artifact becomes source of truth.
- No destructive reset/unregister/delete occurs just to make the clean room look tidy.
- No child repo changes are landed through the root meta repo.
- Preserve strict-upgrade-only policy: do not downgrade lockfiles, manifests, toolchains, hooks, or config unless replacement parity is proven.
- Preserve upstream `gitkb/meta` foundation semantics unless an approved overlay intentionally extends them.

## Stop point

Phase 2 planning is complete enough to review. Phase 2 execution is blocked here pending explicit owner approval.
