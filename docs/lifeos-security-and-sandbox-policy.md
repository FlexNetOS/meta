# LifeOS Security and Sandbox Policy

## Purpose

LifeOS portable release security is based on provenance, prefix discipline,
explicit host boundaries, and verifiable rollback. It is not kernel-level
isolation.

## Boundary model

| Surface | Policy |
|---|---|
| Prefix | All default install/runtime files stay under the selected LifeOS prefix |
| Host root paths | /usr, /opt, /etc, /var, /nix, and systemd are untouched by default |
| Source dirs | repos/ and sources/ hold source snapshots and package inputs |
| Build dirs | var/tmp and sources/ hold build-before-adopt work |
| Runtime state | var/db, var/cache, var/log, var/run, var/state, var/backups |
| User config | etc/lifeos defaults plus generated user state |
| Secrets | examples only in artifacts; real secrets are external/user supplied |

## Secrets policy

Forbidden in tracked files and release artifacts:

- API tokens;
- private keys;
- cookies;
- passwords;
- real host-specific secret paths;
- decrypted credential stores.

Allowed:

- secrets.example.toml with placeholder values;
- policy documentation;
- redacted evidence that proves a secret provider was used without exposing the
  secret value.

## Artifact verification

Every artifact set must include:

- SHA256SUMS;
- SBOM.json;
- provenance.json;
- file-map.json;
- build-ledger.jsonl.

The installer verifies checksums and provenance before extraction. The update
manager verifies before adoption.

## Host filesystem policy

Default runtime access is prefix-local. Any expansion must state:

- path or path class;
- reason;
- read/write mode;
- requesting component;
- user consent mechanism;
- test or smoke gate.

## Tauri permission policy

LifeOS currently has a Tauri FS/shell posture. Any release work that expands
filesystem permissions must update LifeOS capability/permission files, explain
why the path is needed, and add a LifeOS test gate.

## MCP mutation policy

Read/status release MCP tools may be enabled by default. Build, publish, adopt,
or host-mutating tools require explicit confirmation and should be disabled in
untrusted contexts.

## Adopted tool policy

lifeos-adopt-tool must:

- download or read source into sources/;
- build in an isolated build dir under var/tmp or sources/;
- record source revision and checksums;
- run proof gates;
- promote only into opt/adopted after success.

No automatic execution of downloaded binaries is allowed.

## Network policy

Network access is phase-specific and recorded in the ledger. Build phases may
fetch from pinned registries/remotes. Runtime network access must be governed by
LifeOS policy and surfaced to the user.

## Browser automation policy

Prefer a local Chrome/Chromium binary controlled through DevTools Protocol. Do
not require a Playwright container by default. Browser downloads, profiles, and
automation logs must be prefix-local and provenance-recorded.

## GPU and hardware policy

The host owns GPU drivers and hardware access. LifeOS may probe and route only
after proof. GPU/CUDA support is BLOCKER status until the runner records host
inventory, driver/toolchain evidence, and a smoke test.

## Rollback and recovery

Rollback must preserve user data by default. Recovery evidence includes
provenance, checksums, previous version pointer, doctor output, and logs.
