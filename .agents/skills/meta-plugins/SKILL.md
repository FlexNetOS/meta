---
name: meta-plugins
description: Use when installing, listing, debugging, or authoring meta CLI plugins and plugin registries.
---

Meta plugins intercept `rtk meta <command>` patterns and provide workspace-aware behavior.

Key surfaces:

- `rtk meta plugin list`
- `rtk meta plugin search <query>`
- `rtk meta plugin install <name>`
- `rtk meta git *`
- `rtk meta project *`
- `rtk meta rust *`
- `meta-plugins/plugins/*`
- `meta_plugin_api` and `meta_plugin_protocol`

Read `.claude/skills/meta-plugins.md` and `claude-plugin/skills/meta-plugins/SKILL.md` before making plugin changes.
