# LifeOS Portable Release Roadmap

## Executive decision

Build the LifeOS portable release as a meta-orchestrated, runner-proven,
user-space release package for Ubuntu 26.04 x86_64 first. The release is a
portable prefix that LifeOS owns and launches; it is not a replacement for the
host kernel, init system, drivers, package manager, or privileged system state.

This PR does not claim that the release artifact already exists. It creates the
roadmap, architecture package, task graph, and acceptance gates required for the
next implementation PRs to build and prove it.

## Source architecture summary

The release architecture has four owners:

| Owner | Role | Boundary |
|---|---|---|
| FlexNetOS/meta | Release control plane, repo graph, command/MCP roadmap, evidence ledgers | Plans and supervises release work; does not become one giant build script |
| FlexNetOS/flexnetos_runner | Self-hosted Ubuntu build/proof executor | Performs host preflight, build phases, logs, and artifact handoff |
| Yazelix / Nix foundation | Reproducible terminal/runtime bedrock | Provides terminal userland candidates such as Nushell, Zellij, Yazi, Helix, and wrappers |
| FlexNetOS/lifeos | Target app and release filesystem owner | Owns LifeOS app integration, staging layout, runtime manager, and Tauri permission posture |

See [LifeOS Agentic OS Architecture](lifeos-agentic-os-architecture.md) for the
ownership map, control-plane flow, runtime manager boundary, and evidence
classes.

The intended direction is a bare-metal user-space Agentic OS:

- the host Linux kernel keeps hardware, drivers, init, and privileged services;
- the LifeOS release owns a portable runtime prefix;
- Docker, Kubernetes, chroot, bubblewrap, systemd, and host-level installs are
  not default dependencies;
- source-built or AOT-bundled dependencies are preferred over runtime
  interception;
- new tools use a hermetic build-before-adopt path;
- every artifact is inspectable through manifests, checksums, SBOM, provenance,
  and install/rollback contracts.

## Current state from repo evidence

Evidence was inspected before source edits. The LifeOS repo is not cloned in
this workspace, so LifeOS facts below are from GitHub API inspection of
FlexNetOS/lifeos@2c6e43894e54c0fc6a79fd284e3eb36a25579636.

| Status | Evidence | Source |
|---|---|---|
| FACT | meta is a Rust multi-repo command router with a loop engine and subprocess plugin model. | README.md, docs/architecture_overview.md, Cargo.toml |
| FACT | meta supports JSON output, nested repo recursion, snapshots, query DSL, dependency tracking via provides / depends_on, and topological ordering. | README.md, docs/mcp_server.md, .context/VISION_PLAN.md |
| FACT | meta_mcp documents 29 MCP tools for project listing, git operations, build/test, code search, query, impact analysis, snapshots, and batch execution. | docs/mcp_server.md |
| FACT | The current release workflow builds meta, meta-git, meta-project, meta-mcp, meta-rust, and loop archives for multiple targets, then uploads release assets and checksums. | .github/workflows/release.yml |
| FACT | release-please currently manages a simple root package and the workspace version in Cargo.toml. | release-please-config.json, .github/workflows/on-push-main.yml |
| FACT | LifeOS is a Vue 3 + Vite + Pinia + vue-router app with a Tauri 2 shell, Bun scripts, Vitest, a11y/design gates, and a bun.lock. | FlexNetOS/lifeos@2c6e438:README.md, package.json, bun.lock |
| FACT | LifeOS Tauri config targets a dark 1280x800 window, uses bun run dev / bun run build, enables app/deb/rpm/appimage bundles, and includes fs/shell plugins. | FlexNetOS/lifeos@2c6e438:src-tauri/tauri.conf.json, src-tauri/Cargo.toml |
| FACT | LifeOS has lifeos-core and lifeos-daemon crates; lifeos-core includes typed core/storage/plugin-host work and lifeos-daemon is a headless scaffold. | FlexNetOS/lifeos@2c6e438:crates/*/Cargo.toml |
| FACT | flexnetos_runner has a dirty local worktree with active portable-runner changes; this roadmap must not modify it from the meta PR. | /home/flexnetos/FlexNetOS/src/flexnetos_runner git status --short --branch |
| FACT | flexnetos_runner/scripts/install-runner-services.sh treats the prefix as source of truth and systemd as an optional user/system adapter. | /home/flexnetos/FlexNetOS/src/flexnetos_runner/scripts/install-runner-services.sh |
| FACT | fxrun-actions defaults to dry-run, requires confirmation for host/GitHub mutations, and avoids printing tokens. | /home/flexnetos/FlexNetOS/src/flexnetos_runner/crates/runner-actions/src/main.rs |
| FACT | Yazelix is pinned locally at fdcecb70237406555c79a4d1acfd87463d28f9e8 and has a flake with mkYazelix, runtime package helpers, runtime identity, and inputs for Mars, Helix, Zellij, Yazi assets, and related packages. | /home/flexnetos/FlexNetOS/src/yazelix/flake.nix, flake.lock, README.md |
| TARGET | meta release commands should plan, graph, build, prove, package, and publish the LifeOS release in bounded phases. | This roadmap |
| TARGET | LifeOS should stage release docs/manifests under release/agentic-os/ and runtime crates under crates/lifeos-* without committing heavyweight binaries. | Issue #98 |
| QUESTION | The LifeOS repo was inspected remotely, not from a local checkout; implementation PRs that modify LifeOS should clone/check out the exact target branch before editing. | Workspace inspection |
| QUESTION | Yazelix/Nix closure relocatability is not proven by this PR. The first implementation run must prove it or mark the release as host-managed-Nix downgraded. | Yazelix evidence |
| BLOCKER | GPU/CUDA routing is unproven here and must remain future/proof-gated until runner/host evidence exists. | No current runner GPU proof |
| BLOCKER | A real release cannot be claimed until the runner completes package assembly, smoke tests, checksums, SBOM, provenance, and install dry-run gates. | This roadmap |

## Target release definition

Initial target:

    ubuntu-26.04-x86_64

Required artifact names:

    lifeos-agentic-os-ubuntu-26.04-x86_64.tar.zst
    lifeos-agentic-os-ubuntu-26.04-x86_64.SHA256SUMS
    lifeos-agentic-os-ubuntu-26.04-x86_64.SBOM.json
    lifeos-agentic-os-ubuntu-26.04-x86_64.provenance.json
    lifeos-agentic-os-ubuntu-26.04-x86_64.install.sh

Default user-space install prefix:

    ~/.local/share/lifeos-agentic-os

Development staging prefix:

    FlexNetOS/lifeos/dist/lifeos-agentic-os/ubuntu-26.04-x86_64

The installer must not install into /usr, /opt, /etc, /var, /nix, or systemd by
default. Any host integration is an explicit opt-in adapter with separate
confirmation and rollback instructions.

## Non-goals and hard rejections

- Do not describe this as kernel-level isolation.
- Do not claim Ring 0, driver, init, systemd, or host package-manager ownership.
- Do not require Docker, Kubernetes, chroot, or bubblewrap by default.
- Do not execute downloaded binaries without checksum/provenance verification.
- Do not commit heavyweight compiled artifacts to normal Git history.
- Do not expand Tauri filesystem permissions without documented reason and tests.
- Do not claim GPU/CUDA routing until the runner proves the host, driver, and
  package path.
- Do not mark future/planned gates as passing.

## Release filesystem layout

The release artifact is a portable prefix, not a host root:

    lifeos-agentic-os/
      manifest.json
      VERSION
      README.md
      install.sh
      uninstall.sh
      activate.nu
      activate.sh
      bin/
        lifeos
        lifeos-cli
        lifeos-daemon
        meta
        meta-mcp
        yazelix
        nu
        zellij
        yazi
        hx
      sbin/
        lifeos-supervisor
        lifeos-adopt-tool
        lifeos-update-manager
      lib/
        lifeos/
        meta/
        yazelix/
        node-addons/
        rust/
      libexec/
        hooks/
        mcp/
        agents/
        browser/
        toolchain-probes/
      etc/
        lifeos/
          lifeos.toml
          repos.meta.yaml
          mcp.json
          policies/
          sandbox/
          hardware/
          secrets.example.toml
      share/
        applications/
        icons/
        doc/
        completions/
        licenses/
        schemas/
      var/
        db/
          redb/
          lancedb/
          vector/
        cache/
        log/
        run/
        tmp/
        state/
        backups/
      opt/
        tools/
        browsers/
        inference/
        adopted/
      home/
        default/
          .config/
          .local/
      repos/
        meta/
        lifeos/
        yazelix/
        flexnetos_runner/
      sources/
        crates/
        npm/
        git/
      toolchains/
        rust/
        bun/
        node/
        nix/
        cuda-probes/
      manifests/
        checksums.sha256
        sbom.json
        provenance.json
        build-ledger.jsonl
        file-map.json
        license-map.json
      tests/
        smoke/
        fixtures/

Layout rules:

- keep mutable runtime state under var/;
- keep user-editable defaults under etc/ or generated user state;
- keep source snapshots under repos/ and sources/, separate from runtime
  binaries under bin/, sbin/, lib/, and libexec/;
- keep secrets out of tracked files and release artifacts; ship examples only;
- document every non-relocatable path before release adoption;
- use symlinks only where they are portable and proven by the runner.

See [LifeOS Release Filesystem Layout](lifeos-release-filesystem-layout.md).

## Meta control-plane responsibilities

meta should gain a release planning surface that uses the existing repo graph,
plugin model, JSON output, dependency ordering, and MCP visibility. The first
implementation does not need to build the whole release, but it must create the
shape that later phases can fill in.

### LifeOS release manifest

Use a release graph manifest equivalent to:

    projects:
      lifeos:
        repo: https://github.com/FlexNetOS/lifeos.git
        path: repos/lifeos
        tags: [target, app, tauri, bun, rust]
        provides: [lifeos-app]
      meta:
        repo: https://github.com/FlexNetOS/meta.git
        path: repos/meta
        tags: [control-plane, rust, mcp]
        provides: [meta-control-plane, meta-mcp]
      flexnetos_runner:
        repo: https://github.com/FlexNetOS/flexnetos_runner.git
        path: repos/flexnetos_runner
        tags: [runner, proof, release]
        provides: [self-hosted-runner, release-proof]
      yazelix:
        repo: https://github.com/luccahuguet/yazelix.git
        path: repos/yazelix
        tags: [foundation, nix, terminal]
        provides: [runtime-bedrock]

### Planned command surface

    meta release plan lifeos --target ubuntu-26.04-x86_64 --format json
    meta release graph lifeos --target ubuntu-26.04-x86_64
    meta release build lifeos --target ubuntu-26.04-x86_64 --runner flexnetos_runner --dry-run
    meta release prove lifeos --target ubuntu-26.04-x86_64
    meta release package lifeos --target ubuntu-26.04-x86_64 --out dist/
    meta release publish lifeos --target ubuntu-26.04-x86_64 --confirm

### Release evidence outputs

Every non-trivial release run should emit:

    manifests/build-ledger.jsonl
    manifests/provenance.json
    manifests/file-map.json
    manifests/checksums.sha256
    logs/release/*.log

## Runner build/proof responsibilities

flexnetos_runner should execute the build and proof path without mutating host
state by default. The local installer evidence already points in the right
direction: prefix-owned runner homes/work dirs, generated paths, and systemd as
an opt-in adapter.

Runner design requirements:

- GitHub Actions or meta-triggered entrypoint for ubuntu-26.04-x86_64;
- runner labels including self-hosted, linux, x64, and flexnetos;
- Ubuntu 26.04 host preflight and toolchain inventory;
- isolated build workspace and explicit cache policy;
- no-secret log policy and failure evidence retention;
- release artifact output location under the release/staging prefix;
- rerun/resume strategy based on build-ledger state.

Required runner phases:

    R0 preflight host/toolchain check
    R1 checkout/repo graph sync
    R2 build Yazelix/Nix foundation closure or portable runtime extraction
    R3 build meta release binaries: meta, meta-mcp, loop, plugins
    R4 build LifeOS frontend/Tauri/native app
    R5 bundle Bun/Node/Rust/native addons where supported
    R6 assemble portable OS prefix
    R7 run smoke tests inside prefix
    R8 run LifeOS tests/build gates
    R9 run meta control-plane/MCP smoke
    R10 generate SBOM/checksums/provenance
    R11 package tar.zst/install script
    R12 publish draft release or handoff artifact only

See [LifeOS Runner Build Pipeline](lifeos-runner-build-pipeline.md).

## LifeOS target responsibilities

LifeOS owns the app integration and repo-local staging layout:

    FlexNetOS/lifeos/
      release/
        agentic-os/
          README.md
          layout.md
          ubuntu-26.04-x86_64/
            lifeos-agentic-os/
              ...portable prefix tree...
            artifacts/
            manifests/
            logs/
      src-tauri/
        capabilities/
        permissions/
      crates/
        lifeos-supervisor/
        lifeos-update-manager/
        lifeos-runtime/

LifeOS rules:

- preserve the current design-system and Tauri contracts;
- keep heavy compiled artifacts out of Git;
- commit layout docs, manifest schemas, install contracts, and small metadata;
- place large binaries in GitHub Releases or workflow artifacts;
- justify and test any Tauri filesystem permission expansion.

## Yazelix/Nix foundation responsibilities

The release should consume Yazelix as a pinned foundation, not as an ambient host
assumption.

Required strategy:

- pin Yazelix and flake inputs by revision;
- extract or build Nushell, Zellij, Yazi, Helix, Yazelix helpers, and required
  shared runtime files into bin/, lib/, share/, and etc/;
- generate activate.nu and activate.sh so LifeOS can launch the runtime without
  globally polluting the host PATH;
- avoid relying on host /nix/store symlinks unless explicitly documented as a
  temporary blocker;
- if true relocation is not proven, mark the path BLOCKER and choose one of:
  appimage-like wrapper, static/patchelf relocation, bundled closure with stable
  prefix, or host-managed Nix prerequisite as a downgrade.

## Toolchain and dependency bundle strategy

See [LifeOS Toolchain and Dependency Bundle](lifeos-toolchain-and-dependency-bundle.md).

Bundle policy:

- Rust: build meta, meta-mcp, loop, plugins, LifeOS Tauri shell, and
  runtime-manager crates from pinned source.
- Bun/Node: install from lockfiles in isolated sources/cache dirs; bundle only
  required runtime files into the prefix.
- Native addons: include only where the target ABI and provenance are known.
- Browser automation: prefer a local Chrome/Chromium binary with DevTools
  Protocol; do not require a Playwright container by default.
- Search/RAG: plan Redb for local ACID state, LanceDB or SahomeDB for vector
  state, and Spider for search/scraping where evidence supports adoption.
- napi.rs: use only where a Node/Rust boundary is actually required.
- Rust-to-PTX/CUDA: future lane only until runner proof exists.

## Build pipeline phases

The task graph maps roadmap phases to implementation tasks. The first executable
implementation should start at LOR000 and LOR014:

- LOR000 audits current evidence and seals assumptions.
- LOR014 builds a dry-run meta release plan scaffold.

The first scaffold should be read-only by default and should produce JSON that
names the release graph, target, planned phases, inputs, output paths, and open
questions.

## Installation, update, and rollback model

See [LifeOS Install, Update, and Rollback Contract](lifeos-install-update-rollback-contract.md).

Required model:

- install.sh --prefix PATH --dry-run validates target paths and reports planned
  writes without mutating the host;
- normal install writes only inside the selected prefix;
- host adapters such as desktop entries, systemd user units, or shell profile
  hooks require explicit flags;
- update stages a new version under var/tmp or var/state, verifies
  checksums/provenance, then swaps the active version atomically;
- rollback selects a previous verified version from var/backups or an immutable
  version directory.

## Agentic OS runtime model

Runtime components live inside LifeOS, not hidden host magic:

    lifeos-supervisor
      - launches LifeOS front door and shell/runtime services
      - manages var/run and process lifecycle inside the prefix
      - emits structured status rows/logs

    lifeos-update-manager
      - checks target release repo/tags
      - verifies signatures/checksums/provenance before adoption
      - stages update under var/tmp or var/state
      - swaps active version atomically
      - supports rollback

    lifeos-adopt-tool
      - build-before-adopt for new tools
      - compiles in isolated source/build dirs under sources/ and var/tmp
      - promotes into opt/adopted only after proof gates pass

No automatic tool adoption is allowed without policy approval. No downloaded
binary is executable until checksum and provenance verification pass.

## Security and sandboxing model

See [LifeOS Security and Sandbox Policy](lifeos-security-and-sandbox-policy.md).

Security posture:

- user-space prefix discipline, not kernel isolation;
- separated source, build, runtime, config, and mutable state directories;
- no tracked secrets, tokens, private keys, or host-specific secret paths;
- signed/checksummed/provenance-backed artifacts;
- explicit host filesystem access policy;
- Tauri permission expansion only with tests;
- MCP mutation tools blocked by default or confirmation-gated;
- network/browser/GPU access treated as explicit policy surfaces.

## Hardware and GPU routing model

Hardware access stays host-owned. The release may inspect and route through
existing host capabilities, but it does not own drivers or privileged services.

GPU/CUDA is a future lane:

- toolchains/cuda-probes/ may hold probes and evidence scripts;
- etc/lifeos/hardware/ may hold policy templates;
- no CUDA feature is marked FACT until runner proof records hardware, driver,
  toolchain, binary, and smoke-test evidence.

## MCP/agent control-plane model

Roadmap MCP tools should mirror the release command surface:

    meta_release_plan
    meta_release_graph
    meta_release_status
    meta_release_artifacts
    meta_release_provenance
    meta_release_open_questions

Rules:

- read/status tools can be available by default;
- mutation/build/publish tools are blocked by default or require explicit
  confirmation and permission;
- all tool outputs should include target, graph revision, input commits, dirty
  state, planned outputs, evidence path, and open questions.

See [Meta MCP Server](mcp_server.md).

## Validation and release gates

See [LifeOS Release Acceptance Gates](lifeos-release-acceptance-gates.md).

Minimum planned gates:

    # meta
    cargo fmt --check
    cargo clippy --all-targets --all-features
    cargo test
    meta project list --recursive --json
    meta release plan lifeos --target ubuntu-26.04-x86_64 --format json

    # lifeos
    bun install --frozen-lockfile
    bun run test
    bun run build
    cargo check --workspace
    bun run tauri:build

    # release prefix
    ./lifeos-agentic-os/install.sh --prefix "$TMPDIR/lifeos-agentic-os" --dry-run
    ./lifeos-agentic-os/bin/lifeos --version
    ./lifeos-agentic-os/bin/meta --version
    ./lifeos-agentic-os/bin/meta-mcp --help
    ./lifeos-agentic-os/bin/nu --version
    ./lifeos-agentic-os/bin/zellij --version
    ./lifeos-agentic-os/bin/yazi --version
    ./lifeos-agentic-os/bin/hx --version
    ./lifeos-agentic-os/sbin/lifeos-supervisor doctor --json
    sha256sum -c manifests/checksums.sha256

Only commands actually run in a PR may be recorded as passing. Future commands
must be marked PLANNED.

## Task graph

The CSV task graph lives at
[.context/tasks/lifeos-release-task-graph.csv](../.context/tasks/lifeos-release-task-graph.csv).
The file map lives at
[.context/tasks/lifeos-release-task-file-map.csv](../.context/tasks/lifeos-release-task-file-map.csv).

Implementation order:

1. LOR000 through LOR013: seal architecture, evidence, gates, and contracts.
2. LOR014 and LOR015: implement first meta release plan scaffold and manifest
   fixture.
3. LOR016 and LOR017: connect runner dry-run and LifeOS staging docs.
4. LOR018: perform full dry-run validation and reseal manifests.

## Open questions

| ID | Question | Owner | Status |
|---|---|---|---|
| Q1 | Which LifeOS branch should the first implementation PR target? | LifeOS | QUESTION |
| Q2 | Can Yazelix/Nix runtime closure be relocated without host /nix/store reliance? | Yazelix/meta | BLOCKER until proven |
| Q3 | Which runner labels and host image represent Ubuntu 26.04 x86_64 release proof? | flexnetos_runner | QUESTION |
| Q4 | Should meta release be a built-in command, a subprocess plugin, or both? | meta | QUESTION |
| Q5 | Which SBOM/provenance toolchain is preferred for the first release artifact? | meta/runner | QUESTION |
| Q6 | Does LifeOS want release/agentic-os/ committed before runtime crates land? | lifeos | QUESTION |
| Q7 | What signing key policy will be used for release artifacts? | release/security | QUESTION |

## PR/implementation sequencing

Recommended sequence:

1. Roadmap PR: add this docs package, task graph, file map, and navigation links.
2. Meta scaffold PR: implement read-only meta release plan and manifest schema
   fixture.
3. Runner dry-run PR: add R0-R3 preflight/build-plan evidence without artifact
   publication.
4. LifeOS staging PR: add release/agentic-os/ docs, manifest fixtures, and
   runtime-manager crate skeletons.
5. Yazelix extraction PR: prove or downgrade the runtime-bedrock relocation path.
6. First package PR: assemble the prefix, run smoke tests, generate checksums,
   SBOM, provenance, and install dry-run evidence.

PR body requirements for the roadmap PR:

- summary of created/updated roadmap files;
- evidence consulted across meta, lifeos, flexnetos_runner, and Yazelix;
- proposed artifact names and prefix layout;
- task graph IDs and next executable task;
- validation commands and results;
- explicit QUESTION / BLOCKER list;
- confirmation that no secrets or large binaries were committed;
- confirmation that host-level mutation is opt-in only.
