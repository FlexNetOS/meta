---
id: 019ec459-f551-7943-a37b-9746d3632575
slug: tasks/github-org-lean-relocation
title: "Relocate .github_org submodules to hubs-by-type (ADR-0002); do NOT clone absent repos"
type: task
status: backlog
priority: high
tags: [github_org, hubs, submodules, relocation, adr-0002, cleanup]
---

## Overview

Make `FlexNetOS/.github` (`.github_org`) a **lean org `.github` repo** by relocating its
submodules / repo-mounts to **dedicated hubs by type**, per **ADR-0002**. The authoritative
design + staged plan + full inventory already live in `.github_org/architecture/`:

- Decision: `.github_org/architecture/adr/ADR-0002-lean-github-org-relocate-to-hubs.md`
- Plan: `.github_org/architecture/plan/2026-06-13-github-org-strip-and-relocate-plan.md`
- Reconciliation ledger: `.github_org/architecture/QUESTIONS_LESSONS.md`

## Hard constraints (owner, 2026-06-13)

1. **Do NOT clone repos that are not already on disk.** If a repo isn't located here it does NOT
   get cloned to relocate it — relocate by **reference only** (submodule entry: url + branch +
   pinned SHA where one exists), parked uninitialized.
2. **Nothing from `.github_org` lands on meta root** (no new `.meta.yaml` peers). Items go INTO a
   hub's `repos/` **staging** subdir as submodules "for now" (not yet in the hub catalog).
3. **`data/brain-data/*` STAYS in `.github_org`** — the Karpathy LLM-wiki / brain layer (5 gitlinks:
   DeepTutor, deepwiki-rs, obsidian-mind, my-wiki-knowledge/.claude/{obsidian-second-brain,obsidian-skills}).
4. **Never-downgrade:** relocate-IN (preserve pinned SHA) and verify BEFORE stripping from
   `.github_org`. Active/canonical repos are Rust-native; uncertain non-Rust ones are the staged ones.
5. **RUVECTOR = CRATES ONLY** (CRITICAL, non-negotiable, owner stated 3× + destruction warning
   2026-06-14): "We want ruvector's crates and that is it … everything else is a distraction and
   misdirect. You simply add the crates to the yaml." → `ruvector` is **NOT** staged as a whole-repo
   submodule (8.8 GB; do not pull the repo). Reference **only its crates** into the yaml. Using
   anything in ruvector outside the crates is forbidden. (Confirm WHICH yaml + crate granularity with
   owner before executing this entry.)

## Already DONE (this session — reference-only, no clones)

`tools/*` (7 pins: cpython, actionlint, gitleaks, trivy, node, bun, uv) relocated to
`tool_hub/repos/` as uninitialized submodules (url+SHA preserved). Stripped from `.github_org`
(`.gitmodules` removed, `tools/MANIFEST.yaml` trimmed to `planned`). `make verify` GREEN.
Commits: tool_hub `9cfc431`; .github_org `7dcf2fb`, `91a41c1` (ADR/plan), `ee099ef` (inventory).

## Goals (remaining) — relocate by REFERENCE, park as staging submodules in the matching hub's `repos/`

29 `repos/MANIFEST.yaml` entries (NOT on disk → reference-only) classified by `groups:`:

- vault/secrets → `vault_hub`: vaultwarden, bitwarden-clients
- vector-db/memory → `database_hub`: ruvector, chroma, mempalace
- automation/workflow → `flow_hub`: n8n
- network/dev-tools/scrape → `network_hub`: slim, firecrawl, piclaw
- tools/runtime/code-intel/llm-tool → `tool_hub`: rtk, gitnexus, cpython(external), llama.cpp, nanochat
- agents/skills/ui plugins → `plugin_hub`: understand-anything, aionui, archon*, everything-claude-code* (=ecc, already registered), oh-my-claudecode*, oh-my-pi*, agency-agents, andrej-karpathy-skills, autoresearch-2.0, autoresearch-agents
- reference/wiki/starter → `template_hub`: llm_wiki, second-brain-starter
- distro/OS (NEEDS OWNER CALL — no os_hub): ruOS, ubuntu-lifeos, weftos
- `*` = `NEW — fork required`; per constraint #1 do NOT fork/clone now — stage the reference, leave the fork as USER.TODO#5.

Movable orphan gitlinks in `.github_org` index (SHAs preserved in the plan):

- `network/slim` (`c4ffbea1`, `FlexNetOS/slim`) → `network_hub`
- `repos/n8n` (`25a836df`, MANIFEST `FlexNetOS/n8n`) → `flow_hub`
- `repos/paperclip` (`be034716`, exists as `drdave-flexnetos/paperclip`) → classify
- `repos/ai-top-utility` (`1d19b98e`, exists as `drdave-flexnetos/ai-top-utility`) → classify
- `repos/fabro` (`3634048a`, **does not exist on GitHub** — no url) → record path+SHA only; owner to identify

## Acceptance Criteria

- [ ] Each remaining MANIFEST repo + movable orphan parked as a **reference-only** staging submodule
      in the correct hub's `repos/` (url+branch+SHA where known; uninitialized; NO clones performed).
- [ ] `data/brain-data/*` untouched in `.github_org`.
- [ ] Relocated entries removed from `.github_org/repos/MANIFEST.yaml` + their orphan gitlinks; `make verify` green.
- [ ] Distro repos (ruOS/ubuntu-lifeos/weftos) + `fabro` resolved with owner input (hub + fabro upstream).
- [ ] `.github_org` `VISION.md` / `CLAUDE.md` updated to the lean org-`.github` role.

## Context

`git -C .github_org ls-files -s | awk '$1==160000'` lists the live gitlinks; `repos/MANIFEST.yaml`
is the authoritative 29-entry inventory (drifted from the index — see the plan's inventory table).
Hub Standard: once classified out of staging, register in the hub's `registry.json` + `entries/`.

## Progress — 2026-06-14 (OFFLOAD done; source is now pending_relocate)

Per owner ("offload everything to /home/drdave/Desktop/pending_relocate"), `.github_org` was
**cleaned now** and the relocation SOURCE moved to the holding pen — hub classification happens
later, FROM there. **The remaining work below now reads FROM `~/Desktop/pending_relocate`, not
`.github_org`.**

- `~/Desktop/pending_relocate/` (git-init'd, commit `01979fc`): `MANIFEST.from-github_org.yaml`
  (28 entries — full url/branch/groups), `orphan-gitlinks.md` (5 SHAs), `README.md`.
- `.github_org` stripped (commit `35c8c76`): 5 orphan gitlinks removed; `repos/MANIFEST.yaml`,
  `network/MANIFEST.yaml`, `repos/README.md` → offload stubs; `make verify` green.
- **`ruvector` STRICT-DELETED** (not offloaded) — lives at `meta/ruvector`, untouched.
- **`ruOS`** parked in pending_relocate (owner: fits `envctl` but would overcrowd it → needs its own hub later).
- `data/brain-data/*` KEPT in `.github_org`; `tools/*` already in `tool_hub/repos/`.

Remaining (later, from pending_relocate): classify each parked entry → hub, stage by reference
(no clones), resolve `fabro` (no upstream) + `paperclip`/`ai-top-utility` (`drdave-flexnetos/` org)
+ distro hub for `ruOS`/`ubuntu-lifeos`/`weftos` + the `ruvector` crates-into-yaml mechanism.
