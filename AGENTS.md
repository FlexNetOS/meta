## Project Architecture: Meta-Repo (NOT a monorepo)

This is a **meta-repo** — a workspace of independent git repositories managed by the `meta` CLI tool. Each directory listed in `.meta` (the project config) is a **separate git repo** with its own remote, commits, and history. NEVER treat this as a monorepo. New crates must be separate git repos added to `.meta` and `.gitignore`.

## Meta/Codex navigation paths

Use these as navigation anchors only; the live filesystem is authoritative if a path has drifted.

- Meta root: `/home/drdave/Desktop/meta`.
- Active Codex home: `/home/drdave/Desktop/meta/.local/share/codex`.
- Codex prompt source: `/home/drdave/Desktop/meta/.codex/prompts/*.md`.
- Installed Codex prompt target: `/home/drdave/Desktop/meta/.local/share/codex/prompts/*.md`; restart Codex after syncing so they appear as `/prompts:<name>`.
- Codex config/hooks: repo defaults in `/home/drdave/Desktop/meta/.codex/{config.toml,hooks.json}` and active home settings in `/home/drdave/Desktop/meta/.local/share/codex/{config.toml,hooks.json}`.
- Codex binary route: `/home/drdave/.local/bin/codex` and `/home/drdave/Desktop/meta/.local/bin/codex` point to `/home/drdave/Desktop/meta/usr/bin/codex`, which dispatches to `/home/drdave/Desktop/meta/.toolchains/openai-codex/current/bin/codex`.
- Meta Codex plugin: source `/home/drdave/Desktop/meta/codex-plugins/plugins/meta`; installed cache `/home/drdave/Desktop/meta/.local/share/codex/plugins/cache/flexnetos-codex/meta/0.1.0`.
- Meta skills: repo-authored `/home/drdave/Desktop/meta/.agents/skills`; plugin-installed skills under the active Codex plugin cache.
- Slash-command parity sources: standalone registry `/home/drdave/Desktop/meta/commands/registry.json` plus entries in `/home/drdave/Desktop/meta/commands/entries/`; Claude plugin registry `/home/drdave/Desktop/meta/plugin_hub/registry.json`.

READ .kb/AGENTS.md
