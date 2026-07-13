# Meta Fleet Agent-Environment Policy

Meta is the fleet control plane; each member remains an independent repository.
The authoritative participant set is parent Meta plus `.meta.yaml` entries
whose `path` begins with `src/`. Never infer the set from a raw directory scan.

## Shared baseline

`skills/meta-gitkb-review` is deliberately narrow. It supplies review workflow
guidance only and has no MCP declarations or binary wrappers. Envctl-specific
skills, CodeDB, and remote MCP entries are not fleet defaults.

Each peer commits its own `agent-env.yaml` and `agent-env.lock`. Peer configs
pin a reviewed Meta commit and source this skill through the Meta repository;
they do not inherit a local `../envctl` configuration.

## Fleet procedure

From the Meta root, always preview the declared source peer scope first:

```nu
^meta exec --dry-run --include src -- ^envctl agent audit --config agent-env.yaml --scope project --locked
```

Run the root audit separately, then use the same `meta exec --include src`
frontdoor for peer audits and syncs. `meta git review` is not a valid policy
executor unless an installed Git `review` subcommand is independently proven.

Before changing a peer, use its native GitKB/Codex adapters and inspect its MCP
owners. Do not force `git kb init codex`: it is an adapter initializer, not an
agent-env convergence check, and it deliberately leaves existing files alone.
