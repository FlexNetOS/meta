# Correction notice (2026-06-28)

This report was corrected by `meta-harmony-source-truth-correction.md`. The original pass missed `.context/` and did not open archival KB docs returned by `git kb search harmony`. Treat `.context/CONTEXT.md`, `.context/tasks/cicd-distribution-gaps.md`, `obsolete/meta-as-source-of-truth-meta-generated-ci-dashboar`, and `.handoff/census-workspace-arch.*` as required source evidence for release/harmony work. `FlexNetOS/meta-harmony` is a new placeholder repo, not a pre-existing KB-defined source of truth.

# Gap hunt: Meta Harmony portable release foundation and envctl database-first drift repair

- Date: 2026-06-28
- Target: `meta-harmony-portable-release-envctl-db-first`
- Scope: gap hunt current paths/solutions, create the missing release-repo placeholder, and define the database-first envctl spec path.
- Status: **FOUNDATION SPEC / GAP MAP** — docs + KB spec only; no production code changes.

## Verdict

After correction, the release foundation should be **release-first, database-first, lineage-aware, and repo-reuse-first**:

1. **Portable install foundation:** start from release artifacts, not source rebuilds. The immediate foundation is a Yazelix/Nix portable release lane using `nix bundle`/nix-bundle family as the artifact producer and envctl's existing `nix-portable` component as the runtime/confinement provider.
2. **Full package graph:** package the full Yazelix terminal runtime, its Nix closure, the meta parent repo release metadata, and envctl manifests as one versioned release graph. Do not collapse these into one source repo.
3. **Release orchestrator repo:** create and use `FlexNetOS/meta-harmony` as the release orchestration tool/repo. This now exists as a private org repo: `https://github.com/FlexNetOS/meta-harmony`.
4. **Dual package surface:** use FlexNetOS crates.io ownership for Rust crates and napi-rs/npm for Node-facing release surfaces; envctl/secretd should broker the crates.io/npm tokens or OIDC flows, not leak them into files.
5. **Envctl drift fix:** envctl must become database-first for component config/certs/secrets/keys/variables/release artifacts. TOML/JSON/YAML/manifests become generated projections from typed tables, not the only source of truth.

Confidence: **Medium-High** for path/architecture; **Medium** for release-artifact feasibility until one measured Yazelix+nix bundle is built and timed on current hardware.

## Current defined paths and solutions

| Surface | Current definition | Verdict |
|---|---|---|
| meta workspace graph | `.meta.yaml` defines `envctl` as `git@github.com:FlexNetOS/envctl.git` and `yazelix` as `git@github.com:FlexNetOS/yazelix.git`. | OK: use existing repos |
| envctl install authority | `envctl/docs/adr-install-locations-and-local-state.md` defines `$META_ROOT/{usr,etc,var,opt}` + meta-XDG roots; `$ENVCTL_REAL_HOME/.local -> $META_ROOT/.local` is the only real-home bridge. | OK, but live generated roots still dirty |
| envctl nix-portable | `envctl/manifest/components.d/epic-h-toolchains.toml` already has `[[component]] id = "nix-portable"` using `DavHau/nix-portable`; lock entry exists. | REUSE; do not rebuild from scratch |
| envctl Yazelix install | `envctl/manifest/nix-yazelix.toml` still uses system `/nix`, `/etc/nix`, default profile, and `yzx enter`. | DRIFT: needs provider adapter |
| Yazelix runtime contract | `yazelix/docs/contracts/runtime_root_contract.md` separates `YAZELIX_RUNTIME_DIR`, `YAZELIX_CONFIG_DIR`, `YAZELIX_STATE_DIR`, process activation state. | OK: use as adapter contract |
| Yazelix distribution tiers | `yazelix/docs/contracts/runtime_distribution_capability_tiers.md` defines installer/Home Manager/package/runtime-root-only tiers and explicit update owners. | OK: map envctl providers to tiers |
| release bundling | Nix manual says `nix bundle` packs a closure into a Linux self-extracting executable; `nix-community/nix-bundle` exists but is old and has namespace/startup/size caveats. | USE as artifact experiment, not mutable runtime owner |
| npm/napi | napi-rs builds Rust Node-API addons and organizes platform artifacts for npm publication; npm recommends trusted publishing/OIDC for CI/CD publishing and granular tokens when needed. | USE for Node package surface, with envctl token broker |
| crates.io | Cargo publishing is permanent per version, recommends `cargo publish --dry-run`, tags, changelog, and token secrecy; teams can own crates via GitHub org/team. | USE for Rust package surface, with envctl token broker |
| meta-harmony repo | Missing in FlexNetOS before this pass; created as private `FlexNetOS/meta-harmony`. Existing `harmony-labs/meta` redirects to `gitkb/meta`, and `.context` preserves harmony-labs distribution paths. | CREATED as placeholder; needs lineage reconciliation before initialization/adoption |
| envctl DB | Secrets vault schema already models `meta`, `secrets`, `keyslots`, `relay_policies`, `relay_bearers`, `audit_log`, `ca_key`, `certs`; runtime state still uses JSON and manifests. | PARTIAL: expand DB-first beyond secrets |

## Portable release design: installed from release first

### Foundation lane A — release artifact

```text
meta-harmony release job
  ├─ pins meta parent commit + envctl commit + yazelix flake/rev
  ├─ realizes Yazelix runtime closure with Nix
  ├─ builds portable artifact:
  │    option 1: nix bundle --bundler nix-community/nix-bundle / appimage / bundle-dir
  │    option 2: nix bundle --bundler DavHau/nix-portable for self-contained nix-portable behavior
  ├─ emits closure manifest, SBOM, checksums, signatures, measured startup/size
  └─ publishes release assets to meta-harmony and/or meta parent release
```

Why release-first:

- Users install a measured binary/artifact, not rebuild a multi-repo graph locally.
- Release artifacts pin every closure/repo/package input.
- envctl can verify checksums/signatures before activation.
- Hardware-specific variants can be cut per target without changing source layout.

### Foundation lane B — runtime provider activation

```text
installed artifact or envctl manifest
  └─ $META_ROOT/usr/bin/yzx
       ├─ provider=system-nix    -> owner-wall current workstation lane
       ├─ provider=nix-portable  -> existing envctl DavHau/nix-portable component
       └─ provider=bundle        -> immutable artifact/mount/extract root
```

Rules:

- `bundle` is the install/release entrypoint, not a mutable updater.
- `nix-portable` is the mutable portable provider for Nix semantics under `$META_ROOT`.
- `system-nix` stays for fast local dev and compatibility, explicitly OWNER-WALL.

## Full multi-repo package graph

```text
FlexNetOS/meta parent repo
┌────────────────────────────────────────────────────────────────┐
│ release manifest / KB spec / .meta.yaml / docs/ROADMAP          │
│                                                                │
│  ┌─────────────┐  ┌────────────┐  ┌─────────────────────────┐  │
│  │ envctl repo │  │ yazelix repo│  │ meta-harmony repo       │  │
│  │ manifests   │  │ runtime     │  │ release orchestration   │  │
│  │ db-first    │  │ flake/pkg   │  │ crates/npm/artifacts    │  │
│  └──────┬──────┘  └──────┬─────┘  └───────────┬─────────────┘  │
└─────────┼────────────────┼────────────────────┼────────────────┘
          │                │                    │
          ▼                ▼                    ▼
   envctl providers   Yazelix closure       release assets
   nix-portable       config/state/runtime  crates.io + npm + GitHub
   system-nix         zellij/yazi/helix     checksums/SBOM/signatures
   bundle
```

Package graph invariant: **meta parent coordinates; envctl installs/verifies; Yazelix runs; meta-harmony releases.**

## Meta Harmony repo role

`FlexNetOS/meta-harmony` should be initialized as a tool repo with:

- Rust CLI crate: `meta-harmony` for release graph planning and verification.
- Optional napi-rs package: `@flexnetos/meta-harmony` exposing release graph operations to Node/Bun agents.
- Release spec tables: repos, components, artifacts, keys, package targets, hardware profiles.
- Artifact producers: Nix bundle/AppImage/bundle-dir, envctl release pack, npm/napi packages, crates.io packages.
- Artifact verifiers: checksum/signature/SBOM, closure diff, startup timing, hardware capability probe.
- Integration: consumes GitKB specs and envctl DB tables; emits generated `.meta.yaml` patch suggestions, envctl manifests, JSON/YAML/TOML, GitHub release notes, npm/crates publish plans.

Creation status: repo exists privately at `https://github.com/FlexNetOS/meta-harmony`; it is a placeholder created from this task, not a pre-existing KB-defined source of truth. It still needs lineage reconciliation against `.context` and harmony-labs/gitkb history before initialization, clone/adoption into `.meta.yaml`, README, Cargo workspace decision, and release CLI skeleton.

## Crates.io + napi/npm key model

Sources: Cargo Book publishing docs, npm CI/CD docs, napi-rs docs.

- **crates.io:** publish is permanent per version; release flow must dry-run (`cargo publish --dry-run` / `cargo package`), tag the commit, attach changelog, and use team ownership where possible.
- **npm:** prefer trusted publishing/OIDC for CI/CD; when unavailable, use granular short-lived or tightly scoped tokens. `.npmrc` may contain `${NPM_TOKEN}` placeholders but never literal tokens.
- **napi-rs:** provides the Rust-to-Node bridge and platform artifact organization; use it for Node-facing control packages rather than rewriting release logic in JS.
- **envctl/secretd:** should broker tokens/keys through database-first secret tables and short-lived relay policies. It should generate child env only at publish time, not persist tokens in manifests.

## Container benefits without container penalties

| Container benefit | Release-provider equivalent | Speed/accuracy/hardware impact |
|---|---|---|
| Reproducible filesystem | Nix closure + lock + bundle manifest + envctl DB snapshot | Less runtime layering; precise closure diff |
| Isolation | nix-portable bwrap/proot namespace + envctl HOME/XDG redirection | Faster than full container startup when prebuilt; keeps host GPU/display access explicit |
| Dependency pinning | Nix flake locks + Cargo.lock + npm lock + envctl DB release tables | Higher accuracy: every artifact has row-level provenance |
| Portability | self-extracting bundle / AppImage / bundle-dir + nix-portable provider | Works without host `/nix`; still declares kernel/display/GPU prerequisites |
| Hardware access | no opaque container boundary by default; host interfaces declared | Enables GPU, display, ptys, USB, and local hardware with fewer passthrough hacks |
| Rollback | release graph row + checksums + envctl provider selection | Fast switch between provider/artifact versions |

This design is **container-like for reproducibility**, but **not container-shaped as the primary runtime**. It avoids container image rebuild latency, reduces mount/passthrough surprises, and keeps all hardware access explicit and testable.

## Gaps and conflicts

1. **Release repo exists but is empty and lineage is unresolved.** Need reconcile `.context` harmony-labs/gitkb distribution strategy, then initialize `meta-harmony`, then adopt it into `.meta.yaml` only after clone/path exists to avoid another missing-repo status failure.
2. **nix-bundle naming/source ambiguity.** User cited `matthewbauer/nix-bundle`; current active repo is `nix-community/nix-bundle` with maintainer Matthew Bauer. Treat `nix-community/nix-bundle` as the source unless a fork is explicitly required.
3. **nix-bundle age/caveats.** It is useful precedent but not a sufficient foundation alone; must compare with `nix bundle` default bundlers, `DavHau/nix-portable` bundler support, nix-appimage, and bundle-dir.
4. **envctl DB scope is partial.** Secrets/certs already have a logical schema; manifests/config variables remain TOML/JSON/source-first. Need a unifying envctl state/config DB.
5. **Generated artifact drift.** Current root shows generated `.local`, `.config`, `.cargo`, `usr`, `var`, etc. These should be DB/manifest projections or ignored/generated roots, not hand-managed source state.
6. **Yazelix system-Nix still active.** Current `yzx doctor` reports package runtime and stale shell shadow. Provider wrapper is still needed.
7. **Frontdoor policy conflict.** envctl docs prefer `$META_ROOT/usr/bin`; owner wake-up says envctl installs target `$META_ROOT/.local`; current practical answer is `.local` for XDG/state/payload compatibility and `usr/bin` for canonical frontdoors until owner settles policy.
8. **Keys and publishing not database-first.** envctl/secretd has the right secret substrate but no first-class `publish_targets`, `release_tokens`, or `artifact_signing_keys` tables yet.
9. **CLI/UI table widget gap.** envctl GUI has tables/cards, but there is no CLI-controlled table editor that writes DB rows and regenerates TOML/JSON/YAML/manifests.

## Envctl database-first spec summary

Create a database-first envctl control plane with typed tables:

- `config_items` — all config variables, defaults, scopes, owners, provenance, validation schema.
- `component_rows` — component ids, providers, payload roots, frontdoors, detect/install/verify/remove recipes.
- `provider_rows` — system-nix, nix-portable, bundle, cargo, npm, GitHub release, hardware providers.
- `secret_refs` — references into the existing secret vault, never plaintext.
- `cert_refs` — CA/cert ownership and trust projections.
- `key_refs` — crates.io/npm/GitHub signing/publish keys and OIDC policy refs.
- `variables` — environment variable rows with scope, redaction class, generated artifact targets.
- `artifact_targets` — GitHub release asset, crates.io crate, npm package, Nix bundle, AppImage, SBOM.
- `generated_artifacts` — manifest/json/yaml/toml paths, content hash, row query, last generated commit.
- `drift_findings` — detector output with remediation state and owner.

CLI/UI requirements:

- `envctl table list|get|edit|set|unset|diff|generate|apply --table <name>`
- terminal table widget for CLI editing with preview/apply and schema validation
- GUI table widget backed by the same engine API
- generators for TOML manifest, JSON registry, YAML release graph, `.npmrc` template, Cargo publish plan, Nix flake/bundle plan
- every generated file carries a source DB snapshot hash and is verified by CI

## Sequenced upgrades

1. **Initialize meta-harmony repo** — README + Cargo crate + optional napi package skeleton + release graph schema.
2. **Adopt meta-harmony into meta only after local clone exists** — add `.meta.yaml` entry and ignore policy, then `meta project check`.
3. **Add release graph spec** — YAML/JSON schema generated from DB rows; includes repos, revs, package targets, keys, artifacts, hardware matrix.
4. **Build first Yazelix+Nix portable artifact** — measure size/startup/cold-run/hardware access; compare nix-bundle, nix-portable bundler, AppImage, bundle-dir.
5. **Add envctl DB-first schema** — general config/component/provider/artifact tables in addition to existing secrets schema.
6. **Add CLI table widget** — edit DB rows, preview generated artifacts, write manifests only through generation.
7. **Add GUI parity** — GUI table widget uses same engine APIs.
8. **Drift gate** — CI fails if generated TOML/JSON/YAML does not match DB snapshot.

## Acceptance criteria

- `FlexNetOS/meta-harmony` exists and is initialized with release graph docs/code.
- A measured Yazelix portable release artifact exists and records closure size, file size, startup latency, and host interface list.
- envctl provider wrapper can select system-nix, existing nix-portable, and bundle lanes.
- DB tables generate the current envctl manifest projection without hand edits.
- CLI table widget can modify a component/provider/config row and regenerate TOML/JSON/YAML in preview mode.
- Secrets/keys/certs remain brokered through envctl DB/vault and never land in generated artifacts.
