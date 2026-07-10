## Project Architecture: Meta-Repo (NOT a monorepo)

This is a **meta-repo** — a workspace of independent git repositories managed by the `meta` CLI tool. Each directory listed in `.meta` (the project config) is a **separate git repo** with its own remote, commits, and history. NEVER treat this as a monorepo. New crates must be separate git repos added to `.meta` and `.gitignore`.

## FlexNetOS Root Authority

`/home/flexnetos/meta` is both the real `FlexNetOS/meta` Git checkout and the
authoritative control-plane root. Its `.git`, `.kb`, `.meta.yaml`, and tracked
policy files identify Meta and own the peer-repository fleet.

- LifeOS is the independent product repository at
  `/home/flexnetos/meta/lifeos`.
- Additional independent peers live under `/home/flexnetos/meta/src`.
- Runtime, archive, release, and host-projection directories at this root are
  Meta-owned payload, but are ignored by the Meta Git repository.
- `/home/flexnetos/lifeos` is retired and must not be recreated as a competing
  workspace root or authority layer.
- `/home/flexnetos/FlexNetOS` is a compatibility link to this Meta root, not a
  separate identity.

READ `.kb/AGENTS.md`.
