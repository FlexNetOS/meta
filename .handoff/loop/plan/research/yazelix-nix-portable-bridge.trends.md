# Yazelix + portable Nix bridge — field research (window: 2026-03-30 .. 2026-06-28, rolling 90 days)

- Target: `yazelix-nix-portable-bridge`
- Objective: identify the corrective path for Yazelix confinement and portability leaks, especially the gap bridge between `/nix/store` assumptions and meta-owned `$META_ROOT` roots.
- Sources read: 9 | in-window primary docs: 2 | older/no-date technical precedents: 7 | confidence: Medium-High

## Research questions

1. What does Yazelix upstream require and intentionally own today?
2. Which project already solves rootless/off-`/nix` Nix execution?
3. Which project solves all-in-one closure distribution, and where does it stop?
4. What is the safest meta/envctl bridge that preserves Yazelix while stopping global PATH and host-depth leakage?

## Best-practices (current or durable)

- Keep a single update/install owner per Yazelix runtime. Upstream Yazelix distinguishes profile-owned and Home Manager-owned installations and points stale wrapper/profile shadows to `type yzx`, `which yzx`, and `readlink -f` diagnosis. This maps directly to envctl's need for an explicit provider/profile owner instead of implicit default-profile writes. (Yazelix troubleshooting, https://github.com/luccahuguet/yazelix/blob/main/docs/troubleshooting.md#yzx-update-upstream-still-tries-install, source commit `aad811e0`, 2026-05-31)
- Treat `yzx env` as an activation boundary, not a base-shell PATH mutation. Upstream states `yzx env` loads Yazelix's curated tool surface, and `yzx env --no-shell` exposes the tool PATH without switching shells. That confirms meta's base PATH should not globally include `/nix/store/*-yazelix/toolbin`; the wrapper should add it only for Yazelix activation modes. (Yazelix installation, https://github.com/luccahuguet/yazelix/blob/main/docs/installation.md#cli-only-mode, source commit `a3e8d95`, 2026-06-27)
- Keep user configuration separate from packaged runtime. Yazelix's documented config root is `~/.config/yazelix/settings.jsonc`, while the runtime is package/profile-provided. In meta, the equivalent should be `XDG_CONFIG_HOME=$META_ROOT/.config` and `YAZELIX_CONFIG_DIR=$META_ROOT/.config/yazelix`, never real-home config as the primary surface. (Yazelix installation, https://github.com/luccahuguet/yazelix/blob/main/docs/installation.md#step-3-configure-your-installation-optional, source commit `a3e8d95`, 2026-06-27)
- Prefer a provider abstraction over pretending `/nix/store` is envctl-owned. `nix-portable` is explicitly static, permissionless, installation-free, and preconfigured. Under the hood it keeps the real store under its portable location and virtualizes `/nix/store` with shipped/existing `nix`, `bwrap`, or `proot`. That is the already-solved bridge for off-OS/off-user-depth execution. (DavHau/nix-portable README, https://github.com/DavHau/nix-portable, latest release `v012`, 2024-04-15 — older, verify current)
- Use `NP_LOCATION` to relocate nix-portable's state/store under meta. The README documents `NP_LOCATION` as the location of the `.nix-portable` directory, defaulting to `$HOME`; envctl should override it to `$META_ROOT/.local/state/nix-portable` or an equivalent meta state root. (DavHau/nix-portable README, https://github.com/DavHau/nix-portable#environment-variables, latest release `v012`, 2024-04-15 — older, verify current)
- Use bundling for immutable distribution artifacts, not as the primary mutable developer package manager. The Nix manual says `nix bundle` packs an installable closure into a self-extracting executable and only works on Linux; nix-bundle and nix-appimage both rely on namespace/AppImage-style runtime tricks to make `/nix/store` references visible at execution. This is good for a titan/offline artifact lane, but not a replacement for updateable profiles and generated config/state. (Nix manual, https://nix.dev/manual/nix/latest/command-ref/new-cli/nix3-bundle, no in-window date; nix-community/nix-bundle README, https://github.com/nix-community/nix-bundle, release `v0.3.0`, 2018-04-10 — older, verify current)
- For GUI/terminal bundles, keep host interfaces explicit. nix-bundle's README flags slow startup, large files, Linux-only, and user-namespace requirements; nix-appimage and nix-bundle-dir both flag host graphics/display/glibc/driver caveats. Yazelix's terminal stack cannot honestly be “off host” because display sockets, fonts, shells, GPU/terminal APIs, `/tmp`, and `/run/user/$UID` remain host interfaces. (nix-community/nix-bundle README, https://github.com/nix-community/nix-bundle#drawbacks; ralismark/nix-appimage README, https://github.com/ralismark/nix-appimage#caveats, README commit 2025-06-13; logos-co/nix-bundle-dir README, https://github.com/logos-co/nix-bundle-dir#caveats, README commit 2026-02-12 — older than 90 days)

## Latest movement / recency gate

- In-window: Yazelix installation docs changed on 2026-06-27 and now emphasize package/profile runtime, config under `~/.config/yazelix`, curated runtime tool surface, and `yzx env` activation. That is current enough to treat as the primary Yazelix contract.
- In-window: Yazelix troubleshooting docs changed on 2026-05-31 and explicitly diagnose stale `~/.local/bin/yzx` and `/nix/store/.../bin/yzx` shell-function shadowing. That directly matches the local drift class.
- Older but still relevant: nix-portable latest release observed is `v012` published 2024-04-15; it added bundling support, fixed automatic runtime selection, updated proot to 5.4.0 for Ubuntu 24.04, and restored Docker support. No newer release was observed via GitHub API on 2026-06-28.
- Older/stale: nix-community/nix-bundle latest GitHub release is 2018-04-10 and the README begins with an instability warning. Use it only as precedent/tooling for titan artifacts, not as the canonical containment layer.
- Adjacent, not primary: logos-co/nix-bundle-dir is newer than nix-bundle and produces copyable directories without Nix installed, but its README also documents host-library exclusions and `/nix/` embedded-reference checks. It is a release-artifact option, not a mutable Nix/profile owner.

## Tool-currency & advisories

| tool / project | observed latest / source date | released / committed | breaking? | CVE / advisory | recommend |
|---|---:|---:|---|---|---|
| Yazelix install docs | commit `a3e8d95` | 2026-06-27 | no | none found in docs | **use as current contract** |
| Yazelix troubleshooting docs | commit `aad811e0` | 2026-05-31 | no | none found in docs | **use as current shadowing/doctor contract** |
| DavHau/nix-portable | release `v012` | 2024-04-15 | low/unknown | no CVE found in source scan | **adopt as portable provider, pin and verify** |
| Nix `nix bundle` command | Nix 2.34.8 latest manual inspected | no page date | experimental interface | no CVE found in source scan | **use for titan artifact experiments only** |
| nix-community/nix-bundle | release `v0.3.0` | 2018-04-10 | README says unstable | no CVE found in source scan | **do not make primary bridge; evaluate only for artifacts** |
| ralismark/nix-appimage | README commit `f63a1ff` | 2025-06-13 | project caveats | no CVE found in source scan | **artifact option; Linux/userns/GPU caveats** |
| logos-co/nix-bundle-dir | README commit `bd2c943` | 2026-02-12 | new project | no CVE found in source scan | **artifact option for directory bundles** |
| Nushell | bundled by Yazelix curated runtime | 2026-06-27 Yazelix doc | no | none found in source scan | **treat as Yazelix runtime-private unless activated** |

## Confirmed gap

The missing bridge is not “make `/nix/store` disappear.” The confirmed gap is a **provider adapter** that lets envctl select one runtime owner and then binds that owner into meta's FHS/XDG roots:

1. **system-nix provider** — existing behavior, honest OWNER-WALL host prerequisite, fastest for this workstation.
2. **nix-portable provider** — meta-local rootless Nix under `$META_ROOT`, with `NP_LOCATION` and XDG/HOME redirected; this is the corrective path for confinement and portability.
3. **bundle provider** — immutable titan/offline artifacts built from the Yazelix closure; good for CI/release/disconnected launches, not primary update/config owner.

## Gaps / unverified

- No interactive `yzx enter` or desktop GUI launch was run during this planning pass.
- nix-portable must be tested in a fresh container or clean user namespace to prove no dependency on host `/nix`, real `$HOME/.nix-profile`, or `/etc/nix` in portable mode.
- Bundle size/startup for the full Yazelix terminal stack is unknown; the titan lane needs measurement.
- macOS remains unsupported by nix-portable; nix-bundle-dir is cross-platform as a directory approach but does not provide mutable Nix/profile semantics.

## Sources

1. Yazelix installation — https://github.com/luccahuguet/yazelix/blob/main/docs/installation.md — commit `a3e8d95`, 2026-06-27.
2. Yazelix troubleshooting — https://github.com/luccahuguet/yazelix/blob/main/docs/troubleshooting.md — commit `aad811e0`, 2026-05-31.
3. DavHau/nix-portable README — https://github.com/DavHau/nix-portable — release `v012`, 2024-04-15.
4. DavHau/nix-portable releases — https://github.com/DavHau/nix-portable/releases — `v012`, 2024-04-15.
5. Nix manual `nix bundle` — https://nix.dev/manual/nix/latest/command-ref/new-cli/nix3-bundle — latest page observed as Nix 2.34.8, inspected 2026-06-28.
6. nix-community/nix-bundle README — https://github.com/nix-community/nix-bundle — release `v0.3.0`, 2018-04-10.
7. ralismark/nix-appimage README — https://github.com/ralismark/nix-appimage — README commit `f63a1ff`, 2025-06-13.
8. logos-co/nix-bundle-dir README — https://github.com/logos-co/nix-bundle-dir — README commit `bd2c943`, 2026-02-12.
9. Nushell home page — https://www.nushell.sh/ — inspected 2026-06-28.
