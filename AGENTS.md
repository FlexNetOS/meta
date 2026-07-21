## Project Architecture: Meta-Repo (NOT a monorepo)

This is a **meta-repo** — a workspace of independent git repositories managed by the `meta` CLI tool. Each directory listed in `.meta` (the project config) is a **separate git repo** with its own remote, commits, and history. NEVER treat this as a monorepo. New crates must be separate git repos added to `.meta` and `.gitignore`.

## FlexNetOS Root Authority

`/home/flexnetos/meta` is both the real `FlexNetOS/meta` Git checkout and the
authoritative control-plane root. Its `.git`, `.kb`, `.meta.yaml`, and tracked
policy files identify Meta and own the peer-repository fleet.

- LifeOS is a Meta peer repository at
  `/home/flexnetos/meta/src/lifeos`.
- All independent peers live under `/home/flexnetos/meta/src`; LifeOS is not a
  special root-level child or a separate authority layer.
- Runtime, archive, release, and host-projection directories at this root are
  Meta-owned payload, but are ignored by the Meta Git repository.
- `/home/flexnetos/lifeos` is retired and must not be recreated as a competing
  workspace root or authority layer.
- `/home/flexnetos/FlexNetOS` is a compatibility link to this Meta root, not a
  separate identity.

READ `.kb/AGENTS.md`.

## Active-tool `~/.local/share` state — restart-gated migration to the Meta payload

**Status (2026-07-21).** Sole remaining `.local` residual in the FlexNetOS operational
environment. Meta-repo docs conformance and meta-root `.local` are already done
(meta PR #110; ~1.7G of dev-host `.local`/shadow state relocated to `meta/var/archives/`;
single nix-profile owner confirmed). This note records the one piece that a session-
internal agent structurally cannot finish.

**Subject.** The FlexNetOS agent tools `icm`, `rtk`, `yazelix`, `weave`, `env-ctl` keep
durable data under `~/.local/share/<tool>` because `XDG_DATA_HOME` is unset (→
`~/.local/share`). Under the single-profile path law and the RuVector blueprint (files
are projections; one canonical source), that durable tool state belongs in the Meta
payload `meta/var/xdg-data/<tool>` — the tier already hosting
`var/lib/{postgresql,ruvector,agentdb,envctl,gitkb}`.

**Why it cannot be eliminated from inside a running session (empirically verified).**
An agent running inside a yazelix session cannot remove the `.local` its own live
toolchain is bound to:
- Tools resolve their data dir from the session env at process start; the running
  process's env is immutable mid-session.
- `~/.local/share/yazelix` is written continuously by the **running zellij** that hosts
  the session (`YAZELIX_STATUS_BAR_CACHE_PATH`, `STARSHIP_CONFIG`) — un-movable without
  ending the session.
- ICM's `[store].path` config key is parsed but **ignored** for the default DB (only
  `--db` / `ICM_DB` / the XDG default apply — its docs say "the CLI reads the DB only
  from `--db`"; tested: a probe with `[store].path` set still landed in `~/.local`).
- `rtk` has no data-dir config (`[tracking]/[display]/[filters]/[tee]/[telemetry]/
  [hooks]/[limits]` only).
- envctl's `bootstrap_env_vars` table is inert without regeneration, and `envctl` is not
  on PATH from an in-session shell — so its committer path is unreachable in-session.
- Removing a dir → recreated on the next tool call (env still points there). Root
  bind-mount and symlinks are disallowed; a session cannot restart itself.

**The fix (owner action; one session restart).** Single lever = `XDG_DATA_HOME` /
`XDG_STATE_HOME`, owned by envctl's agent-env engine
(`meta/var/lib/envctl/tables/bootstrap_env_vars.csv`; rows currently point at
`~/.local/share` / `~/.local/state`):
1. `meta/var/ops/migrate-tool-state-off-dotlocal.sh migrate` — copy
   `~/.local/share/{tools}` → `meta/var/xdg-data` (+ `xdg-state`); verifies icm db
   integrity. (100M already staged; re-run to sync before restart.)
2. Via **envctl's committer** (sole authoritative committer — do NOT hand-edit the live
   table): `XDG_DATA_HOME` → `/home/flexnetos/meta/var/xdg-data`, `XDG_STATE_HOME` →
   `/home/flexnetos/meta/var/xdg-state`; add
   `ICM_DB=/home/flexnetos/meta/var/xdg-data/icm/memories.db`; leave `YAZELIX_STATE_DIR`
   unset (yzx baked default `/run/user/1001/yazelix/profile-runtime/yazelix`).
3. **Restart the yazelix session** so the agent env adopts the new roots.
4. `migrate-tool-state-off-dotlocal.sh verify` → `finalize` (removes
   `~/.local/share/{tools}` + `~/.local/state/env-ctl`; `finalize` refuses unless
   `XDG_DATA_HOME` is already redirected).

Full runbook: `meta/var/ops/README-migrate-tool-state.md`.
