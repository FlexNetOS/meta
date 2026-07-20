---
name: meta-gitkb-review
description: Review a FlexNetOS Meta peer through the shared Meta/GitKB policy while preserving its independent repository and native assistant adapters.
---

# Meta / GitKB Peer Review

Use this skill when reviewing work in a repository registered by the Meta
control plane. The repository remains independent: do not treat `meta/src` as
a monorepo, copy another peer's rules, or replace its native Codex/Claude
adapter.

## Establish scope

1. From the Meta root, inspect `meta project list --json`. Parent Meta plus
   declared projects with a `path` beginning `src/` are the fleet policy scope.
   Do not discover raw directories below `src/`; worktrees, fixtures, and
   vendor payloads are not policy participants.
2. Use `meta exec --include src -- <command>` for a declared-peer fleet action.
   Audit the parent Meta repository separately.
3. `meta git review` is only a pass-through. Do not use it unless `git review`
   is installed and its behavior has been verified. Use the declared command
   through `meta exec` instead.

## Review workflow

1. Read the repository's `AGENTS.md` and `.kb/AGENTS.md` when present.
2. Start or locate a GitKB task before a non-trivial change. Use current CLI
   forms such as `git kb list --path context/`, `git kb show <slug>`,
   `git kb checkout <slug>`, and `git kb commit -m <message> <pathspec>`.
3. Compare the task criteria with source and tests. Record each criterion as
   done, partial, not done, or needing behavioral verification.
4. Preserve one owner for every MCP server. A repo-local config, a global
   config, and a plugin must not claim the same server name.
5. Treat `.claude/` and `.codex/` as native, repository-local adapters. Add
   this skill only; do not mirror a Claude surface into Codex or overwrite an
   existing adapter to make it look uniform.

## Agent-environment verification

`envctl` is source-owned by the declared peer at `meta/src/envctl`; it is not
an ambient PATH binary. Use the profile-owned Nu and RTK frontdoors to resolve
that repository from the current Meta/peer checkout, then run both read-only
gates through Cargo:

```nu
let project = (^/home/flexnetos/.nix-profile/bin/rtk proxy -- git rev-parse --show-toplevel | str trim)
let config = ($project | path join "agent-env.yaml")
let meta_root = ($env.META_ROOT? | default "/home/flexnetos/meta")
let envctl_repo = ($meta_root | path join "src" "envctl")

cd $envctl_repo
^/home/flexnetos/.nix-profile/bin/rtk proxy -- cargo run --locked -q -p envctl -- agent lock --config $config --scope project --check --locked --json --color never
^/home/flexnetos/.nix-profile/bin/rtk proxy -- cargo run --locked -q -p envctl -- agent audit --config $config --scope project --json --color never
```

`agent lock --check --locked` proves config/lock agreement without network or
writes. `agent audit` separately proves installed skill, command, and MCP
ownership; `audit` does not accept a `--locked` flag. If either gate reports an
MCP conflict, an untracked shadow, or a hash mismatch, stop and resolve the
owning input; never hand-edit generated runtime outputs.

## What is not a fleet default

- `agent-env-codex`, `agent-env-config`, `env-stabilize`, and
  `env-toolchain-install` are envctl-specific.
- `codedb-config-tables` is conditional on a verified CodeDB/Yazelix use case.
- Exa or any other MCP is conditional on explicit per-assistant ownership.
- Yazelix alone owns the Nix profile and Nu/RTK runtime. This skill consumes
  that profile-owned toolchain while keeping envctl source-owned.
