# Plan: Yazelix portable Nix containment bridge

- Date: 2026-06-28
- Target: `yazelix-nix-portable-bridge`
- Canonical research: `../research/yazelix-nix-portable-bridge.trends.md`
- Local base plan: `meta-env-install-containment-plan.md`
- Scope: docs/architecture plan only; no production code was changed.

## Verdict

**Recommendation:** build a **Yazelix Runtime Provider Adapter** in envctl. Keep the current system Nix lane as an explicit OWNER-WALL provider, add a meta-local **nix-portable provider** as the confinement/portability bridge, and add a separate titan/offline bundle lane for immutable release artifacts. Do **not** treat nix-bundle/AppImage as the primary bridge for everyday mutable Yazelix because it solves distribution, not profile/update/config/state ownership.

**Confidence: Medium-High.** Yazelix's current docs confirm the activation/config/profile boundaries, and nix-portable directly solves rootless virtualized `/nix/store` with a relocatable state root. Confidence is not High until the adapter is implemented and verified in a clean environment without host `/nix` or real-home Nix profile dependencies.

## Current problem map

Source: `envctl/manifest/nix-yazelix.toml:5-240`; `meta-env-install-containment-plan.md:13-52`; `../research/yazelix-nix-portable-bridge.trends.md`.

```
        current base shell / envctl manifest
┌──────────────────────────────────────────────┐
│ $META_ROOT/.bashrc sources system nix [A]    │
│ PATH += $META_ROOT/.nix-profile/bin [A]      │
│ yzx enter may expose /nix/store/toolbin ⚠    │
└──────────────────────┬───────────────────────┘
                       ▼
┌──────────────────────────────────────────────┐
│ implicit provider: system Nix                │
│ /nix + nix-daemon + /etc/nix cache lines [H] │
│ default/user profile semantics ⚠             │
└──────────────────────┬───────────────────────┘
                       ▼
┌──────────────────────────────────────────────┐
│ Yazelix Nix closure                          │
│ bin/yzx + curated toolbin + libexec          │
│ config/state mostly under XDG/user roots ⚠   │
└──────────────────────────────────────────────┘
```

Drift classes:

- **Confinement leak:** the current Nix/Yazelix manifest relies on `/nix`, `/etc/nix`, nix-daemon, and implicit profile commands.
- **Portability leak:** cloning/moving `$META_ROOT` does not carry the Nix store/profile dependency.
- **Activation leak:** Yazelix's runtime toolbin can end up in the base shell PATH instead of only inside `yzx env|enter|run`.
- **Ownership ambiguity:** update owner is implicit (`nix profile add/upgrade`) instead of a declared provider/profile path.

## Target architecture

Source: `../research/yazelix-nix-portable-bridge.trends.md`; `envctl/README.md:53-68`; `envctl/manifest/nix-yazelix.toml:118-190`; Yazelix installation/troubleshooting upstream sources listed in research.

```
                      envctl provider selection [P]
┌──────────────────────────────────────────────────────────────────┐
│ $META_ROOT                                                       │
│                                                                  │
│  frontdoor                                                       │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ usr/bin/yzx [A]                                            │  │
│  │ - sets HOME/XDG to $META_ROOT                              │  │
│  │ - sets YAZELIX_CONFIG_DIR / STATE_DIR                      │  │
│  │ - selects provider: system-nix | nix-portable | bundle     │  │
│  │ - never exports toolbin in base shell                      │  │
│  └───────────────┬────────────────────────────────────────────┘  │
│                  │                                                │
│  provider roots  │                                                │
│  ┌───────────────▼────────────┐  ┌─────────────────────────────┐ │
│  │ system-nix [H]             │  │ nix-portable [A/P]          │ │
│  │ /nix, /etc/nix, daemon     │  │ NP_LOCATION=$META_ROOT/...  │ │
│  │ fastest dev lane           │  │ virtual /nix/store under    │ │
│  │ explicit OWNER-WALL        │  │ meta state/cache            │ │
│  └───────────────┬────────────┘  └──────────────┬──────────────┘ │
│                  │                              │                │
│                  └──────────────┬───────────────┘                │
│                                 ▼                                │
│  runtime binding                                                │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ Yazelix runtime/profile/closure                            │  │
│  │ toolbin is activation-scoped by yzx env|enter|run [A]       │  │
│  └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│  titan lane                                                      │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ bundle artifact [H/P]                                      │  │
│  │ single file / AppImage / bundle-dir for offline launches    │  │
│  │ immutable, measured, not the mutable update owner           │  │
│  └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

## Current-repo reuse correction (verified 2026-06-28)

`envctl` already contains an additive `nix-portable` component in `envctl/manifest/components.d/epic-h-toolchains.toml` (`id = "nix-portable"`) with a lock entry in `envctl/manifest/envctl.lock`. Feature Forge must reuse that existing component first. The provider adapter is therefore a wiring/classification/wrapper/proof task, not a from-scratch Nix-portable installer. Any later move from the existing `.toolchains/nix-portable` payload root to `.local/share/envctl/providers` or `$META_ROOT/opt/nix-portable` is a separate strict-upgrade migration that needs parity proof.

## The gap bridge: `YazelixRuntimeProvider`

Define the adapter contract before implementation:

```text
provider.id                 system-nix | nix-portable | bundle
provider.runtime_root       /nix/store/... | $META_ROOT/.local/state/nix-portable/.nix-portable/store/... | bundle mount/extract root
provider.profile_root       host profile | $META_ROOT/.local/state/envctl/profiles/yazelix | read-only bundle
provider.config_root        $META_ROOT/.config/yazelix
provider.state_root         $META_ROOT/.local/share/yazelix
provider.cache_root         $META_ROOT/.cache/yazelix and/or $META_ROOT/var/cache/envctl/yazelix
provider.update_owner       nix profile | nix-portable nix profile | bundle build pipeline
provider.host_interfaces    display sockets, ptys, /tmp, /run/user/$UID, fonts/GPU as declared interfaces
provider.prohibited_writes  real $HOME, /etc/nix, /nix, /usr outside system-nix owner-wall mode
```

### Lane 1 — `system-nix` provider (keep, but label honestly)

Purpose: fast developer workstation integration.

- Keep existing Determinate/system Nix support.
- Classify `/nix`, nix-daemon, `/etc/nix/nix.custom.conf`, and update-alternatives as OWNER-WALL.
- Replace implicit `nix profile add/upgrade` with explicit provider-owned profile path where possible.
- Add `$META_ROOT/usr/bin/yzx` wrapper that sets meta XDG roots and calls the provider's profile/store `yzx`.
- Acceptance: base shell PATH has no `/nix/store/*-yazelix*/toolbin`; `yzx env --no-shell` is the only non-Zellij path that emits curated Yazelix tool PATH.

### Lane 2 — `nix-portable` provider (the confinement/portability bridge)

Purpose: run Yazelix with Nix rooted under `$META_ROOT`, without host `/nix`, `/etc/nix`, or real-home profile ownership.

Proposed layout, reconciled with the owner wake-up that envctl installs target `$META_ROOT/.local`:

```text
$META_ROOT/.local/bin/nix-portable                 compatibility/user bridge if needed
$META_ROOT/.toolchains/nix-portable/bin/nix-portable  # existing envctl component; future payload-root migration is separate
$META_ROOT/.local/state/nix-portable/.nix-portable/store
$META_ROOT/.local/state/envctl/profiles/yazelix
$META_ROOT/.cache/nix-portable or $META_ROOT/var/cache/envctl/nix-portable
$META_ROOT/.config/yazelix/settings.jsonc
$META_ROOT/.local/share/yazelix/
```

Runtime environment for provider commands:

```sh
export HOME="$META_ROOT"
export XDG_CONFIG_HOME="$META_ROOT/.config"
export XDG_DATA_HOME="$META_ROOT/.local/share"
export XDG_STATE_HOME="$META_ROOT/.local/state"
export XDG_CACHE_HOME="$META_ROOT/.cache"
export NP_LOCATION="$META_ROOT/.local/state/nix-portable"
export NIX_CONFIG="experimental-features = nix-command flakes"
export PATH="$META_ROOT/usr/bin:$PATH"  # usr/bin/nix-portable delegates to existing envctl component
```

Install/update shape:

```sh
nix-portable profile install --profile "$META_ROOT/.local/state/envctl/profiles/yazelix" \
  --refresh github:FlexNetOS/yazelix#yazelix
```

Exact syntax must be implementation-verified against the pinned nix-portable/Nix version; the architectural invariant is explicit profile path + meta-owned `HOME/XDG/NP_LOCATION`, not a specific final CLI string.

Acceptance:

- In a clean container/user namespace with no host `/nix`, `env -i META_ROOT=... HOME=$META_ROOT XDG_* ... $META_ROOT/usr/bin/yzx --version` works through nix-portable.
- No writes occur under real `$HOME`, `/etc/nix`, `/nix`, or `/usr` in portable mode, aside from declared runtime host interfaces like `/tmp`, ptys, display sockets, and `/run/user/$UID`.
- `NP_LOCATION` contains nix-portable's store/cache under `$META_ROOT`.
- `yzx doctor --verbose` identifies the active provider and does not report stale `~/.local/bin/yzx` or shell-function shadows.

### Lane 3 — `bundle` / titan artifact provider (separate release lane)

Purpose: provide a single artifact or copyable directory for offline/bootstrap/CI use.

Candidate tools:

- `nix bundle --bundler github:DavHau/nix-portable` for static executable/devshell-style bundles.
- `nix bundle --bundler github:ralismark/nix-appimage` for AppImage artifacts.
- `nix bundle --bundler github:logos-co/nix-bundle-dir` for portable directory artifacts.
- `nix-community/nix-bundle` only as legacy precedent unless current verification proves suitability.

Acceptance:

- Bundle build pins flake inputs and emits SBOM/closure manifest.
- Artifact startup time and size are measured for full Yazelix, not assumed acceptable.
- Artifact docs explicitly list host interfaces: kernel user namespaces/FUSE/proot/bwrap needs, terminal/display sockets, GPU/fonts, `/tmp`, `/run/user/$UID`.
- Bundle lane cannot mutate/update the developer profile; it hands off to `system-nix` or `nix-portable` for updates.

## Sequenced upgrade roadmap

1. **Provider detector and report-only doctor.**
   - UPGRADE: add envctl detector rows for `system-nix`, `nix-portable`, and `bundle` providers. | axis: quality | rationale: makes ownership visible before behavior changes | evidence: research + `envctl/manifest/nix-yazelix.toml:5-240` | blast: envctl doctor only | risk: low | verdict: QUALIFIED(needs Feature Forge implementation)
   - Acceptance: `envctl doctor` classifies the current machine as `system-nix OWNER-WALL` and reports whether base PATH contains Yazelix `toolbin`.

2. **Meta-owned `yzx` wrapper contract.**
   - UPGRADE: generate `$META_ROOT/usr/bin/yzx` as a regular wrapper, preserving `.local/bin` compatibility until parity is proven. | axis: quality | rationale: removes stale wrapper ambiguity and centralizes HOME/XDG/Yazelix roots | evidence: Yazelix troubleshooting shadowing docs; previous plan lines 138-140 | blast: shell/terminal workflow | risk: medium | verdict: QUALIFIED(interactive verification required)
   - Acceptance: `type -a yzx`, `which yzx`, and `readlink -f` show envctl's wrapper first; wrapper delegates to the selected provider.

3. **nix-portable provider proof harness.**
   - UPGRADE: reuse envctl's existing `nix-portable` component (`envctl/manifest/components.d/epic-h-toolchains.toml`) and run a clean-environment proof before any payload-root migration. | axis: accuracy | rationale: proves the portability claim rather than documenting it | evidence: nix-portable `NP_LOCATION` and store virtualization docs | blast: new provider lane only | risk: medium | verdict: QUALIFIED(clean-container proof required)
   - Acceptance: no host `/nix` or real-home profile is needed in portable mode.

4. **Activation scoping gate.**
   - UPGRADE: add CI/doctor gate that fails if base PATH includes `/nix/store/*-yazelix*/toolbin`. | axis: quality | rationale: prevents recurrence of the observed global PATH leak | evidence: Yazelix `yzx env` contract + local PATH drift in existing audit | blast: shell initialization | risk: medium | verdict: CONFIRMED
   - Acceptance: `envctl env --toolchains` remains clean; `yzx env --no-shell` is the explicit way to request Yazelix tool PATH.

5. **Titan artifact experiment.**
   - UPGRADE: build one measured Yazelix artifact using nix-portable bundler or AppImage/bundle-dir and record size/startup/host-interface requirements. | axis: speed | rationale: answers the “titan-class package” request without conflating artifacts with mutable providers | evidence: Nix bundle/nix-portable/nix-appimage/nix-bundle-dir research | blast: release/CI artifact only | risk: low-medium | verdict: QUALIFIED(measurement required)
   - Acceptance: artifact manifest, size, startup time, and host prerequisites are committed before any recommendation to distribute it.

## Governance, settings, and config

- APPLY now: docs/research/ADR/ROADMAP only.
- PROPOSE for Feature Forge: provider detector, provider manifest schema, wrapper generator, clean-container proof, PATH gate, and titan artifact experiment.
- OWNER-WALL: system Nix, `/etc/nix`, nix-daemon, update-alternatives, host terminal integrations, display sockets, GPU/font libraries.
- REGENERATE: generated wrappers, desktop entries, profile entries, and bundle artifacts must be created by envctl/provider commands, not hand-edited.

## Test Strategy & Coverage

The implementation needs tests before production behavior changes.

### FF test-build spec

- **Case 1: provider classifier golden** — Given synthetic evidence for `/nix`, nix-portable `NP_LOCATION`, and bundle artifact roots, assert envctl classifies `system-nix`, `nix-portable`, and `bundle` with owner labels.
- **Case 2: clean portable proof** — In a container/namespace fixture with no `/nix`, run envctl's existing `nix-portable` component/frontdoor with redirected `NP_LOCATION`, HOME, and XDG roots, then assert all state/cache/profile writes land below `$META_ROOT`.
- **Case 3: yzx wrapper env contract** — Assert the generated wrapper exports `HOME=$META_ROOT`, XDG roots, `YAZELIX_CONFIG_DIR`, `YAZELIX_STATE_DIR`, and provider selector before exec.
- **Case 4: PATH leak regression** — Assert base PATH from shell snippets and `envctl env --toolchains` excludes `/nix/store/*-yazelix*/toolbin`, while `yzx env --no-shell` can expose it.
- **Case 5: update-owner separation** — Assert `system-nix` uses owner-wall profile/update semantics, `nix-portable` uses explicit meta profile path, and `bundle` refuses mutable update operations.
- **Case 6: titan artifact measurement** — CI artifact job records closure size, artifact size, startup time, and host-interface prerequisites as build metadata.

## Gaps

- Need implementation-time syntax verification for `nix-portable profile install --profile ...`; the adapter contract is stable, but exact CLI invocation must be pinned and tested.
- Need a clean Linux test substrate with user namespaces/proot/bwrap coverage; portability claims are unproven until that harness is green.
- Need interactive Zellij/Yazi/Helix/desktop verification before changing default shell auto-enter behavior.
- Need owner review of `$META_ROOT/usr` versus `$META_ROOT/.local` placement tension: the current ADR uses FHS/XDG `$META_ROOT/usr`, while wake-up guidance says envctl installs target `$META_ROOT/.local`. This plan uses `.local/share` for provider payloads and keeps `usr/bin` as the executable frontdoor until the owner resolves the canonical frontdoor policy.

## Confidence

Medium-High. The corrective path is clear: provider adapter + nix-portable proof lane + artifact lane. Confidence becomes High after the clean portable proof demonstrates no writes outside `$META_ROOT` and the interactive Yazelix workflow stays green through the generated wrapper.
