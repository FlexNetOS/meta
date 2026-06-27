---
id: 019e9ea4-4ae1-7753-9ddd-5add1e705149
slug: rename-claude-code-plugin-marketplace-gitkb-flexne
title: "Rename Claude Code plugin marketplace gitkb -> flexnetos"
type: task
status: draft
priority: medium
tags: [marketplace, gitkb, flexnetos, claude-plugins, rename, follow-up]
---

# Overview

Follow-up split off from the gitkb→FlexNetOS org-rename fix (see
[[meta-as-source-of-truth-meta-generated-ci-dashboar]] Phase B). During that fix
we re-pointed every dead **org** reference (CI dispatch, clone URLs,
`DEFAULT_REGISTRY`, `meta init` URLs, `Cargo.toml` metadata) but deliberately
**left the marketplace NAME `gitkb` alone**, because it is a product identifier,
not an org reference, and renaming it is a coordinated change that must land
atomically or it breaks `claude plugin install`.

# Why this is separate from the org fix

The Claude Code plugin marketplace is named `gitkb` in
`claude-plugins/.claude-plugin/marketplace.json` (`"name": "gitkb"`). Therefore
`claude plugin install meta@gitkb` and `gitkb@gitkb` are **correct today** — the
`@gitkb` is the marketplace name, independent of which GitHub org hosts the repo.
`meta init` adds the marketplace from `FlexNetOS/claude-plugins` (org, fixed) but
it still registers under the manifest name `gitkb` (product, unchanged). Renaming
the org without renaming the marketplace is fine and consistent; renaming the
marketplace is an optional cosmetic/branding alignment.

# Goals

- Decide whether to rename the marketplace `gitkb` -> `flexnetos` (branding
  alignment with the FlexNetOS org) — or keep `gitkb` as the marketplace name.
- If renaming: update ALL touch points atomically so install commands keep working.

# Acceptance criteria (if the decision is to rename)

- [ ] `claude-plugins/.claude-plugin/marketplace.json` `"name": "gitkb"` ->
      `"flexnetos"` (and any per-plugin `name` that encodes the marketplace)
- [ ] `meta_cli/src/init.rs` printed instruction `meta@gitkb` -> `meta@flexnetos`
      (currently intentionally `meta@gitkb`)
- [ ] `claude-plugins/README.md` — `meta@gitkb`, `gitkb@gitkb`, marketplace-name
      mentions updated (org URLs already fixed)
- [ ] `plugin_hub/entries/claude-plugins.md` — "Marketplace name | gitkb",
      `meta@gitkb`, `gitkb@gitkb`, title "(gitkb marketplace)" updated
- [ ] The `gitkb` PLUGIN itself (the GitKB KB/code-intelligence plugin, repo
      `gitkb-claude-plugin`) — decide if the plugin keeps the name `gitkb` or is
      also rebranded; `gitkb@gitkb` install command depends on this
- [ ] Migration note for existing users: they must
      `claude plugin marketplace remove gitkb` then re-add, or the old name lingers
- [ ] Verify `meta init` end-to-end registers + installs under the new name

# Context / decisions

- **Open product decision:** is the marketplace/brand `gitkb` being retired in
  favor of `flexnetos`, or kept? The org moved but the product name may be
  intentionally retained. RESOLVE THIS FIRST — it's a branding call, not a bug.
- The `gitkb-claude-plugin` repo (GitKB knowledge-base plugin) is a NON-migrated
  gitkb repo; its fate is part of the broader gitkb-org migration research
  (running 2026-06-06). Coordinate with that.
- Left untouched by the org fix (intentionally): `claude-plugins/README.md`,
  `plugin_hub/entries/claude-plugins.md`, the marketplace.json name.

# Progress Log

### 2026-06-06
- Created as a follow-up to the gitkb->FlexNetOS org fix (Phase B of the spec).
  Org refs fixed; marketplace name preserved pending this rename decision.
