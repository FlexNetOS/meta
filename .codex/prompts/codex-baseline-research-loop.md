# Codex Baseline Research Loop

Use this prompt when upgrading the FlexNetOS Codex baseline from current Codex docs and ecosystem patterns.

Research targets:
- https://developers.openai.com/codex/github-action
- https://developers.openai.com/codex/permissions
- https://developers.openai.com/codex/subagents
- https://github.com/RoggeOhta/awesome-codex-cli
- https://github.com/Yeachan-Heo/oh-my-codex

Loop:
1. Verify current local state: `rtk meta project list --json`, `rtk meta git status`, `codex --version`, `codex features list`, `codex plugin list`, `codex mcp list`, and `envctl --json auto-detect`.
2. Read official Codex docs first; treat community repos as idea sources, not authority.
3. Cross-reference each idea against meta invariants: independent child repos, strict upgrade only, no rollback of dirty upgrade state, and immediate commit/push/PR for completed chunks.
4. Classify each candidate as: implement now, defer behind prerequisite, reject as unsafe/noisy, or document only.
5. For implemented upgrades, update envctl-owned global config generation, project `.codex/` surfaces, plugin skills/hooks/MCP wiring, and CI automation as appropriate.
6. Validate with JSON/TOML parsers, Codex CLI list commands, envctl detect/lock checks, and targeted GitHub workflow syntax checks where available.
7. Store ICM progress after significant completion.

Output:
- Source matrix with citations.
- Decision matrix for each candidate.
- Files changed and why.
- Validation commands and results.
