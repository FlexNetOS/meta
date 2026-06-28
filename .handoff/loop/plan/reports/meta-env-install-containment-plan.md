# Plan: meta env install containment, Yazelix/Nix boundary, and filesystem layout bridge

- Date: 2026-06-28
- Target: `meta-env-install`
- Sources: `findings/filesystem-layout-meta-env-install.md`, `findings/governance-config-meta-env-install.md`, live command evidence captured 2026-06-28.

## Verdict

**Recommendation:** keep envctl's `$META_ROOT` FHS/XDG overlay as the canonical architecture, but formalize the bridge model: core tools move to regular `$META_ROOT/usr/bin` frontdoors; `.local/bin` becomes compatibility-only; `/nix/store` becomes an explicit host-prerequisite package provider; Yazelix is activated through a meta-owned `yzx` wrapper that uses Yazelix's runtime/config/state root contract instead of exporting its Nix `toolbin` globally.

**Confidence: High** for the layout and boundary diagnosis because it is backed by envctl docs/gates, live command routing, live path inspection, and Yazelix's own Nix/runtime contracts. **Confidence: Medium** for the migration sequence because it needs implementation-time parity tests across interactive shells, desktop launchers, and Yazelix sessions.

## Current architecture

Source: `envctl/docs/adr-install-locations-and-local-state.md:32-51`; `envctl/manifest/nix-yazelix.toml:5-248`; `yazelix/docs/contracts/runtime_root_contract.md:5-16`; live PATH/type evidence 2026-06-28.

```
        host/user shell today
┌────────────────────────────────────┐
│ PATH starts with $HOME/.local/bin   │
│ + /nix/store/...-yazelix/toolbin ⚠  │
└───────────────┬────────────────────┘
                │ resolves through bridges / direct store paths
                ▼
┌─────────────────────────────────────────────────────────────────┐
│ $META_ROOT                                                       │
│ ┌────────────────────┐  ┌────────────────────┐  ┌─────────────┐ │
│ │ .local/bin ⚠       │  │ usr/bin ⚠          │  │ .toolchains │ │
│ │ meta, loop, rtk    │  │ envctl,codex,kache │  │ cargo,nix   │ │
│ │ primary today      │  │ mixed wrappers and │  │ node,bun... │ │
│ │                    │  │ symlink frontdoors │  │             │ │
│ └────────────────────┘  └────────────────────┘  └─────────────┘ │
│ ┌────────────────────┐  ┌────────────────────┐  ┌─────────────┐ │
│ │ var/lib|cache|log  │  │ .local/share|state │  │ .meta       │ │
│ │ envctl state       │  │ app/XDG + nix prof │  │ plugins/pol │ │
│ └────────────────────┘  └────────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                │
                │ owner-wall host prerequisite
                ▼
┌────────────────────────────────────┐
│ /nix/store                         │
│ immutable Yazelix package closure  │
│ bin/yzx + private libexec/toolbin  │
└────────────────────────────────────┘
```

Hotspots/drift:
- `⚠ .local/bin` is primary for core meta tools even though envctl's canonical bin is `usr/bin`.
- `⚠ usr/bin` contains symlinks although policy wants regular executable wrappers.
- `⚠ /nix/store/.../toolbin` appears in the global shell PATH; it should be activation-scoped.
- root generated directories are visible as untracked repo state.

## Target architecture

Source: `envctl/README.md:53-68`; `envctl/home/README.md:4-15`; `yazelix/docs/contracts/runtime_root_contract.md:98-129`; `yazelix/docs/contracts/runtime_distribution_capability_tiers.md:34-58`.

```
        host/user shell target
┌────────────────────────────────────┐
│ PATH: $META_ROOT/usr/bin first [A] │
│ $HOME/.local is one bridge only     │
└───────────────┬────────────────────┘
                ▼
┌─────────────────────────────────────────────────────────────┐
│ $META_ROOT as synthetic FHS/XDG prefix                       │
│ ┌────────────────────┐  ┌─────────────────────────────────┐ │
│ │ usr/bin [A]        │  │ component payload roots          │ │
│ │ regular wrappers   │─▶│ usr/lib, usr/libexec, usr/share  │ │
│ │ meta, rtk, yzx     │  │ opt/<component>, .toolchains     │ │
│ └────────────────────┘  └─────────────────────────────────┘ │
│ ┌────────────────────┐  ┌─────────────────────────────────┐ │
│ │ var/lib/cache/log  │  │ app XDG roots                    │ │
│ │ envctl ops state   │  │ .config, .local/share|state      │ │
│ └────────────────────┘  └─────────────────────────────────┘ │
└───────────────┬─────────────────────────────────────────────┘
                │ `yzx` wrapper activates, not global PATH
                ▼
┌─────────────────────────────────────────────────────────────┐
│ Yazelix adapter                                              │
│ YAZELIX_RUNTIME_DIR=/nix/store/...-yazelix [H/owner-wall]    │
│ YAZELIX_CONFIG_DIR=$META_ROOT/.config/yazelix               │
│ YAZELIX_STATE_DIR=$META_ROOT/.local/share/yazelix           │
│ PATH += runtime toolbin only inside `yzx env|enter|run` [A]  │
└─────────────────────────────────────────────────────────────┘
```

## Engineering and architecture reasoning

### 1. Upstream/meta vs envctl overlay

Upstream `gitkb/meta` defaults are intentionally user-local (`$HOME/.local/bin`, `~/.meta`, Cargo default bin). FlexNetOS/envctl is therefore not just a convenience layer; it is the containment layer that converts upstream user-local assumptions into a meta-owned install graph. That means envctl must be judged by two different criteria:

- **Containment:** does every active install path resolve inside `$META_ROOT`, or is it a declared host prerequisite/mutation?
- **Filesystem semantics:** does each path land in the right kind of directory (`bin`, `libexec`, `share`, `var`, XDG config/data/state/cache)?

Current state mostly satisfies containment through symlink bridges, but does not yet satisfy filesystem semantics because `.local/bin` and global Yazelix toolbin are still primary activation surfaces.

### 2. Yazelix/Nix does not break the design if it is an owner-wall provider

Nix's store is not portable in the same way `$META_ROOT/.toolchains` is portable. `/nix/store` is a host package store with root/daemon semantics, content-addressed immutable paths, and optional `/etc/nix` daemon configuration. Pretending envctl owns `/nix/store` would make the design dishonest.

But Yazelix improves the architecture because it already names the missing abstraction: runtime root, config root, generated state root, and distribution/update owner. Envctl should copy that model for every external tool: payload root, frontdoor root, config root, state/cache root, host prerequisites, host mutations, activation scope, reset/revert contract.

### 3. The current tree drifts from standard filesystem organization

- Executables are split between `.local/bin` and `usr/bin`; canonical frontdoors are not singular.
- Private helpers and runtime tool surfaces can leak into global PATH; Yazelix `toolbin` should be activation-scoped.
- Mutable state/cache/config appears in root-level dot dirs and generated roots that git sees as untracked work.
- `.meta` is both upstream project-local plugin surface and local policy/registry state; it needs stronger ownership labels.
- `/etc` and update-alternatives mutations are real system-depth operations; they must remain owner-wall and reversible.

### 4. Risk and impact

| Risk | Impact | Evidence |
|---|---|---|
| Accidental commits of generated env/user state | High context burn, secret/state exposure risk, PR noise | `git status` shows `.local/`, `.config/`, `.cargo/`, `usr/`, `var/`, etc.; most are not ignored |
| PATH shadowing | Wrong binary, wrong version, hard-to-reproduce shells | current PATH starts with `$HOME/.local/bin` and includes `/nix/store/...-yazelix/toolbin` |
| Frontdoor symlink drift | Verifiers think a frontdoor exists but do not verify wrapper policy/activation env | live `usr/bin` contains many symlinks; policy wants regular wrappers |
| Hidden system-depth exceptions | Portability claims become false; reset cannot restore host | Nix cache and terminal alternatives mutate `/etc/nix` and `/usr/bin/x-terminal-emulator` |
| Mixed profile ownership | `nix profile add/remove` may target default user profile semantics rather than declared meta profile | manifest uses implicit `nix profile add`; live profile bridge exists under meta |
| Foundation/overlay drift | FlexNetOS additions can replace upstream contracts instead of overlaying them | prior KB incident `incidents/foundation-drift-kb-first-redirect` |

## Sequenced upgrade roadmap

1. **Detector first — no movement yet.**
   - UPGRADE: add live layout classification to `envctl doctor` and CI. | axis: quality | evidence: `filesystem-layout-meta-env-install.md` | blast: read-only | risk: low | verdict: CONFIRMED
   - Acceptance: doctor reports current `.local/bin`, `usr/bin` symlink, root-ignore, and Yazelix PATH classifications.

2. **Normalize activation env.**
   - UPGRADE: make all activation scripts use `envctl env --toolchains` semantics: `$META_ROOT/usr/bin` first, `.local/bin` compatibility second, no global Yazelix toolbin except inside `yzx`. | axis: quality | evidence: live `envctl env --toolchains` vs current PATH | blast: shell/session | risk: medium | verdict: CONFIRMED
   - Acceptance: fresh shell `type -a meta yzx nix` routes through `$META_ROOT/usr/bin` wrappers or declared profile, not `.local/bin`/store toolbin first.

3. **Core frontdoor convergence.**
   - UPGRADE: create regular `$META_ROOT/usr/bin` wrappers for core meta tools and keep `.local/bin` compatibility until parity-proven. | axis: quality | evidence: live tool routes and `envctl/README.md:53` | blast: all agents | risk: medium | verdict: CONFIRMED
   - Acceptance: versions/plugin discovery unchanged; `meta plugin list` still finds intended project-local plugins.

4. **Yazelix/Nix owner-wall adapter.**
   - UPGRADE: add `$META_ROOT/usr/bin/yzx` wrapper and explicit profile path handling. | axis: quality | evidence: `envctl/manifest/nix-yazelix.toml`; Yazelix runtime-root contract | blast: terminal workflow | risk: medium | verdict: QUALIFIED(needs interactive + desktop verification)
   - Acceptance: `yzx --version`, `yzx env --no-shell`, `yzx doctor`, desktop launch, and shell auto-enter work without global store toolbin in base PATH.

5. **Repo cleanliness and generated-root ignore policy.**
   - UPGRADE: ignore generated env roots or relocate track-worthy policy files out of generated roots first. | axis: governance+settings+config | evidence: root `git status` and check-ignore output | blast: repo hygiene | risk: medium | verdict: QUALIFIED(needs owner review of `.meta` contents)
   - Acceptance: `git status --short` no longer lists generated env roots while still surfacing intentional source/doc changes.

6. **Foundation/overlay verifier.**
   - UPGRADE: diff upstream `gitkb/meta` foundation surfaces and classify local deviations as baseline, overlay, Codex parity, or unsafe drift. | axis: governance+settings+config | evidence: PR #90 / KB incident foundation-drift | blast: docs/settings/hooks | risk: medium | verdict: CONFIRMED
   - Acceptance: verifier output explains every `.claude`, `.codex`, `.kb`, hook, and path-policy delta.

## Tool evaluation

| Tool/surface | Recommendation | Rationale |
|---|---|---|
| `envctl` | upgrade/enforce | Correct target architecture exists; live-state verifier and frontdoor convergence are missing. |
| `meta` CLI/plugins | hold behavior, migrate placement | Functioning at `meta 0.2.25`; move placement without changing behavior. |
| `rtk` | hold placement until frontdoor convergence | Required command prefix; currently inside meta but routed from `.local/bin`. |
| Nix / Determinate Nix | hold as host prerequisite | Required by Yazelix; classify `/nix` and `/etc/nix` as owner-wall host surfaces. |
| Yazelix `yzx` | upgrade integration | Yazelix's runtime/config/state root model should become the envctl adapter pattern; add meta wrapper and activation scoping. |
| `.local/bin` | deprecate to compatibility | Keep only while parity checks prove `$META_ROOT/usr/bin` frontdoors. |
| `/nix/store/.../toolbin` in global PATH | remove from base PATH | Keep available only through Yazelix activation to avoid global shadowing. |

## Governance, settings, and config

- APPLY: read-only detectors and documentation/report artifacts.
- PROPOSE: PATH order changes, frontdoor wrapper migration, `.gitignore` changes, explicit Nix profile path migration, `$META_ROOT/usr/bin/yzx` wrapper, and host mutation modeling.
- REGENERATE: any generated frontdoors, desktop entries, environment snippets, and Nix/Home Manager profiles through their owning tools.
- OWNER-WALL: `/nix`, `/etc/nix`, `nix-daemon`, update-alternatives, desktop default terminal, and any host profile outside the sanctioned bridge.

## Test Strategy & Coverage

Current coverage for this audit is evidence-based, not an implemented test suite. The missing gates should be handed to Feature Forge/envctl implementation.

### FF test-build spec

- **Case 1: layout classifier golden** — Given a synthetic `$META_ROOT` with `usr/bin` regular wrapper, symlink wrapper, direct binary copy, `.local/bin` binary, `.toolchains` payload, and `/nix/store` reference, assert classifier returns `canonical`, `drift`, `legacy-compat`, `toolchain`, and `owner-wall` respectively.
- **Case 2: PATH precedence golden** — Given `envctl env --toolchains`, assert `$META_ROOT/usr/bin` precedes `$META_ROOT/.local/bin` and Yazelix `toolbin` is absent from base PATH.
- **Case 3: Yazelix wrapper integration** — With a fake profile `bin/yzx` and fake runtime root, assert `$META_ROOT/usr/bin/yzx` exports `YAZELIX_RUNTIME_DIR`, `YAZELIX_CONFIG_DIR`, `YAZELIX_STATE_DIR`, XDG roots, then execs profile/store `yzx`.
- **Case 4: Nix host mutation ownership** — Given manifest-owned `/etc/nix/nix.custom.conf` lines, assert reset removes exact owned lines and leaves foreign lines.
- **Case 5: generated root ignore guard** — Assert `git status --short` in a fixture does not surface generated env roots after ignore policy, while source docs still appear.

## Gaps

- The audit did not run full interactive Yazelix launch/desktop flows; the migration needs GUI/session verification before changing global PATH.
- The audit did not implement the detector or wrappers; it produces a design and Feature-Forge-ready test handoff.
- The `.meta` directory needs owner review before any ignore/relocation policy because it contains both generated plugins and policy/registry documents.
- The local env includes a failed last envctl reset in `envctl doctor`; this should be investigated separately before relying on reset as migration rollback proof.

## Confidence

High for diagnosis, medium for migration sequencing. Confidence would become high after a read-only classifier lands and captures the current drift automatically across login shell, Codex shell, Yazelix `yzx env`, and desktop launcher environments.
