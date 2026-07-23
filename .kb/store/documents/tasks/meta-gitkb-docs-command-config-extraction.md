---
id: 019f21fc-2a65-7683-a3bb-f5b5c7be498d
slug: tasks/meta-gitkb-docs-command-config-extraction
title: "Extract GitKB docs commands and configs into implementation tasks"
type: task
status: completed
priority: high
---

# Summary

Walk the extracted GitKB docs snapshot and convert every command/config surface into KB implementation tasks before changing Claude, Codex, or meta-plugin wiring.

This is a planning/proof task only. Implementation waits until the extracted docs have been walked, the command/config inventory is represented in task acceptance criteria, and destructive or adapter-retirement changes have explicit proof gates.

# Source Docs Walked

Snapshot wrapper:
- `docs/gitkb/README.md`

Extracted docs pages:
- `docs/gitkb/index.md`
- `docs/gitkb/getting-started-installation.md`
- `docs/gitkb/getting-started-quick-start.md`
- `docs/gitkb/getting-started-mcp-setup.md`
- `docs/gitkb/reference-agent-harnesses.md`
- `docs/gitkb/getting-started-claude-code.md`
- `docs/gitkb/getting-started-codex.md`
- `docs/gitkb/core-concepts-documents.md`
- `docs/gitkb/core-concepts-knowledge-graph.md`
- `docs/gitkb/core-concepts-code-intelligence.md`
- `docs/gitkb/core-concepts-daemon.md`
- `docs/gitkb/guides-agent-workflows.md`
- `docs/gitkb/guides-team-collaboration.md`
- `docs/gitkb/guides-migration-adoption.md`
- `docs/gitkb/cli-reference.md`
- `docs/gitkb/reference-mcp-tools.md`
- `docs/gitkb/reference-configuration.md`
- `docs/gitkb/reference-supported-languages.md`
- `docs/gitkb/reference-troubleshooting.md`

# Findings

- The docs say `.kb/skills/` is the canonical GitKB workflow source; assistant directories such as `.claude/skills/`, `.codex/skills/`, `.cursor/skills/`, and `.windsurf/skills/` are lightweight adapters.
- The docs explicitly say `kb-*` command-style workflows are skills now, not separate `.claude/commands/` or `.codex/commands/` installs.
- The docs expose a broad command/config surface that needs proof tasks before implementation: harness initialization, MCP registration, `.kb/config.toml`, daemon lifecycle, CLI parity, MCP tool parity, code intelligence, sync/auth/remotes, recovery/destructive commands, and environment variables.
- The docs' public examples use generic remote URLs and generic `git-kb` PATH assumptions; FlexNetOS/meta implementation tasks must prove workspace-specific commands before applying them.
- The CLI reference says it is generated from `git-kb 0.2.6`; live local parity must verify the installed binary version and help output before treating the docs as executable truth.

# Child Tasks Created

- [[tasks/meta-plugin-claude-retirement-proof-plan]]
- [[tasks/meta-plugin-gitkb-harness-generation]]
- [[tasks/meta-plugin-mcp-single-owner-policy]]
- [[tasks/meta-plugin-kb-hooks-config-policy]]
- [[tasks/meta-gitkb-cli-live-parity-suite]]
- [[tasks/meta-gitkb-cli-option-level-parity]]
- [[tasks/meta-gitkb-mcp-tool-parity-suite]]
- [[tasks/meta-gitkb-mcp-parameter-schema-parity]]
- [[tasks/meta-gitkb-config-schema-policy]]
- [[tasks/meta-gitkb-document-graph-view-policy]]
- [[tasks/meta-gitkb-skill-inventory-adapter-parity]]
- [[tasks/meta-gitkb-code-intel-meta-proof-suite]]
- [[tasks/meta-gitkb-daemon-embedding-proof-suite]]
- [[tasks/meta-gitkb-sync-auth-remote-policy]]
- [[tasks/meta-gitkb-bundle-archive-policy]]
- [[tasks/meta-gitkb-recovery-safety-policy]]
- [[tasks/meta-gitkb-docs-gap-audit-2]]

# Acceptance Criteria

- [x] All extracted GitKB docs listed above have been read at least once in this loop.
- [x] Every command/config family from the docs is represented in one or more child tasks.
- [x] Claude retirement is represented as a proof-first task, with no `.claude` deletion or reset before Claude binary/plugin behavior is tested.
- [x] MCP ownership is represented as a single-owner policy task.
- [x] Destructive or recovery commands are represented in a safety-policy task that requires dry-run/backup/proof before mutation.
- [x] KB commit records this task set before implementation starts.

# Evidence

- `find docs/gitkb -maxdepth 1 -type f | sort` showed the extracted docs set plus wrapper.
- `wc -l docs/gitkb/*.md` showed 8,063 lines across the docs snapshot.
- `rg '^#{1,4} ' docs/gitkb` was used to walk the page structure.
- `rg` and direct `sed` reads were used to extract command/config blocks, CLI command names, MCP tool names, and config sections.
