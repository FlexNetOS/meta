---
id: 019e8e68-835f-77f2-82ee-93a0a55fd011
slug: tasks/github-meta-refactor
title: "Refactor FlexNetOS/.github umbrella into meta workspace"
type: task
status: active
priority: high
tags: [refactor, meta, github, infrastructure, architecture]
---

# Overview

`FlexNetOS/.github` is a **mega-umbrella** repo that bundles six distinct roles in
one git repository and manages ~30 dependent repos via **git submodules +
`repos/MANIFEST.yaml`**. The workspace has since **adopted the `meta` framework**,
whose entire purpose is to *replace* git submodules ("Meta treats repos as peers,
not hierarchy" — meta README). The umbrella's submodule-based design is therefore
in direct conflict with the framework now in use.

This task refactors the umbrella to fit the meta model: dissolve the submodule
machinery into `.meta.yaml` projects (peers), decompose the bundled operational
concerns into their own repos (also peers), and keep `.github` slim — only the two
roles that genuinely require the magic `.github` repo name.

**Terminology note (user correction):** in meta these are **peers / projects**, not
"child repos." The root `meta` repo and every project are peers; `.github` provides
org-default community-health + reusable CI that all peers inherit.

# Source inventory (FlexNetOS/.github @ main)

Six roles (per its own `VISION.md`):
1. **Org community-health fallback** — root + `.github/` (CODE_OF_CONDUCT, CONTRIBUTING, SECURITY, SUPPORT, FUNDING, issue/PR templates, profile/README). *Requires the `.github` repo name.*
2. **Submodule mount point** — `repos/MANIFEST.yaml` + `scripts/submodule-*.sh`, ~30 repos. *Conflicts with meta.*
3. **Karpathy LLM-wiki** — `wiki/` (12 files) cross-project memory.
4. **`pass`+GPG secrets vault** — `secrets/` (60K, 15 files) + `scripts/secrets-*.sh`.
5. **Self-hosted runner host config** — `runner/` (52K, 11 files) + systemd units + policies.
6. **Reusable CI templates** — `.github/workflows/reusable-*.yml` (8 workflows). *Best served from the `.github` repo name.*

Other payload bundled in: `data/brain-data` (**76M** research dossiers), `github-app/`,
AI tooling `.claude/` (45), `.codex/` (6), `.omc/` (97), `.agents/` (2), `architecture/`
(13), `docs/` (12), `network/` (8), 7 vendored tool submodules (cpython, actionlint,
gitleaks, trivy, node, bun, uv).

## Submodule manifest → meta projects (decision: migrate ALL, drop `.gitmodules`)

| Group | Repos |
| --- | --- |
| **owned** (4) | ruOS, understand-anything, ubuntu-lifeos, llama.cpp* |
| **forked** (8) | aionui, n8n, nanochat, rtk, archon†, everything-claude-code†, oh-my-claudecode†, oh-my-pi† |
| **external** (14) | vaultwarden, bitwarden-clients, chroma, cpython, firecrawl, llm_wiki, mempalace, gitnexus, agency-agents, andrej-karpathy-skills, autoresearch-2.0, autoresearch-agents, piclaw, second-brain-starter |
| **network** (1) | slim* |
| **tool submodules** (7) | cpython‡, actionlint, gitleaks, trivy, node, bun, uv |

\* fork that carries patches/tracks upstream  † marked "NEW — fork required" (FlexNetOS fork does not exist yet → **USER action**)  ‡ cpython is duplicated (manifest external + tool submodule)

**DISCARDED (do not migrate):** `ruvector` (owned) and `weftos` (forked) — user will pull
fresh clones and set them up correctly in a separate effort. Excluded from `.meta.yaml`.

# Goals

- Eliminate git submodules; every dependent repo becomes a `.meta.yaml` project (peer).
- Keep `.github` slim: roles **1 (community health)** + **6 (reusable CI)** only.
- Extract roles 3/4/5 + heavy payload into their own FlexNetOS repos, each a meta peer.
- Wire reusable CI into the meta workspace so root + crate peers inherit it.
- Preserve history/traceability; nothing silently dropped.
- Adopt the framework **as-is** for now; defer cosmetic renames to a follow-up.

# Target structure

```
.meta.yaml projects (peers) — added incrementally:

  # --- org defaults (slim .github; roles 1 + 6) ---
  github_org:          repo .github            path .github_org   tags [org, ci]

  # --- extracted operational concerns (NEW repos, flexnetos_* naming) ---
  flexnetos_secrets:   role 4   tags [ops, secrets]
  flexnetos_runner:    role 5   tags [ops, runner]
  flexnetos_wiki:      role 3   tags [docs, memory]
  flexnetos_brain:     data/brain-data (76M)   tags [docs, research]
  flexnetos_github_app: github-app/            tags [ops, github-app]

  # --- AI tooling: each gets its OWN dedicated peer repo (user decision) so it
  #     can carry its own tool-specific CI/integration ---
  flexnetos_claude_config:  .claude/      tags [ai, claude-code]
  flexnetos_codex_config:   .codex/       tags [ai, codex]
  flexnetos_agents_config:  .agents/      tags [ai, agents]
  flexnetos_omc:            .omc/ (or fold into forked oh-my-claudecode peer; caches dropped)  tags [ai]
  # architecture/ -> docs (own repo or into flexnetos_wiki) — confirm in Phase 2

  # --- migrated submodule manifest (tags mirror manifest groups) ---
  # NOTE: ruvector + weftos DISCARDED — user sets up fresh later, not migrated.
  ruOS, understand-anything, ubuntu-lifeos, llama_cpp             tags [owned]
  aionui, n8n, nanochat, rtk, archon, everything-claude-code,
    oh-my-claudecode, oh-my-pi                                    tags [forked]
  vaultwarden, bitwarden-clients, chroma, cpython, firecrawl,
    llm_wiki, mempalace, gitnexus, agency-agents,
    andrej-karpathy-skills, autoresearch-2.0, autoresearch-agents,
    piclaw, second-brain-starter                                  tags [external]
  slim                                                            tags [network]
  actionlint, gitleaks, trivy, node, bun, uv                      tags [tool]
```

Root `meta` repo's own `.github/workflows/*` get refactored to **call** the slim
`.github` reusable workflows (`uses: FlexNetOS/.github/.github/workflows/reusable-*.yml@v1`)
— this is the "merged into root .github" half of the placement decision.

# Phased plan

### Phase 0 — Land & track (this session) ✅ COMPLETE
- [x] Clone & inventory FlexNetOS/.github
- [x] Confirm decisions with user (hybrid split / migrate-all / KB-tracked / peers-not-children)
- [x] Create this task doc
- [x] Snapshot workspace: `meta git snapshot create pre-github-refactor` (15 repos captured)
- [x] Add `github_org` peer: cloned `.github` → `.github_org/` (93M, top-level only), `.meta.yaml` + `.gitignore` updated, `.meta-snapshots/` gitignored. Verified: `meta project list` shows `github_org (.github_org) [org, ci]`, dir ignored, root status clean.

### Phase 1 — Author slim spec (roles 1 + 6) ✅ COMPLETE (map only)
- [x] Branch `refactor/slim-to-meta` in `.github_org/` (`main` left fully intact)
- [x] Author authoritative `MIGRATION.md` (commit `4fefb0e`) — path-granular keep/move/migrate/drop map
- [x] Surface `.gitmodules`/MANIFEST drift (see finding below)
- **Revised approach:** removals are NOT done here. `secrets/store` holds real GPG-encrypted
  secrets + a `protect-secrets-store.sh` hook; deleting concerns before their destination repo
  exists is unsafe. So Phase 2 does **extract-then-remove atomically** per concern. Phase 1's
  deliverable is the reviewable slim spec, not a slimmed tree.

#### 🔑 Finding: `.gitmodules`/MANIFEST drift
Actual committed submodules ≠ MANIFEST.yaml (~28 aspirational). Real gitlinks:
`tools/` (7: actionlint,bun,cpython,gitleaks,node,trivy,uv) · `repos/` (4:
ai-top-utility,fabro,n8n,paperclip) · `network/slim` (1) · `data/brain-data/` (5 nested).
`data/brain-data/DeepTutor` has no `.gitmodules` mapping. → **Phase 3 needs a decision:
migrate aspirational manifest (~28) or actually-present submodules (17)?**

### Phase 2 — Extract operational concerns into new repos (**USER must create empty GitHub repos**)
- [ ] `FlexNetOS/flexnetos_secrets` ← `secrets/` + `scripts/secrets-*.sh`
- [ ] `FlexNetOS/flexnetos_runner` ← `runner/` + `scripts/runner-doctor.sh`
- [ ] `FlexNetOS/flexnetos_wiki` ← `wiki/` (+ `.omc/wiki/` if consolidating) + `wiki-lint` workflow
- [ ] `FlexNetOS/flexnetos_brain` ← `data/brain-data` (76M — consider git-lfs/partial)
- [ ] `FlexNetOS/flexnetos_github_app` ← `github-app/` + `scripts/github-app-token-smoke.py`
- [ ] Decide fate of AI tooling (`.claude/.codex/.omc/.agents`): keep in `.github` as org agent-config, or its own peer, or gitignore the caches (`.omc` is largely plugin cache)
- [ ] Register each new repo as a peer in `.meta.yaml` + `.gitignore`

### Phase 3 — Dissolve submodules into meta (role 2)
- [ ] **USER:** create the 4 missing forks (archon, everything-claude-code, oh-my-claudecode, oh-my-pi)
- [ ] Translate all MANIFEST + tool-submodule entries into `.meta.yaml` projects with tags mirroring groups
- [ ] Remove `.gitmodules` + `repos/` submodule machinery from the slim `.github`
- [ ] `meta git update` to clone the new peers; verify `meta project list -r`
- [ ] Replace `submodule-bump.yml` / `manifest-drift.yml` automation with meta-native equivalents (or retire)

### Phase 4 — Wire reusable CI + finalize
- [ ] Refactor root `meta` repo `.github/workflows/{ci,release,...}.yml` to call `reusable-*.yml@v1`
- [ ] Cut a `v1` tag on the slim `.github` so peers can pin
- [ ] Update meta `CLAUDE.md` / `.kb` context docs to document the new layout
- [ ] Optional follow-up task: rename `.kb`/FlexNetOS naming (deferred per user — "adopt as-is")

# Acceptance criteria

- [ ] `.github` repo contains only roles 1 + 6; `.gitmodules` removed
- [ ] Every former submodule + extracted concern is a `.meta.yaml` project and clones via `meta git update`
- [ ] `meta project list -r` shows the full tree with correct tags
- [ ] Root + crate peers consume reusable CI via `uses: ...@v1` (no per-repo copy-paste)
- [ ] No payload silently dropped — each role has a documented new home
- [ ] All new/forked repos exist under `FlexNetOS/` (USER-created) and are reachable

# Context / key decisions

- **Peers, not children** — meta replaces submodules; this refactor is the canonical meta migration of a submodule umbrella.
- **Hybrid decomposition** — only the two roles that need the literal `.github` name stay; everything else becomes a peer.
- **Migrate ALL submodules** (incl. large vendored upstreams like cpython/node) — user choice; revisit partial-clone/git-lfs for 76M `data/` and 8.8GB ruvector if disk becomes an issue.
- **Many steps are USER actions** — creating new GitHub repos + 4 forks is outward-facing and must be done/authorized by the user before the agent can push.

# Open questions

1. ~~New repo names~~ → **RESOLVED: `flexnetos_*` prefix.**
2. ~~AI tooling~~ → **RESOLVED: each gets its OWN dedicated peer repo** (claude/codex/agents/omc) so it carries its own tool-specific CI; regenerable caches dropped. `architecture/` TBD (docs).
4. ~~Local peer dir~~ → **RESOLVED: `.github_org/`** (collision with root `.github/` avoided).
3. **STILL OPEN:** 76M `data/brain-data` — full clone, partial clone, or git-lfs? (revisit at Phase 2/3). NB: 8.8GB ruvector concern is moot — ruvector discarded.

# Secrets — OUT OF SCOPE (user-owned)

- Secrets extraction/decryption is **handled by the user** (they hold the GPG private key
  for `5B50D66FE264FD21`; not on the agent's box). Flow: kasetto holds temporarily →
  fixes env → secrets land in **envctl**. The agent does NOT touch secrets. The encrypted
  `secrets/` store remains in `.github_org` main untouched. Inventory (names only):
  `openai/personal`, `n8n/api-key`, `n8n/mcp/token`, `github/personal/cli`.

# Progress Log

### 2026-06-03
- Cloned FlexNetOS/.github to /tmp, full inventory of 6 roles + 30-repo manifest + payload.
- User decisions: hybrid split · migrate all submodules · KB-track · peers-not-children terminology.
- Authored this plan.
- Follow-up decisions: `flexnetos_*` naming · each AI tool config = own peer repo · go Phase 0.
- **Phase 0 executed:** snapshot `pre-github-refactor`; landed `.github` as peer `.github_org/`; `.meta.yaml`/`.gitignore` updated & verified. Non-destructive — fully reversible.
- **Discarded from migration:** `ruvector` + `weftos` — user will pull fresh clones and set up correctly separately; excluded from `.meta.yaml`. owned 5→4, forked 9→8.
- **Phase 0 edits committed** to root meta repo (`220be93`).
- **Phase 1 executed (map):** branch `refactor/slim-to-meta` + `MIGRATION.md` (`4fefb0e`); `main` intact. Discovered `.gitmodules`/MANIFEST drift (actual 17 submodules ≠ ~28 manifest). Removals deferred to Phase 2 (extract-then-remove) due to live secrets.
- **Strategy pivot (user):** "ground the repos first, move content later." Don't fuss over precise content placement now — register the curated repo list as meta peers so the workspace is grounded; relocate content afterward. Drop the `.omc` cache. Branch-as-content-silo idea (`.claude` branch on `claude-code`) rejected as an anti-pattern; user will create dedicated hubs (`agent_hub`, `skills_hub`, …) instead.
- **Forks created** by user under FlexNetOS: archon→Archon, everything-claude-code→**ECC**, oh-my-claudecode, oh-my-pi. `.omc`→`oh-my-claudecode`.
- **Reconnaissance:** all 21 listed repos exist. 5 are empty (await content): flexnetos_{secrets,runner,wiki,brain,github_app}. The other 16+ are populated pre-existing projects → peers only. Resolves the manifest-drift Q: stray `tools/*`, `repos/{ai-top-utility,fabro,paperclip}` are out of scope (not in the curated list).
- **Phase 2 (grounding) executed:** added 22 peers to `.meta.yaml` + `.gitignore` (commit `1a3eda8`); `meta project list` shows 37 peers. Kicked off `meta git update` to clone them (~3-5 GB).
- **Secrets → kasetto.yaml:** STILL UNRESOLVED. `kasetto.yaml` is a Claude-skills installer config, not a secrets store; secrets are GPG-encrypted w/ placeholder `.gpg-id`. Awaiting user clarification on intent. Holding.
- **Grounding verified:** `meta git update` cloned all 22 peers (exit 0). 5 `flexnetos_*` repos empty (120K, await content); 17 populated (n8n 784M, hermes-agent 337M, oh-my-pi 345M, codex 192M, …). Workspace 4.1 GB. Root repo clean.
- **+12 hub/collection peers grounded** (commit `492878b`): template_hub, assets, flow_hub, harness_hub, network_hub, my-wiki, tool_hub, database_hub, mcp_hub, plugin_hub, hooks_hub, commands. Empty repos, content TBD. Workspace now **49 peers**.
- **Secrets dropped from agent scope** — user owns it (has the keys). Agent will not touch secrets.
- **Current resting state:** workspace grounded (37 peers, all cloned). Structural migration done.
  Remaining content relocation (runner/wiki/brain/github_app out of `.github_org`; `.claude`/`.codex`/`.agents`
  into hubs once user creates `agent_hub`/`skills_hub`) is on hold until the user asks — not blocking.
