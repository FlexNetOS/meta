---
id: 019ec10c-94e5-76f0-9d3d-d4f9f4e81a92
slug: tasks/seed-unlock-under-systemd
title: "Seed-unlock under systemd: switch seed_factor from ssh to REST custody API over Cognitum CA"
type: task
status: active
priority: high
tags: [envctl, secretd, seed-factor, cognitum, systemd, store-robustness]
---

# Overview

The Cognitum Seed USB possession factor (`seed-factor`, PR #50, merged to master)
works when driven from an interactive shell, but **fails under the `env-ctl.service`
systemd sandbox**: `secretctl unlock` (USB-first) returns `unlock failed` (NOT a
baton error — that's fixed by #53). The daemon's `seed_factor::sign_hex`
(`crates/secrets-engine/src/seam.rs`) resolves the Seed keyfile by shelling
`std::process` `ssh genesis@169.254.42.1`, which the systemd sandbox breaks.

## Root cause (diagnosed 2026-06-13)

`env-ctl.service` (systemd `--user`) runs with `ProtectHome=read-only`,
`PrivateTmp=yes`, `ProtectSystem=strict`, empty `Environment=`. The daemon's `ssh`
to the Seed fails because:
- The Seed has **no `~/.ssh/known_hosts` entry** and the seam uses `BatchMode=yes`
  WITHOUT `StrictHostKeyChecking=accept-new` → host-key verification fails
  non-interactively.
- `ProtectHome=read-only` means even `accept-new` can't write `known_hosts`.
- A `Bad owner or permissions on /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf`
  error surfaced under the replicated sandbox.
- No ssh-agent in the service context.

Shelling `ssh` from a sandboxed daemon is fundamentally fragile.

## Decision / Fix

**Switch the `seed_factor` backend from `std::process` `ssh` to the Seed's REST
custody API** (`POST /api/v1/custody/sign`) over the **installed Cognitum CA** —
no `ssh`, no `known_hosts`, no agent, no home access. The CA is name-constrained to
`169.254.x.x` + `.local` and already trusted system-wide, so a pure-Rust
ring-rustls client validates the Seed's TLS without `-k`. This works under the
systemd sandbox AND is the cleaner architecture (the `ssh` path was only ever right
for the interactive bootstrap). Use the localhost-only pairing window → `pair` →
bearer → `custody/sign`, all over TLS.

## Goals

- `secretctl unlock` (USB-first) succeeds against `env-ctl.service` with the Seed present.
- No `ssh`/`known_hosts`/agent dependency in the daemon's Seed path.
- Keep `no-c` gate green (ring-only rustls; validate against the Cognitum CA via a
  pinned root, not the OS store — mirror the FS-S7 frozen-roots discipline).

## Acceptance Criteria

- [ ] `seed_factor::sign_hex` (and `keyfile_for`) use the REST custody API + CA, not `ssh`.
- [ ] Bearer-token bootstrap handled (pair via localhost window; store/refresh device-bound token).
- [ ] Live: `secretctl unlock` via the Seed works against the running `env-ctl.service`.
- [ ] secrets-engine tests + no-c/shape/enable gates PASS; default build unchanged.

## Context / Done so far

- PR #50 (MERGED, master): seed-factor — `RealUsbProbe` Seed-sign KEK, `SeedPresenceGate`
  Profile S, secretd `Vault.Init --enroll-usb` + unlock, Profile S → relay gate (5s presence cache).
- PR #53 (MERGED, master): libSQL `invalid baton` reconnect fix — the original `unlock`
  blocker. Kernel card `KBTASK-LIBSQL-BATON-REFRESH` done.
- Installed seed-factor `secretd` from master + restarted `env-ctl.service` (PID 3986760, healthy);
  baton error gone.
- Immediate owner unlock path: `printf PASS | secretctl unlock --passphrase-stdin` (needs EOF, not Enter).

## Related follow-ups (smaller)

- `status.usb_possessed` is a hardcoded `false` stub (grpc.rs) — make it reflect real state cheaply.
- HARDEN `keyfile_for`: verify the Seed signature against the pinned device pubkey (Profile S already does).
- ADR-0007's phantom `secretctl import` (correct verb `secretctl secret add`) — in the **handoff** repo.

## References

- `PLAN-cognitum-seed-envctl-vault-factor.md` (meta root) — full design + spike log.
- `envctl/docs/adr-seed-usb-possession-factor.md` — the accepted ADR.
- Seed REST: `POST /api/v1/custody/sign`, `/identity`, `/pair/window`→`/pair` (device-served `/guide`).
- Concurrent agenticOS loop owns envctl `develop` (#47–#56 merged); this work is on `master`.
