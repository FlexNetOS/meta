# Filesystem Layout Finding: meta env install targets and envctl containment

- Date: 2026-06-28
- Target: `meta-env-install`
- Scope: `/home/drdave/Desktop/meta` primary checkout, `envctl/`, `yazelix/`, live PATH/profile/frontdoor state.
- Method: `plan-filesystem-layout` inventory against FHS/XDG/envctl-meta invariants.

## Verdict

The intended envctl architecture is sound: `$META_ROOT` is a synthetic FHS/XDG install root, with `usr/bin` for executable frontdoors, `usr/lib`/`usr/libexec`/`usr/share` for payload/support, `var/*` for mutable envctl state/cache/log/temp, `.local/share|state|.cache` for app/XDG contracts, and `.toolchains` as a compatibility toolchain store. The live tree is not yet converged: core meta binaries still execute from `$META_ROOT/.local/bin`, many `$META_ROOT/usr/bin` entries are symlinks even though the policy wants regular wrappers, several generated env roots are not ignored by git, and the interactive PATH exposes `/nix/store/...-yazelix/toolbin` globally instead of only inside a Yazelix activation.

## Path inventory table

| Path / surface | Kind | Owner | Mutability | Git status | Evidence |
|---|---|---|---|---|---|
| `$META_ROOT/usr/bin` | executable frontdoors | envctl | generated/regenerated | untracked root dir | `envctl/README.md:53`; `envctl/docs/adr-install-locations-and-local-state.md:39`; live `find usr/bin` showed symlinks and wrappers |
| `$META_ROOT/usr/lib` | libraries/support | envctl/components | generated/regenerated | untracked root dir | `envctl/README.md:54`; `envctl/docs/adr-install-locations-and-local-state.md:40`; `envctl env --toolchains` exports `ENVCTL_USR_LIB` |
| `$META_ROOT/usr/libexec` | private executables | envctl/components | generated/regenerated | untracked root dir | `envctl/docs/adr-install-locations-and-local-state.md:41`; `envctl env --toolchains` exports `ENVCTL_SECRETS_BIN_DIR` |
| `$META_ROOT/usr/share` | read-only shared payloads | envctl/components | generated/regenerated | untracked root dir | `envctl/README.md:55`; `envctl/docs/adr-install-locations-and-local-state.md:43` |
| `$META_ROOT/var/lib/envctl` | durable envctl state | envctl | mutable | untracked root dir | `envctl/README.md:58`; `envctl/docs/adr-install-locations-and-local-state.md:45`; `envctl doctor` reports run log there |
| `$META_ROOT/var/cache/envctl` | cache | envctl | mutable/regenerable | untracked root dir | `envctl/README.md:60`; `envctl/docs/adr-install-locations-and-local-state.md:48` |
| `$META_ROOT/var/log/envctl` | logs | envctl | mutable | untracked root dir | `envctl/docs/adr-install-locations-and-local-state.md:46`; `envctl doctor` checks writability |
| `$META_ROOT/var/tmp` | temp | envctl | mutable/regenerable | untracked root dir | `envctl/README.md:62`; `envctl/docs/adr-install-locations-and-local-state.md:50` |
| `$META_ROOT/opt/<component>` | component prefixes | envctl/components | generated/regenerated | untracked root dir | `envctl/README.md:63`; `envctl/docs/adr-install-locations-and-local-state.md:51` |
| `$META_ROOT/.toolchains` | compatibility toolchain store | envctl/tool managers | generated/regenerable | ignored | `envctl/docs/adr-install-locations-and-local-state.md:53-57`; `.gitignore:85`; `envctl env --toolchains` exports CARGO/RUSTUP/BUN/UV homes |
| `$META_ROOT/.local/bin` | legacy compatibility bin | envctl/upstream installers | generated/compat | untracked, not ignored | core `meta`, `meta-git`, `meta-project`, `meta-mcp`, `loop`, `rtk`, `git-kb`, `kache` live here; `envctl/ci/gates/meta-local-policy.sh:68-69` marks `.local/bin` tool installs as legacy debt |
| `$ENVCTL_REAL_HOME/.local -> $META_ROOT/.local` | real-home bridge | envctl | symlink | outside repo | `envctl/docs/adr-install-locations-and-local-state.md:18-21,77`; live `ls -ld /home/drdave/.local` |
| `$ENVCTL_REAL_HOME/.meta -> $META_ROOT/.local/share/meta` | meta data bridge | envctl/meta | symlink | outside repo | live `ls -ld /home/drdave/.meta`; upstream `meta_core` uses `META_DATA_DIR` or `~/.meta` |
| `$META_ROOT/.meta/plugins` | project-local meta plugin layer | upstream meta / FlexNetOS overlay | generated/project-local | root `.meta` not ignored, plugins ignored | upstream plugin discovery searches `.meta/plugins` first; live `meta plugin list` reports git/project/rust from `$META_ROOT/.meta/plugins` |
| `/nix/store/...-yazelix` | immutable package/runtime closure | Nix/Yazelix | root-owned immutable | system store, outside repo | live `yzx` resolves to `/nix/store/...-yazelix/bin/yzx`; `yazelix/docs/installation.md:254-258` names Nix as host prerequisite and package-provided runtime |
| `$META_ROOT/.local/state/nix/profiles/profile` | Nix user profile bridge target | Nix/envctl | mutable generation link | untracked | live `/home/drdave/.nix-profile -> $META_ROOT/.local/state/nix/profiles/profile`; envctl manifest currently uses `$META_ROOT/.nix-profile/bin` |
| `$META_ROOT/.config/yazelix` | Yazelix user config root | Yazelix/user/envctl | user/config | untracked | `yazelix/docs/posix_xdg.md:5-9`; `yazelix/docs/contracts/runtime_root_contract.md:98-103` |
| `$META_ROOT/.local/share/yazelix` | Yazelix generated state root under meta-XDG | Yazelix/envctl | generated/mutable | untracked | `yazelix/docs/posix_xdg.md:11-17,32-41`; `yazelix/docs/contracts/runtime_root_contract.md:65-68,112-116` |

## Placement verdict table

| Surface | Verdict | Expected location | Standard/convention | Why |
|---|---|---|---|---|
| envctl frontdoors | DRIFT | regular wrappers in `$META_ROOT/usr/bin` | FHS + envctl-meta | Policy wants regular wrappers (`envctl/ci/gates/meta-local-policy.sh:94-103,167`) but live `usr/bin` contains many symlinks to `.toolchains` and some self-links (`secretctl`, `secretd`). |
| core meta binaries | LEGACY-COMPAT | `$META_ROOT/usr/bin/{meta,meta-git,meta-project,meta-mcp,loop}` wrappers or binaries | envctl-meta | Live route is `$HOME/.local/bin` resolving to `$META_ROOT/.local/bin`; upstream defaults explain why, but `.local/bin` is compatibility not canonical. |
| toolchain manager homes | OK/LEGACY-COMPAT | `$META_ROOT/.toolchains/*` with frontdoors in `$META_ROOT/usr/bin` | Rust-Cargo + envctl-meta | envctl intentionally keeps `.toolchains` as compatibility store while exporting CARGO_HOME/RUSTUP_HOME/BUN/UV there. |
| meta data/global plugins | QUALIFIED | `$META_ROOT/.local/share/meta` for user-data bridge; `$META_ROOT/.meta/plugins` for project-local plugins | XDG + upstream meta | `/home/drdave/.meta` bridge prevents user-depth writes, but `.meta` also contains repo/project policy and generated plugins; ownership is mixed. |
| Nix/Yazelix runtime closure | OWNER-WALL, acceptable | `/nix/store` host prerequisite plus meta frontdoor/profile bridge | Nix package model + envctl host-prereq | Nix store cannot be made repo-local without changing Nix itself. Treat as immutable host package store and keep only profile/frontdoor/config/state in meta. |
| Yazelix activation PATH | DRIFT | `$META_ROOT/usr/bin/yzx` wrapper activates store runtime; `/nix/store/.../toolbin` only inside `yzx env/enter` | envctl-meta + Yazelix runtime-root contract | Current global PATH includes `/nix/store/...-yazelix/toolbin` and `/bin` before default profile/system segments, leaking Yazelix tool surface outside Yazelix. |
| top-level generated roots (`usr`, `var`, `etc`, `opt`, `.local`, `.config`, `.cargo`, `.rustup`, `.nix-profile`) | DRIFT | gitignored generated roots, with tracked policy docs elsewhere | repo-local + envctl-meta | `git status` shows these as untracked and `git check-ignore` says most are not ignored, creating accidental-commit and audit-noise risk. |

## Boundary map

```text
host/system boundary
  /nix/store                  immutable Nix store (OWNER-WALL host prerequisite)
  /etc/nix/nix.custom.conf     host mutation for cache trust (OWNER-WALL, reversible lines only)
  /usr/bin/x-terminal-emulator host alternatives mutation (OWNER-WALL)
  $HOME/.local                 sanctioned bridge only -> $META_ROOT/.local
  $HOME/.meta                  compatibility bridge -> $META_ROOT/.local/share/meta
  $HOME/.cargo                 compatibility bridge -> $META_ROOT/.toolchains/cargo

meta boundary
  $META_ROOT/usr/bin           canonical executable frontdoors
  $META_ROOT/usr/libexec       private helper executables
  $META_ROOT/usr/lib|share      component support and shared payloads
  $META_ROOT/var/*             envctl durable/cache/log/temp
  $META_ROOT/.toolchains       compatibility toolchain homes
  $META_ROOT/.local/share      XDG app data only
  $META_ROOT/.local/state      XDG app state, including Nix profile bridge

project/source boundary
  child repos from .meta.yaml   independent git repositories, not generated state
  docs/, .handoff/, .kb         durable planning/governance artifacts
```

## UPGRADE rows

- UPGRADE: Add a live filesystem layout verifier that classifies `$META_ROOT/usr/bin`, `.local/bin`, `.toolchains`, `.local/share`, `.local/state`, `.meta`, `/nix/store`, and top-level generated roots as `canonical|legacy-compat|owner-wall|drift`; fail if canonical `usr/bin` frontdoors are symlinks/direct copies without explicit allowlist. | axis: quality | target_surface: `envctl doctor` + `envctl/ci/gates/meta-local-policy.sh` | evidence: `envctl/ci/gates/meta-local-policy.sh:94-103,157-167` plus live `usr/bin` symlinks | expected_location: verifier in envctl, report in meta | migration_plan: add read-only detector first, then convert frontdoors | acceptance: CI/doctor reports current symlink/direct-copy drift and passes after wrappers are regular executable scripts | risk_tier: APPLY for detector, PROPOSE for enforcement | reversibility: detector-only until enforcement flag is enabled.
- UPGRADE: Converge core `meta`, `meta-git`, `meta-project`, `meta-mcp`, `loop`, `rtk`, `git-kb`, and `kache` to `$META_ROOT/usr/bin` regular wrappers, leaving `$META_ROOT/.local/bin` compatibility only as bridges after parity. | axis: quality | target_surface: executable frontdoors | evidence: live command routing resolves those tools from `$META_ROOT/.local/bin`; `envctl/README.md:53`; `envctl/docs/adr-install-locations-and-local-state.md:133` | expected_location: `$META_ROOT/usr/bin` | migration_plan: wrapper-first, PATH-first, parity version checks, then compatibility cleanup | acceptance: `type -a` finds `$META_ROOT/usr/bin` before `.local/bin`; versions and plugin discovery unchanged | risk_tier: PROPOSE | reversibility: remove wrappers and restore PATH order if parity fails.
- UPGRADE: Add `.gitignore`/policy treatment for generated env roots while preserving tracked policy/docs, so `git status` no longer normalizes root clutter as repo work. | axis: governance+settings+config | target_surface: root `.gitignore` + envctl layout docs | evidence: live `git status` lists `.local/`, `usr/`, `var/`, `etc/`, `.config/`, `.cargo/`, `.rustup/`, `.nix-profile`; `envctl/docs/adr-install-locations-and-local-state.md:105-115` rejects `.local` peer repo | expected_location: ignored generated roots, tracked docs under `docs/`/`envctl/docs` | migration_plan: add narrowly-scoped ignore entries and move any track-worthy `.meta` policy files to docs before ignoring generated paths | acceptance: `git status --short` excludes generated env roots while still showing real source/doc changes | risk_tier: PROPOSE | reversibility: remove ignore rules; no file deletion.
- UPGRADE: Add a Yazelix activation wrapper at `$META_ROOT/usr/bin/yzx` and stop exporting `/nix/store/...-yazelix/toolbin` in the global interactive PATH; only `yzx env`, `yzx enter`, or `yzx run` should expose Yazelix `toolbin`. | axis: quality | target_surface: Nix/Yazelix integration | evidence: live `yzx` is `/nix/store/...-yazelix/bin/yzx`; PATH contains `/nix/store/...-yazelix/toolbin`; Yazelix says private helpers stay under `libexec` and `toolbin` is a curated activation surface (`yazelix/docs/installation.md:278`; `yazelix/packaging/mk_runtime_tree.nix:256-278`) | expected_location: `$META_ROOT/usr/bin/yzx` wrapper with explicit env | migration_plan: wrapper sets `YAZELIX_RUNTIME_DIR`, `YAZELIX_CONFIG_DIR`, `YAZELIX_STATE_DIR`, XDG roots, then execs profile/store `yzx` | acceptance: normal shell `PATH` has no `/nix/store/*-yazelix/toolbin`; `yzx env --no-shell` exposes it intentionally | risk_tier: PROPOSE | reversibility: remove wrapper/PATH edit.
