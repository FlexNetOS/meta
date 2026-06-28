# ADR-0003: Use Meta Harmony plus envctl database-first release tables for portable Yazelix/meta releases

- Status: draft
- Date: 2026-06-28
- Target: meta-harmony-portable-release-envctl-db-first
- Plan: ../loop/plan/reports/meta-harmony-portable-release-envctl-db-first-gap-hunt.md

## Context

The Yazelix/Nix bridge work identified three runtime lanes: `system-nix`, existing envctl `nix-portable`, and immutable bundle artifacts. The next gap is release orchestration: a full portable release must coordinate the meta parent repo, envctl manifests/providers, Yazelix runtime/flake closure, package registries, keys, hardware profiles, and generated artifacts. Before this pass, `FlexNetOS/meta-harmony` did not exist in the org.

Envctl already has a mature secret/cert logical schema for vault data, but its component/config/manifest layer is still file-first TOML/JSON plus generated runtime state. This allows drift between DB-like truth, manifests, generated artifacts, and UI/CLI state.

## Decision

Create/use `FlexNetOS/meta-harmony` as the release orchestration repo and make envctl database-first for release/config/control-plane rows. Meta Harmony plans releases; envctl stores and verifies typed rows; generated TOML/JSON/YAML/Nix/npm/Cargo artifacts are projections from database tables.

Portable Yazelix/meta releases are installed from release artifacts first. The foundation artifact lane uses Nix bundle/bundler experiments for immutable release assets and envctl's existing `nix-portable` provider for mutable/off-`/nix` runtime semantics. Crates.io and napi-rs/npm are first-class package targets, with tokens/keys brokered by envctl/secretd and never checked into generated files.

## Consequences

Positive:

- Prevents envctl manifest drift by making files projections of typed rows.
- Gives release orchestration a dedicated repo instead of overloading meta or envctl.
- Preserves multi-repo boundaries: meta coordinates, envctl installs/verifies, Yazelix runs, Harmony releases.
- Provides container-like reproducibility while keeping direct hardware access and faster release artifacts.
- Gives CLI and GUI the same table-backed control plane.

Negative:

- Requires a new repo initialization and later `.meta.yaml` adoption.
- Requires a schema migration path from manifest-first to DB-first without breaking existing envctl manifests.
- Release artifact feasibility still needs measurement across nix-bundle/nix-portable/AppImage/bundle-dir.
- npm/crates publishing keys need strict broker policy and preferably OIDC where supported.

## Alternatives considered

1. Keep release logic inside envctl only. Rejected: envctl should install/verify; release graph orchestration crosses meta parent, package registries, and hardware targets.
2. Use containers as primary runtime. Rejected: containers provide reproducibility but add image build latency and hardware passthrough friction; the target is container benefits with faster direct hardware access.
3. Keep TOML/JSON/YAML as source of truth. Rejected: current drift proves file-first artifacts are too easy to desynchronize.
4. Build a new Nix replacement. Rejected: envctl already has `DavHau/nix-portable`; reuse it.

## Invariants check

- Strict upgrade: file manifests remain supported until DB projections are parity-proven.
- No secret leakage: crates.io/npm/GitHub/signing tokens live in envctl/secretd broker tables or OIDC; generated artifacts contain references/placeholders only.
- Multi-repo integrity: no monorepo collapse; meta-harmony is a peer release tool repo.
- Hardware leverage: runtime declares host interfaces rather than hiding them behind an opaque container boundary.
- Reversibility: generated artifacts can be regenerated from table snapshots; old manifests remain for rollback until parity is proven.
