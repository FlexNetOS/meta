# LifeOS Release Acceptance Gates

## Purpose

This file defines the gates for the LifeOS portable release program. A command
may be listed as PLANNED before it exists, but it may be marked PASS only when it
has actually run in the relevant PR or release run.

## Roadmap PR gates

| Gate | Command | Required now |
|---|---|---|
| Diff whitespace | git diff --check | Yes |
| CSV parse | python3 CSV DictReader check from issue #98 | Yes |
| No large binaries | find changed files and inspect file types/sizes | Yes |
| No secrets | scan changed files for tokens/private-key markers | Yes |
| Rust gates | cargo fmt/clippy/test | Only if Rust code or workflow logic changes |

## Meta implementation gates

Planned commands:

    cargo fmt --check
    cargo clippy --all-targets --all-features
    cargo test
    meta project list --recursive --json
    meta release plan lifeos --target ubuntu-26.04-x86_64 --format json

Required evidence:

- release plan JSON includes target, graph, phases, input refs, output paths,
  open questions, and dirty-state result;
- release graph is topologically ordered;
- mutation/publish commands are confirmation-gated.

## LifeOS gates

Planned commands:

    bun install --frozen-lockfile
    bun run test
    bun run build
    cargo check --workspace
    bun run tauri:build

Required evidence:

- LifeOS branch/commit;
- bun.lock hash;
- Tauri config/capability diff if permissions change;
- design-system and a11y gates when UI or permissions change.

## Runner gates

Planned commands and outputs:

| Phase | Gate | Evidence |
|---|---|---|
| R0 | host/toolchain preflight | host.json, toolchains.json |
| R1 | repo graph sync | repo-lock.json, dirty-state.json |
| R2 | Yazelix extraction/relocation proof | relocation-report.json |
| R3 | meta binaries build | meta-binaries.json |
| R4 | LifeOS build | lifeos-build.json |
| R6 | prefix assembly | file-map.json |
| R10 | checksum/SBOM/provenance | checksums.sha256, sbom.json, provenance.json |
| R11 | package artifact | artifact-manifest.json |

## Prefix smoke gates

Planned commands:

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

## Release publication gate

Publication is blocked until:

- all planned gates for the release target are PASS or explicitly deferred;
- deferred gates are not required for the claimed artifact;
- checksums, SBOM, provenance, file map, and ledger exist;
- no secrets or large untracked binaries are present in Git;
- host-level mutation remains opt-in only;
- open BLOCKER items are resolved or the artifact is explicitly downgraded.
