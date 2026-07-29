# LifeOS Release Filesystem Layout

## Purpose

The LifeOS portable release is a relocatable or explicitly non-relocatable
prefix. It mirrors familiar OS directories for clarity, but it is not the host
root and must not mutate privileged host paths by default.

## Required tree

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

## Directory contract

| Path | Contents | Mutable at runtime |
|---|---|---|
| bin/ | User-facing executables | No |
| sbin/ | Supervisor, update, and adopt tools | No |
| lib/ | Runtime libraries and app resources | No |
| libexec/ | Private helper programs, MCP adapters, probes | No |
| etc/lifeos/ | Default config, policies, schemas, examples | User overlay only |
| share/ | Docs, icons, desktop metadata, completions, licenses | No |
| var/ | Runtime DBs, logs, caches, state, backups | Yes |
| opt/ | Optional adopted tools and browser/inference payloads | Policy controlled |
| home/default/ | Initial user config template | No after install |
| repos/ | Source snapshots for reproducibility | No during runtime |
| sources/ | Package/source caches used during build/adopt | Build/adopt only |
| toolchains/ | Rust, Bun, Node, Nix, CUDA probe payloads | Build/adopt only |
| manifests/ | Checksums, SBOM, provenance, file map, ledger | Append/sealed |
| tests/ | Smoke tests and fixtures | No |

## Relocatability

The release must be relocatable unless a file map entry marks a path as
non-relocatable with reason, owner, and mitigation. Acceptable temporary
mitigations are:

- appimage-like wrapper;
- static or patchelf relocation;
- bundled closure with stable prefix;
- documented host-managed Nix prerequisite as a downgrade.

## File map fields

manifests/file-map.json should record:

| Field | Meaning |
|---|---|
| path | Prefix-relative path |
| kind | file, dir, symlink |
| owner | meta, lifeos, yazelix, runner, third-party |
| mutable | true or false |
| source | repo path, package, or generated step |
| checksum | sha256 for files |
| license | license id or reference |
| relocatable | true, false, or unknown |
| notes | reason for special handling |

## Large artifact rule

Normal Git history should contain docs, manifests, schemas, fixtures, and small
metadata only. Heavy binaries, release archives, toolchains, caches, and built
runtime payloads belong in workflow artifacts or GitHub Releases.
