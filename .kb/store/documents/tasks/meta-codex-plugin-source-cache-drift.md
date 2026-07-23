---
id: 019f21d2-6559-7403-ad41-b3e612830f68
slug: tasks/meta-codex-plugin-source-cache-drift
title: "Reconcile Codex GitKB plugin source and installed cache"
type: task
status: completed
priority: high
---

# Summary
Reconcile the source GitKB Codex plugin with the installed plugin cache and the extracted GitKB docs.

# Evidence
- Source `codex-plugins/plugins/gitkb/.codex-plugin/plugin.json` describes "Codex hooks, skills, and MCP config".
- Installed cache `~/.codex/plugins/cache/gitkb/gitkb/0.1.0+codex.20260702020541/.codex-plugin/plugin.json` describes "skills and MCP config" and says workspace lifecycle hooks remain owned by the active session root.
- Source `codex-plugins/plugins/gitkb/hooks/hooks.json` contains broad lifecycle hooks, while the installed cache has `{"hooks": {}}`.
- Extracted docs define `.kb/skills` as canonical, harness directories as adapters, and lifecycle hooks as governed by documented hook surfaces rather than plugin-invented behavior.

# Acceptance Criteria
- [x] Determine whether the installed cache or source tree is the intended current GitKB Codex plugin contract.
- [x] Align source manifest text, hook policy, and README with the intended contract.
- [x] If plugin installation materializes cache artifacts, verify the installed cache matches source after reinstall/update.
- [x] Keep the plugin as a thin adapter; do not vendor the full `git-kb init codex` skill set.
- [x] Add verification commands and results to the task before completion.

# Completion Evidence

- Source plugin bumped to `0.1.1` and now describes a skill-only GitKB code-intelligence adapter.
- Source `hooks/hooks.json` matches the safe installed-cache shape with `{ "hooks": {} }`.
- Source `.mcp.json` is empty to avoid duplicate MCP server registration.
- Reinstalled `gitkb@gitkb`; `codex plugin list --json` reports version `0.1.1`, enabled, source `/home/flexnetos/FlexNetOS/src/meta/codex-plugins/plugins/gitkb`.
- Verified installed cache files under `~/.codex/plugins/cache/gitkb/gitkb/0.1.1/` match the source contract: no command hooks and no MCP servers.
- `make -C codex-plugins release-check` passed.
