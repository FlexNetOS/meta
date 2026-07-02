# LifeOS Install, Update, and Rollback Contract

## Purpose

Installation must be user-space by default. The installer writes only into the
selected prefix unless the operator passes an explicit host-adapter flag.

## Artifact inputs

The installer consumes:

- lifeos-agentic-os-ubuntu-26.04-x86_64.tar.zst
- lifeos-agentic-os-ubuntu-26.04-x86_64.SHA256SUMS
- lifeos-agentic-os-ubuntu-26.04-x86_64.SBOM.json
- lifeos-agentic-os-ubuntu-26.04-x86_64.provenance.json
- lifeos-agentic-os-ubuntu-26.04-x86_64.install.sh

## Install modes

| Mode | Command shape | Host mutation |
|---|---|---|
| Dry run | install.sh --prefix PATH --dry-run | None |
| User install | install.sh --prefix PATH | Prefix only |
| Desktop adapter | install.sh --prefix PATH --install-desktop-entry | User desktop dirs only |
| User service adapter | install.sh --prefix PATH --install-user-service | User systemd only |
| System adapter | install.sh --prefix PATH --install-system-adapter --confirm-host-mutation | Explicit privileged handoff |

The default prefix is:

    ~/.local/share/lifeos-agentic-os

The installer must reject /usr, /opt, /etc, /var, /nix, and systemd writes unless
an explicit host-adapter mode was selected.

## Preflight

The installer checks:

- target OS and architecture match ubuntu-26.04-x86_64 or are explicitly allowed;
- prefix path is user-writable;
- archive checksum matches SHA256SUMS;
- provenance target, commit set, and artifact names match;
- no tracked secret templates contain real secret values;
- install destination is empty or contains a compatible previous LifeOS release.

## Update model

1. Download or receive the new artifact set.
2. Verify checksums, SBOM, and provenance before extraction.
3. Extract under var/tmp/update-<version> or a versioned staging directory.
4. Run install dry-run against the staged prefix.
5. Run smoke tests and lifeos-supervisor doctor --json.
6. Atomically update the active pointer or version directory.
7. Move the previous active version into var/backups/ or preserve the prior
   immutable version directory.

## Rollback model

Rollback requires:

- a previous version directory or backup;
- its original checksums/provenance;
- a clean var/run state or stopped supervisor;
- a post-rollback doctor result.

Rollback must not delete user data under var/db, var/state, or user-managed
configuration unless the operator explicitly requests a destructive reset.

## Uninstall model

uninstall.sh removes only files recorded in manifests/file-map.json and created
by the installer. User data under var/ is preserved by default and removed only
with a confirmation flag.

## Evidence

Each install/update/rollback run appends a JSON line to:

    manifests/build-ledger.jsonl

The row should include command, timestamp, prefix, target, artifact checksum,
provenance id, result, and log path.
