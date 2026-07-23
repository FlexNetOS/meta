---
id: 019f21d6-9507-7a90-92bd-7c43190f7015
slug: tasks/meta-implement-unified-agent-plugin-control-plane
title: "Implement unified meta-owned agent plugin control plane"
type: task
status: completed
priority: high
---

# Summary
Implement the first safe slice of the unified meta-owned agent plugin control plane: make source plugin payloads reflect documented ownership, remove invalid Codex hook wiring, and document MCP ownership boundaries without breaking active global config.

# Related Tasks
- [[tasks/meta-unified-agent-plugin-control-plane]]
- [[tasks/meta-codex-gitkb-mcp-ownership]]
- [[tasks/meta-codex-plugin-source-cache-drift]]
- [[tasks/meta-remove-invalid-codex-gitkb-hooks]]
- [[tasks/meta-clear-stale-codex-hook-trust-state]]
- [[tasks/meta-retire-stale-claude-kb-commands]]

# Implementation Order
1. Codex GitKB MCP ownership: document one-owner rules and verify active config.
2. Codex GitKB plugin source/cache drift: align source payload intent with installed cache and official docs.
3. Invalid Codex GitKB hooks: remove missing `git-kb hook codex` calls from source plugin payload.
4. Stale Codex hook trust state: research and prepare safe cleanup path; do not mutate global config without backup.
5. Claude `kb-*` command wrappers: audit before removing; document migration to skills/plugin payload.

# Acceptance Criteria
- [x] Add/adjust docs so meta is described as the control plane that generates or validates assistant-specific plugin payloads.
- [x] Ensure source `codex-plugins/plugins/gitkb` no longer advertises or installs invalid lifecycle hooks.
- [x] Ensure MCP ownership is explicit enough to prevent duplicate `gitkb` server registration.
- [x] Add validation or smoke commands for marketplace/plugin manifests.
- [x] Update linked KB tasks with evidence and completion state for the implemented slice.
- [x] Do not remove Claude wrappers or mutate global Codex config unless the supported cleanup path is proven.

# Completion Evidence

- Added `docs/agent_plugin_control_plane.md`.
- Updated `codex-plugins/README.md` and `claude-plugins/README.md` to define assistant-specific marketplaces as generated/validated outputs from meta's control plane.
- Updated GitKB Codex plugin source to version `0.1.1`, skill-only guidance, empty hooks, and empty MCP config.
- Reinstalled local `gitkb@gitkb` Codex plugin; cache now reports version `0.1.1`.
- Backed up global Codex config, removed only stale trust entries for missing `src/meta/.codex/hooks.json`, and verified with `codex doctor`.
- Left `tasks/meta-retire-stale-claude-kb-commands` active because Claude loader proof is not available in this environment and `.claude/commands/kb-*` already has unrelated dirty edits.
