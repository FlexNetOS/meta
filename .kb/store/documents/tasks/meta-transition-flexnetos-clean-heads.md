---
id: 019f21aa-c23d-7020-9be5-0d738ee05b59
slug: tasks/meta-transition-flexnetos-clean-heads
title: "Transition meta repos from gitkb to FlexNetOS clean heads"
type: task
status: completed
priority: high
---

# Summary
Transitioned the meta root and 14 peer repos from gitkb remotes to FlexNetOS org remotes using the clean local/gitkb heads as authoritative. Drifted FlexNetOS branch state was not preserved.

# Completion Evidence
- Force-reset FlexNetOS main for root meta and all 14 peers to the clean local heads.
- Removed extra FlexNetOS branches so each target repo has exactly one branch: main.
- Set every FlexNetOS target default branch to main.
- Set local origin remotes to git@github.com:FlexNetOS/<repo>.git for root and all 14 peers.
- Added local upstream remotes pointing back to git@github.com:gitkb/<repo>.git for root and all 14 peers.
- Updated .meta.yaml so every project repo points at git@github.com:FlexNetOS/<repo>.git.
- Committed and pushed root transition commit 13065c89f247af49e40a48cd89e46d777c2f4f86 to FlexNetOS/meta main.
- Verified FlexNetOS/main equals local HEAD for root and all 14 peers. Root intentionally differs from gitkb/main by the .meta.yaml transition commit.
- Verified all FlexNetOS targets have exactly one branch, main.
- Verified all FlexNetOS targets report default branch main.
- Verified ./target/debug/meta project list --json shows FlexNetOS SSH repos.
- Verified ./target/debug/meta --dry-run git setup-ssh lists FlexNetOS SSH targets.

# Acceptance Criteria
- [x] FlexNetOS repos have main aligned to the local clean head for root and all 14 peers.
- [x] Local origin remotes point to FlexNetOS.
- [x] Local upstream remotes point to gitkb.
- [x] .meta.yaml project repos point to FlexNetOS SSH URLs.
- [x] setup-ssh dry-run lists FlexNetOS targets.
- [x] GitKB task is completed with verification evidence.
