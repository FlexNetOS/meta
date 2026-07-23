---
id: 019f2173-4a01-7c41-a788-61a643cc2528
slug: tasks/meta-docs-plugin-discovery-location-drift
title: "Fix stale plugin discovery locations in docs"
type: task
status: completed
priority: high
tags: [docs, plugins]
---

# Summary

Multiple root docs still document legacy `.meta-plugins` discovery paths that no longer match the current built-in plugin install layout.

# Source Evidence

- `docs/advanced_usage.md` lists `.meta-plugins/` and `~/.meta-plugins/`.
- `docs/plugin_development.md` lists `.meta-plugins/`, parent `.meta-plugins/`, `~/.meta-plugins/`, and manual copy commands using `~/.meta-plugins/`.
- `docs/architecture_overview.md` lists `.meta-plugins/` and `~/.meta-plugins/`.
- `docs/faq_troubleshooting.md` lists `.meta-plugins/`, `~/.meta-plugins/`, and copy/chmod examples under `~/.meta-plugins/`.
- Current Makefile install flows use `.meta/plugins/` and `~/.meta/plugins/`.

# Acceptance Criteria

- Update all root docs to the current plugin discovery/install locations.
- Preserve any legacy compatibility note only if the implementation still supports it.
- Add a docs grep/check that fails on unintended `.meta-plugins` references.
