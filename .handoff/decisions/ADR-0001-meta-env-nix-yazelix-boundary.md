# ADR-0001: Treat Nix/Yazelix as a host-prerequisite package provider behind meta-owned activation wrappers

- Status: draft
- Date: 2026-06-28
- Target: meta-env-install
- Plan: ../loop/plan/reports/meta-env-install-containment-plan.md

## Context

`envctl`'s canonical architecture installs active meta tooling under `$META_ROOT` FHS/XDG roots, with `$META_ROOT/usr/bin` as the executable frontdoor surface and `.toolchains` as compatibility storage (`envctl/docs/adr-install-locations-and-local-state.md:32-57`). Yazelix requires Nix with flakes as a host prerequisite and packages its runtime through Nix profile/Home Manager/store surfaces (`yazelix/docs/installation.md:254-258`). Yazelix's own contracts separate runtime root, config root, generated state root, and update owner tiers (`yazelix/docs/contracts/runtime_root_contract.md:5-16,98-129`; `runtime_distribution_capability_tiers.md:34-58`).

Live evidence on 2026-06-28 showed `yzx` resolving directly to `/nix/store/...-yazelix/bin/yzx` and the interactive PATH containing `/nix/store/...-yazelix/toolbin`, while envctl's canonical `env --toolchains` output places `$META_ROOT/usr/bin` first and does not need Yazelix toolbin globally.

## Decision

Treat `/nix`, `/nix/store`, `nix-daemon`, `/etc/nix/*`, and update-alternatives as explicit OWNER-WALL host prerequisites/mutations. Envctl may manage meta-local profile/frontdoor/config/state bridges, but it does not claim to own the Nix store. Yazelix should enter meta through a regular `$META_ROOT/usr/bin/yzx` activation wrapper that sets/forwards `YAZELIX_RUNTIME_DIR`, `YAZELIX_CONFIG_DIR`, `YAZELIX_STATE_DIR`, XDG roots, and only exposes Yazelix `toolbin` during `yzx env|enter|run`, not in the base shell PATH.

## Consequences

Positive:
- Preserves honest portability: meta owns wrappers/config/state/profile bridge; Nix owns immutable package store.
- Reuses Yazelix's mature runtime-root contract instead of inventing a parallel model.
- Reduces PATH shadowing and global tool leakage.
- Gives envctl a general component ownership schema for other external providers.

Negative:
- Requires implementation-time interactive shell, desktop launcher, and Yazelix session verification.
- Does not make `/nix/store` portable with a cloned meta repo; that remains a host prerequisite.
- May require explicit `nix profile --profile` handling or documented reliance on the current profile symlink bridge.

## Alternatives considered

1. **Move or mirror Nix store into `$META_ROOT`.** Rejected: Nix store semantics are host/daemon/system-level and root-owned; mirroring it would be brittle and false portability.
2. **Keep `/nix/store/.../toolbin` in global PATH.** Rejected: convenient but leaks activation-specific tools into every shell and can shadow meta/system tools.
3. **Remove Yazelix/Nix from envctl.** Rejected: Yazelix is a required terminal/front-door layer; strict upgrade policy requires containment and verification, not removal.
4. **Keep implicit default-profile `nix profile` commands only.** Deferred/qualified: current symlink bridge works, but explicit profile-path ownership is more auditable.

## Invariants check

- No rollback/removal: this ADR proposes wrappers/detectors first and preserves existing Yazelix/Nix until parity is proven.
- No unmanaged system-depth claim: host mutations stay OWNER-WALL and must have preview/revert status.
- Meta containment: all envctl-owned frontdoors/config/state remain under `$META_ROOT`; only declared host prerequisites cross the boundary.
- Reversibility: wrapper/PATH changes can be removed; Nix cache lines and alternatives entries must be reverted exactly by owner-aware reset.
