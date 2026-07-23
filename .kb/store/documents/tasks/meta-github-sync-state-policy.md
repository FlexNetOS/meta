---
id: 019f23ed-5b99-7b91-a3b3-9ed1fcf24f22
slug: tasks/meta-github-sync-state-policy
title: "Enforce GitHub sync state policy"
type: task
status: completed
priority: high
---

# Summary

Enforce the FlexNetOS rule that GitHub-tracked repos must not be left ahead of
or behind their tracked origin branch. Every repo/branch/remotes sync operation
must end with a clean, in-sync proof or an explicit blocker.

# Acceptance Criteria

- [x] Push current ahead branches in the meta workspace to their tracked GitHub origins.
- [x] Verify root and all meta peer repos report clean working trees and no ahead/behind drift on their current branch.
- [x] Document the no-ahead/no-behind policy in agent-facing workflow docs.
- [x] Document the same invariant in `.kb/AGENTS.md` so future GitKB-driven agents inherit it.
- [x] Commit the policy/doc changes and push them so GitHub is not left behind.

# Evidence

- 2026-07-02 initial audit: `meta git status --short --sequential` reported root `codex/clean-gitkb-state` ahead 8 and `meta_cli` `codex/preserve-meta-peer-state-20260702` ahead 3; root `git branch -vv` also showed local `main` ahead 1.
- 2026-07-02 sync repair: pushed `origin/codex/clean-gitkb-state`, `origin/main`, and `meta_cli` `origin/codex/preserve-meta-peer-state-20260702`.
- 2026-07-02 post-push proof: `meta git status --short --sequential` reports all 15 repos clean and up to date with their tracked origin branch.
- 2026-07-02 policy docs: `.kb/AGENTS.md` now requires fetch, push clean ahead branches, avoid leaving behind branches, verify root/peer status, and record blockers in the active KB task.
- 2026-07-02 workflow docs: `docs/agent_workflows.md` now defines the GitHub sync-state invariant and the fetch/inspect/repair/verify/record sequence.
- 2026-07-02 git commit proof: `68c5c1e` (`Document GitHub sync state policy`) records the policy in `.kb/AGENTS.md` and `docs/agent_workflows.md`.

# Completion Evidence

Close after `git-kb verify --json` passes, the KB workspace is clean, root and
peer git status report no ahead/behind drift, and commit `68c5c1e` is pushed to
`origin/codex/clean-gitkb-state`.
