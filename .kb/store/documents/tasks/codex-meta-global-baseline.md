---
id: 019f08e1-c17d-70c0-b6f8-4a70632f9e5f
slug: tasks/codex-meta-global-baseline
title: "Build Codex meta global baseline"
type: task
status: draft
priority: medium
---

## Overview\nBuild Codex into a first-class meta agent surface: global Codex settings owned by meta/envctl, a Codex-native meta plugin, complete baseline tools/configs/features, and verification across the meta workspace.\n\n## Goals\n- Create a Codex meta plugin for the meta workspace.\n- Register/install/enable the plugin from a meta-owned marketplace.\n- Make Codex global settings/configs envctl-owned and verifiable.\n- Ensure all intended Codex features, MCPs, plugins, hooks, and variables are activated/set.\n- Verify every meta repo has the required baseline trust/config coverage.\n\n## Acceptance Criteria\n- [ ] Codex meta plugin exists with valid .codex-plugin manifest and useful skills/hooks/MCP wiring.\n- [ ] Codex plugin marketplace is meta-owned and registered in Codex config.\n- [ ] Codex global config includes required features, MCPs, marketplaces, plugins, and trust entries generated from meta state.\n- [ ] envctl can detect/verify/fix the Codex global baseline.\n- [ ] Verification proves no old Bun Codex path is used.\n- [ ] Relevant commits are pushed and PRs opened.\n