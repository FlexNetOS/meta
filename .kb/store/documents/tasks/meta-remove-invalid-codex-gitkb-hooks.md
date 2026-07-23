---
id: 019f21d2-756e-7781-9363-ba08ccd0343c
slug: tasks/meta-remove-invalid-codex-gitkb-hooks
title: "Remove invalid Codex GitKB hook command wiring"
type: task
status: completed
priority: high
---

# Summary
Remove or redesign Codex plugin hook wiring that calls an unavailable `git-kb hook codex` command.

# Evidence
- Source `codex-plugins/plugins/gitkb/hooks/hooks.json` calls `git-kb hook codex` for `SessionStart`, `UserPromptSubmit`, `PreToolUse`, `PermissionRequest`, and `PostToolUse`.
- Installed `/home/flexnetos/FlexNetOS/usr/bin/git-kb 0.2.12` reports `hook` as an unrecognized subcommand.
- Installed plugin cache currently has hooks disabled with `{"hooks": {}}`.
- Extracted docs show `git-kb init git hooks` for Git hooks and `[hooks]` config toggles for lifecycle behavior, but do not document `git-kb hook codex`.

# Acceptance Criteria
- [x] Confirm no supported `git-kb hook codex` command exists in the installed CLI or source help.
- [x] Remove source plugin lifecycle hooks or replace them only with a documented supported command.
- [x] If future hook parity is needed, route it through documented GitKB hook/config surfaces.
- [x] Verify plugin hook JSON parses and cannot call a missing command.
- [x] Record the before/after diff against the installed plugin cache.

# Completion Evidence

- `/home/flexnetos/FlexNetOS/usr/bin/git-kb hook --help` exits with `unrecognized subcommand 'hook'`, confirming `git-kb hook codex` is not supported by installed `git-kb 0.2.12`.
- Replaced source `codex-plugins/plugins/gitkb/hooks/hooks.json` with an empty hooks object.
- Updated `codex-plugins/tests/package-policy.sh` to fail if command hooks are present or if plugin-owned MCP servers are present.
- `jq empty` passed for the plugin manifest, hooks config, MCP config, and marketplace manifests.
- `make -C codex-plugins release-check` passed.
