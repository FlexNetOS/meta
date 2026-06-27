---
id: kb-marketplace-rename-2026-06-12
slug: tasks/marketplace-rename-gitkb-to-flexnetos
title: "Rename Claude Code marketplace from gitkb → flexnetos (cosmetic)"
type: task
status: backlog
priority: low
tags: [marketplace, branding, claude-plugins]
resolves: context/overridable/handoff-loop
---

## Overview

The `FlexNetOS/claude-plugins` repo publishes a Claude Code plugin marketplace currently named `gitkb`. 
This is the last cosmetic artifact from the gitkb org. All operational references (clone URLs, CI dispatch, 
registry paths) have been re-pointed to FlexNetOS — only this product name remains as `gitkb`.

## Current State

- **Repository:** `FlexNetOS/claude-plugins` (org renamed, not marketplace name)
- **Marketplace name:** `gitkb` in `.claude-plugin/marketplace.json` (`"name": "gitkb"`)
- **Install command:** `claude plugin install meta@gitkb` — still works correctly
- **PR#2 merged:** The org re-point (FlexNetOS/claude-plugins PR#2) was completed but deliberately 
  left the marketplace name unchanged to avoid breaking existing install commands

## Decision Required

**Should the marketplace name `gitkb` be renamed to `flexnetos`?**

This is a pure cosmetic branding alignment. There are two options:

### Option A: Keep `gitkb` (current state)
- **Pros:** No breakage risk; existing install commands keep working; brand has been live for weeks
- **Cons:** Visually inconsistent — org is FlexNetOS, marketplace is still called gitkb

### Option B: Rename to `flexnetos`
- **Requires atomic rename of:**
  - `.claude-plugin/marketplace.json` → `"name": "flexnetos"`
  - All install commands (`claude plugin install meta@flexnetos`)
  - README documentation
  - CI workflows that reference the marketplace name
- **Risk:** Any partial rename breaks `claude plugin install`; must land atomically
- **Benefit:** Complete brand alignment

## Acceptance Criteria (if Option B)

- [ ] `.claude-plugin/marketplace.json` name field updated to `flexnetos`
- [ ] README.md updated with new marketplace name and install commands
- [ ] All CI workflows referencing the marketplace name updated
- [ ] No remaining references to `gitkb` as marketplace name in the repo
- [ ] Verify `claude plugin install meta@flexnetos` works post-rename

## Notes

- This task is low priority — it's cosmetic branding, not functional
- The original decision doc ([[rename-claude-code-plugin-marketplace-gitkb-flexne]]) correctly identified 
  this as a coordinated change that must land atomically
- No rush to implement; can be done whenever the owner decides the trade-off is worth the risk

Co-authored-by: Claude <claude@anthropic.com>
