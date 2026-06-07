---
name: meta-codex-rust-env
description: Use to verify or explain the seven-layer Codex Rust environment for the FlexNetOS meta workspace.
---

The seven layers are:

1. Claude source surface in `.claude/` and `claude-plugin/`.
2. Codex runtime config and lifecycle hooks in `.codex/`.
3. Repo-scoped Codex skills in `.agents/skills/`.
4. Repo-scoped Codex plugin marketplace in `.agents/plugins/`.
5. Meta CLI and Rust plugin command surface in `meta_*` repos and `meta-plugins/`.
6. Slash-command, hook, plugin, and tool hub registries.
7. Rust validation and hook tools in `agent codex`.

Run `agent codex inventory` or `agent --json codex inventory` to verify the current state. Do not remove or change `.claude/` while maintaining this layer.
