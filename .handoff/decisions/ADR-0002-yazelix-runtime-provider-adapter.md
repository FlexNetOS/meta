# ADR-0002: Add a Yazelix Runtime Provider Adapter with nix-portable as the portable bridge

- Status: draft
- Date: 2026-06-28
- Target: yazelix-nix-portable-bridge
- Plan: ../loop/plan/reports/yazelix-nix-portable-containment-solution.md

## Context

The previous meta env audit concluded that Nix/Yazelix must be treated as an explicit provider boundary, not as envctl-owned filesystem state. Current Yazelix upstream documentation confirms that `yzx env` is the intended activation surface for its curated tool PATH, that user configuration belongs under a Yazelix config root, and that stale `~/.local/bin/yzx` or `/nix/store/.../bin/yzx` shell shadows are known failure modes. Local envctl evidence shows the current manifest still sources system `/nix`, mutates `/etc/nix`, uses implicit Nix profile commands, and can expose `/nix/store/*-yazelix*/toolbin` in the base environment.

The research pass found that `nix-portable` already solves the key missing primitive: a rootless, installation-free Nix with `/nix/store` virtualized from a user-selected location via `NP_LOCATION`, using `nix`, `bwrap`, or `proot`. Bundlers such as `nix bundle`, nix-bundle, nix-appimage, and nix-bundle-dir solve immutable distribution shapes, but they do not replace mutable profile/update/config ownership for the everyday Yazelix developer runtime.

## Decision

Introduce a `YazelixRuntimeProvider` adapter in envctl with three lanes:

1. `system-nix`: the current fast workstation lane, explicitly labeled OWNER-WALL for `/nix`, `/etc/nix`, nix-daemon, and host profile mutations.
2. `nix-portable`: the portable/confinement lane, with `NP_LOCATION`, HOME, XDG roots, profile path, state, cache, and Yazelix config/state all rooted under `$META_ROOT`.
3. `bundle`: the titan/offline artifact lane, used for immutable release or CI artifacts only, never as the mutable update owner.

All lanes enter through a regular meta-owned `yzx` frontdoor that sets/forwards `YAZELIX_CONFIG_DIR`, `YAZELIX_STATE_DIR`, XDG roots, and provider selection. Yazelix `toolbin` is activation-scoped to `yzx env|enter|run`; it must not be present in the base shell PATH.

## Consequences

Positive:

- Gives envctl an honest portability story: system Nix remains a host provider, while nix-portable supplies the off-`/nix` bridge.
- Preserves strict upgrade policy by adding lanes/wrappers/detectors before removing existing behavior.
- Converts stale wrapper/profile shadowing into a verifiable doctor classification.
- Separates mutable development runtime from titan/offline release artifacts.

Negative:

- Requires a clean Linux proof harness with user namespace/proot/bwrap coverage.
- macOS portability is not solved by nix-portable; any cross-platform bundle-dir lane must be separately proven.
- GUI/terminal stacks still need host interfaces such as ptys, display sockets, fonts, GPU/graphics libraries, `/tmp`, and `/run/user/$UID`.
- The repo still has a policy tension between `$META_ROOT/usr/bin` as FHS frontdoor and wake-up guidance that envctl installs target `$META_ROOT/.local`; implementation must preserve both until the owner accepts a canonical frontdoor policy.

## Alternatives considered

1. **Move or mirror `/nix/store` into `$META_ROOT` directly.** Rejected: it is a false portability claim unless Nix store path virtualization is provided; nix-portable already provides that virtualization.
2. **Use nix-bundle/AppImage as the only bridge.** Rejected: bundles are immutable distribution artifacts and carry Linux/user-namespace/FUSE/host-library caveats; they do not own mutable profile updates or generated config/state.
3. **Keep current system Nix only.** Rejected as insufficient for the user's off-OS/off-user-depth portability requirement.
4. **Remove Yazelix/Nix.** Rejected by strict upgrade policy and product direction; the fix is containment and provider ownership, not removal.

## Invariants check

- Strict upgrade: existing system Nix/Yazelix stays functional while provider lanes are added and verified.
- Meta containment: envctl-owned wrappers, config, state, cache, profiles, and nix-portable roots stay under `$META_ROOT`; system-depth surfaces are labeled OWNER-WALL.
- Activation scope: Yazelix private tools are not globally exported; `yzx` activation owns the expanded runtime PATH.
- Reversibility: provider selection, wrappers, and nix-portable state roots are additive/removable; system Nix host mutations require owner-wall preview/revert gates.
