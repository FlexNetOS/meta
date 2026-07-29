# LifeOS Toolchain and Dependency Bundle

## Purpose

The portable release should be built from pinned source and lockfiles, with
runtime dependencies copied into the LifeOS prefix only after proof. Ambient host
tools are allowed for building only when their versions and provenance are
recorded.

## Bundle inventory

| Area | Planned source | Bundle target | Status |
|---|---|---|---|
| meta | FlexNetOS/meta repo graph | bin/meta, bin/meta-mcp, plugins, lib/meta/ | TARGET |
| LifeOS app | FlexNetOS/lifeos | bin/lifeos, lib/lifeos/, share/applications/ | TARGET |
| LifeOS daemon | lifeos-daemon crate | bin/lifeos-daemon | TARGET |
| Runtime manager | future LifeOS crates | sbin/lifeos-supervisor, sbin/lifeos-update-manager, sbin/lifeos-adopt-tool | TARGET |
| Yazelix | pinned Yazelix flake | bin/yazelix, bin/nu, bin/zellij, bin/yazi, bin/hx, lib/yazelix/ | BLOCKER until relocation proof |
| Rust toolchain | pinned runner/toolchain metadata | toolchains/rust/ or build-only provenance | QUESTION |
| Bun/Node | LifeOS bun.lock and package metadata | toolchains/bun/, toolchains/node/, lib/node-addons/ as needed | QUESTION |
| Browser | local Chromium/Chrome source/package | opt/browsers/ and libexec/browser/ | QUESTION |
| Vector/RAG | LanceDB or SahomeDB | var/db/lancedb or var/db/vector | TARGET |
| Local ACID state | Redb | var/db/redb | TARGET |
| Search/scraping | Spider crate | opt/tools or libexec helpers | TARGET |
| GPU/CUDA probes | future probe source | toolchains/cuda-probes/ | BLOCKER until proven |

## Rust

The release should build Rust binaries from pinned repos:

- meta
- meta-mcp
- loop
- meta plugins
- LifeOS Tauri shell
- lifeos-core
- lifeos-daemon
- lifeos-supervisor
- lifeos-update-manager
- lifeos-adopt-tool

The runner records rustc/cargo versions, target triple, lockfile hash, and
binary checksums.

## Bun and Node

LifeOS uses Bun. Bundle work should:

- install with bun install --frozen-lockfile;
- record bun.lock hash;
- avoid npm/npx/pnpm paths for LifeOS work unless explicitly justified;
- copy only runtime-needed JS/native payloads into lib/lifeos/ or
  lib/node-addons/;
- record native addon ABI and source package.

## Yazelix and Nix

Yazelix is the runtime-bedrock candidate, but relocation is not proven by this
roadmap. The first implementation must test one of:

- extracting a closure into the LifeOS prefix;
- static or patchelf relocation for required tools;
- appimage-like wrapper;
- host-managed Nix prerequisite as a temporary downgrade.

Until that proof exists, Yazelix is a BLOCKER for claiming a self-contained
release.

## Browser automation

Use a local browser binary with DevTools Protocol when browser automation is
needed. Keep profiles, downloads, and logs under the prefix. Do not make a
container runtime a default dependency.

## Build-before-adopt

All new tools follow:

1. capture source/provenance;
2. build under sources/ and var/tmp;
3. run proof gates;
4. record checksums and license;
5. promote into opt/adopted only after policy approval.

## SBOM and license map

The package phase generates:

- manifests/sbom.json;
- manifests/license-map.json;
- manifests/checksums.sha256;
- manifests/provenance.json.

Missing license or provenance data blocks release publication.
