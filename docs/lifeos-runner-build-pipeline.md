# LifeOS Runner Build Pipeline

## Purpose

flexnetos_runner performs the release build and proof work for the first
ubuntu-26.04-x86_64 LifeOS portable release. meta plans and observes; the runner
executes and records proof.

## Runner entrypoint

The first implementation should provide a dry-run pipeline entrypoint that can
be triggered by GitHub Actions or by meta release build with --dry-run. It must
not publish or mutate host state unless explicit confirmation is supplied.

Required runner labels:

- self-hosted
- linux
- x64
- flexnetos
- ubuntu-26.04 or an explicitly documented equivalent

## Phase contract

| Phase | Name | Required output |
|---|---|---|
| R0 | Preflight host/toolchain check | host.json, toolchains.json, preflight.log |
| R1 | Checkout/repo graph sync | repo-lock.json, dirty-state.json |
| R2 | Build Yazelix/Nix foundation closure or extract runtime | yazelix-runtime.json, relocation-report.json |
| R3 | Build meta binaries | meta-binaries.json, cargo logs |
| R4 | Build LifeOS frontend/Tauri/native app | lifeos-build.json, bun/cargo logs |
| R5 | Bundle Bun/Node/Rust/native addons | dependency-bundle.json |
| R6 | Assemble portable prefix | file-map.json |
| R7 | Run prefix smoke tests | smoke-results.json |
| R8 | Run LifeOS tests/build gates | lifeos-gates.json |
| R9 | Run meta control-plane/MCP smoke | meta-gates.json |
| R10 | Generate SBOM/checksums/provenance | sbom.json, checksums.sha256, provenance.json |
| R11 | Package tar.zst/install script | artifact-manifest.json |
| R12 | Publish draft release or handoff artifact only | publish-decision.json |

## Workspace isolation

The runner should build under a dedicated working directory, not inside a dirty
developer checkout. Use repo-lock.json to capture:

- repo URL;
- branch/ref;
- commit SHA;
- dirty state;
- submodule/nested checkout state when relevant;
- evidence path for each repo.

## Cache policy

Allowed caches:

- Rust registry/git cache keyed by lockfiles and target;
- Bun package cache keyed by bun.lock;
- Nix store/cache only when provenance and relocation implications are recorded;
- build intermediates under runner-owned cache dirs.

Forbidden cache behavior:

- no opaque cache promotion into release artifacts;
- no secret-bearing cache upload;
- no using stale cache output without recording the cache key and source.

## Secret and log policy

Logs must not contain tokens, private keys, cookies, or host-specific secret
paths. If a command needs a secret, the evidence row records only that a secret
was present, the provider, and the redaction policy.

## Resume and rerun

Each phase appends to manifests/build-ledger.jsonl with:

- phase id;
- command;
- start and end timestamps;
- input artifact/checksum references;
- output paths;
- result;
- retry count;
- log path.

A rerun may skip a phase only when the prior row has matching inputs and sealed
outputs. Otherwise the phase must run again.

## Failure retention

Failed runs preserve:

- logs/release/<run-id>/;
- manifests/build-ledger.jsonl;
- partial file-map.json if prefix assembly started;
- dirty-state.json;
- host/toolchain preflight output;
- exact failing command and exit code.
