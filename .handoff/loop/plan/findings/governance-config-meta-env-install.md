# Governance + Config Finding: meta env install targets, envctl overlay, and Yazelix/Nix

- Date: 2026-06-28
- Target: `meta-env-install`
- Method: `plan-governance-config` scan of rules, docs, envctl manifests, PATH, and install-owner boundaries.

## Verdict

The control plane already contains the right doctrine, but enforcement is split. `CLAUDE.md`, envctl ADRs, `envctl env --toolchains`, and `meta-local-policy.sh` agree that active install sources target `$META_ROOT` FHS/XDG roots and only one real-home `.local` bridge is allowed. Live state shows the doctrine is not fully enforced: current shells begin with `$HOME/.local/bin`, core meta binaries and several tools still live in `.local/bin`, `usr/bin` has symlink frontdoors despite policy text, and Yazelix/Nix installs require host-level `/nix` and `/etc/nix` ownership that must be explicitly modeled as host prerequisites rather than treated as a violation or hidden exception.

## Surfaces scanned

| Surface | Finding | Evidence |
|---|---|---|
| `CLAUDE.md` | States envctl installs every meta-used tool into meta and no system/user global installs, with global paths as symlinks into meta. | `CLAUDE.md:38-40` |
| `envctl/README.md` | Defines canonical `$META_ROOT/{usr,etc,var,opt}` plus XDG meta-home roots and `.toolchains` compatibility. | `envctl/README.md:6-7,53-68` |
| `envctl/docs/adr-install-locations-and-local-state.md` | Gives the canonical map, bridge rule, host-prerequisite caveat, and structural `$META_ROOT/usr` mirror. | `envctl/docs/adr-install-locations-and-local-state.md:7-21,32-51,144-154` |
| `envctl/home/README.md` | Locks portability rule: real file in meta, symlink outside, never reverse. | `envctl/home/README.md:4-15,24-27` |
| `envctl/ci/gates/meta-local-policy.sh` | Enforces active sources target META_ROOT FHS/XDG and flags `.local/bin`/canonical symlink-frontdoor regressions in source. | `envctl/ci/gates/meta-local-policy.sh:61-69,94-103,167-180,338` |
| `envctl env --toolchains` | Exports canonical `ENVCTL_USR_*`, `ENVCTL_VAR_*`, `ENVCTL_XDG_*`, CARGO/RUSTUP/BUN/UV homes, and PATH with `$META_ROOT/usr/bin` before `.local/bin`. | live command output 2026-06-28 |
| `envctl doctor` | Confirms canonical roots are writable and known FlexNetOS tools resolve inside META_ROOT, while `/etc` remains a host/system surface. | live command output 2026-06-28 |
| `envctl/manifest/nix-yazelix.toml` | Declares Nix install, cache trust, profile `yazelix`, desktop, shell auto-enter, and Ghostty alternatives. | `envctl/manifest/nix-yazelix.toml:5-49,52-92,95-139,142-190,194-215` |
| `yazelix/docs/contracts/*` | Yazelix has a mature root/identity/update-owner model: Nix owns package/control plane; runtime/config/state roots are explicit; package/store/Home Manager/manual tiers are explicit. | `yazelix/docs/contracts/nix_control_plane_boundary.md:5-15,42-57,95-105`; `runtime_root_contract.md:5-16,98-129`; `runtime_distribution_capability_tiers.md:34-58` |

## Hygiene detectors

| Detector | Status | Evidence | Impact |
|---|---|---|---|
| Permission/system-depth drift | QUALIFIED | Nix/Yazelix manifest intentionally writes `/etc/nix/nix.custom.conf` and update-alternatives (`envctl/manifest/nix-yazelix.toml:63-71,202-215`). | Must be classified OWNER-WALL/host-prereq, not silently mixed into meta portability. |
| Config drift | CONFIRMED | `envctl env --toolchains` says canonical `ENVCTL_BIN_DIR=$META_ROOT/usr/bin`, but `.local/envctl-env.sh` still exports `ENVCTL_BIN_DIR=$META_ROOT/.local/bin` in earlier evidence and current PATH starts with `$HOME/.local/bin`. | Different activation paths produce different frontdoor precedence. |
| Permission/frontdoor drift | CONFIRMED | Live `$META_ROOT/usr/bin` contains many symlinks; policy wants regular wrappers. | Frontdoors can become symlink farms and hide target changes from verifier semantics. |
| User-global bridge drift | QUALIFIED | `/home/drdave/.local`, `.meta`, `.cargo`, `.nix-profile` all bridge into meta. `.local` bridge is sanctioned; `.meta`/`.cargo`/`.nix-profile` need explicit bridge classification. | Prevents user-depth writes but expands the bridge set beyond the one `.local` doctrine. |
| Skill/foundation drift | CONFIRMED from prior incident | Upstream GitKB foundation compactness vs FlexNetOS overlays documented in `incidents/foundation-drift-kb-first-redirect`. | Foundation/overlay verifiers must distinguish baseline vs overlay vs unsafe drift. |
| Token/status noise | CONFIRMED | Root `git status` includes many generated env roots not ignored. | Agents spend context and risk accidental adds of generated/user data. |

## Nix/Yazelix conflict analysis

Yazelix's Nix-store need is **not inherently a conflict** with envctl containment if it is modeled as a host prerequisite and immutable package provider:

1. Yazelix explicitly says Nix owns package composition, platform gates, Home Manager integration, flake outputs, overlays, runtime package assembly, and derivation selection (`yazelix/docs/contracts/nix_control_plane_boundary.md:5-15`).
2. Yazelix explicitly separates config root (`~/.config/yazelix`), runtime root (`YAZELIX_RUNTIME_DIR` shipped package/repo tree), generated state root (`YAZELIX_STATE_DIR`, usually `~/.local/share/yazelix`), and live process activation (`yazelix/docs/contracts/runtime_root_contract.md:5-16,98-129`).
3. Yazelix recognizes package/store, Home Manager, compatibility installer, and runtime-root-only tiers instead of pretending one updater owns everything (`yazelix/docs/contracts/runtime_distribution_capability_tiers.md:34-58`).
4. Current live state already uses a meta-local default profile bridge: `/home/drdave/.nix-profile -> $META_ROOT/.local/state/nix/profiles/profile`.

The conflict starts when `/nix/store` paths and Yazelix `toolbin` are treated like always-on meta PATH entries. That turns an activation-specific package closure into a global shell substrate and can shadow host/meta tools. The bridge is to use Yazelix's own explicit runtime/config/state roots in a meta wrapper and keep `/nix/store` as an immutable provider, not a global frontdoor namespace.

## CLAIM rows

- CLAIM: envctl's canonical layout is `$META_ROOT/usr` + `$META_ROOT/var` + `$META_ROOT/opt` + meta-XDG roots, not `.local/bin` as primary. | axis: governance+settings+config | evidence: `envctl/README.md:53-68`; `envctl/docs/adr-install-locations-and-local-state.md:32-51`; live `envctl env --toolchains` | verdict: CONFIRMED
- CLAIM: current primary command routing still uses compatibility `.local/bin` for core meta tools. | axis: governance+settings+config | evidence: live `type -a meta/meta-git/meta-project/meta-mcp/loop`; `.local/bin` file identity snapshot | verdict: CONFIRMED
- CLAIM: `/nix/store` is an owner-wall host prerequisite, not envctl-owned mutable state. | axis: governance+settings+config | evidence: `yazelix/docs/installation.md:254-258`; `yazelix/docs/contracts/nix_control_plane_boundary.md:5-15`; live `/nix/store` root-owned path | verdict: CONFIRMED
- CLAIM: Yazelix provides a better portability design pattern for meta: explicit runtime root, config root, generated state root, and update owner tiers. | axis: governance+settings+config | evidence: `yazelix/docs/contracts/runtime_root_contract.md:5-16,98-129`; `runtime_distribution_capability_tiers.md:34-58` | verdict: CONFIRMED

## UPGRADE rows

- UPGRADE: Introduce an `envctl` install-owner schema for each component: `payload_root`, `frontdoor_root`, `config_root`, `state_root`, `cache_root`, `host_prerequisites`, `host_mutations`, `reset_reverts`, and `activation_path_scope`. | axis: governance+settings+config | target_surface: envctl manifest model | evidence: Nix/Yazelix needs `/nix`, `/etc/nix`, profile, desktop, and shell activation surfaces in `envctl/manifest/nix-yazelix.toml` | expected_impact: makes exceptions explicit and machine-verifiable | effort: medium | risk_tier: PROPOSE | acceptance: `envctl doctor --json` can classify every installed path as meta-owned, bridge, host-prereq, host-mutation, or drift | reversibility: schema-only then migrate manifests incrementally.
- UPGRADE: Replace implicit default-profile writes in `nix-yazelix` with explicit profile path handling under `$META_ROOT/.local/state/nix/profiles/profile`, or document why the symlink bridge is the authoritative profile owner. | axis: governance+settings+config | target_surface: `envctl/manifest/nix-yazelix.toml` | evidence: manifest uses `nix profile add` plus `$META_ROOT/.nix-profile/bin`; live profile resolves under `.local/state/nix/profiles/profile` | expected_impact: removes reliance on default `$HOME` semantics | effort: medium | risk_tier: PROPOSE | acceptance: install/verify/remove operate on the same explicit profile path and pass without depending on real-home profile resolution | reversibility: restore default profile command.
- UPGRADE: Model host mutations in `nix-yazelix` as OWNER-WALL gates with preview, exact-line revert, and doctor status. | axis: governance+settings+config | target_surface: `/etc/nix/nix.custom.conf`, `update-alternatives` | evidence: `envctl/manifest/nix-yazelix.toml:63-71,202-215` | expected_impact: keeps portability claims honest | effort: low/medium | risk_tier: PROPOSE | acceptance: doctor reports exact Nix cache lines and alternatives target as host-owned, with reset proving it removes only owned entries | reversibility: already partially modeled by `component.wiring.nix_conf_lines` and `alternatives`.
