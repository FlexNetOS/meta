# Agent Plugin Control Plane

Meta is the control plane for this workspace, but Claude Code and Codex still load different assistant plugin payload formats. The clean model is to define capabilities once in meta, then generate or validate the assistant-specific outputs from that shared source.

## Boundaries

- `meta-plugins/` is the registry for meta CLI subprocess plugins. These are executable `meta-*` command planners loaded by the `meta` CLI.
- `claude-plugin/` is the Claude Code plugin payload for meta. Claude plugins may include skills, commands, agents, hooks, and `.mcp.json` at the plugin root.
- `codex-plugins/plugins/*/` contains Codex plugin payloads. Codex plugins may include skills, app mappings, hooks, and `.mcp.json` at the plugin root.
- `claude-plugins/` and `codex-plugins/` are marketplace publication catalogs for their respective assistants.
- `.claude/` and `.codex/` in a project are repo-local adapters, not the source of truth for marketplace payloads.

## MCP Ownership

Each MCP server name must have one owner per assistant configuration. A server can be owned by a plugin payload or by user/project config, but not both at the same time.

For the FlexNetOS meta workspace, GitKB MCP is owned by global Codex config:

```toml
[mcp_servers.gitkb]
command = "/home/flexnetos/FlexNetOS/usr/libexec/gitkb-mcp-meta"
```

That wrapper sets `GITKB_ROOT=/home/flexnetos/FlexNetOS/src/meta` and launches the workspace GitKB MCP binary. The GitKB Codex plugin therefore leaves `.mcp.json` empty so installing the plugin does not create a second `gitkb` server.

Validate this invariant with:

```bash
meta plugin doctor-mcp --server gitkb
meta plugin doctor-mcp --server gitkb --json
```

The validator scans project MCP files, assistant adapter configs, repo plugin payloads, the global Codex config, and Codex plugin cache `.mcp.json` files. It prints the owning file and every conflicting file before suggesting that conflicts be removed.

## Migration Rule

When moving standalone assistant configuration into a plugin payload, remove or retire the original standalone files after proving the plugin covers the behavior. This prevents duplicate command, hook, skill, or MCP surfaces.

The migration order is:

1. Inventory existing standalone and plugin-provided surfaces.
2. Pick the source of truth for each capability.
3. Generate or edit the assistant-specific payload.
4. Validate manifests and JSON configs.
5. Retire duplicate standalone surfaces only after verification.

## GitKB Harness Adapter Generation

GitKB workflow skills remain canonical under `.kb/skills/`. Assistant harness
directories are generated or validated as adapters from one meta-owned manifest
schema:

```text
name: gitkb-harness-adapters
schema_version: 1
canonical_skill_root: .kb/skills
adapters:
  - harness: claude
    target_root: .claude/skills
  - harness: codex
    target_root: .codex/skills
```

Run the dry-run plan before writing:

```bash
meta plugin harness --harness all
meta plugin harness --harness all --json
```

The plan lists missing adapter symlinks as `create`, matching symlinks as
`valid`, and existing non-generated paths as `dirty`. It also reports removals;
the current GitKB harness manifest is additive, so removals are `none`.

Writing is explicit:

```bash
meta plugin harness --harness codex --write
```

Dirty adapter paths are never overwritten silently. To replace a dirty path, the
operator must provide a backup/proof directory:

```bash
meta plugin harness --harness claude --write --backup-dir .meta/backups/harness-YYYYMMDD
```

This keeps Claude and Codex adapters pointed at `.kb/skills/` without
hand-maintained drift, while preserving existing local files before replacement.
