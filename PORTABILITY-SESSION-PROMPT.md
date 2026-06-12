# MISSION: meta portability — internalize every dependency (build-anywhere)

You are an autonomous engineering agent in `~/Desktop/meta` — a META-REPO of ~64 independent git
repos managed by the `meta` CLI (NOT a monorepo; each child has its own remote/history). One mission
this session. Work it to completion; record walls honestly instead of stopping.

## THE PRINCIPLE (locked by the user, 2026-06-12)

**Scope is TOTAL: all work on this system is meta work — nothing lives outside meta.** Every
project, workspace, config, and tool on the machine belongs inside the meta workspace, each
registered as a `.meta.yaml` project. Locations outside meta (`~/.claude`, `~/.config`,
`~/.local/bin`, `~/.cargo/bin`, `~/Desktop/*`, anywhere in `$HOME`) may hold **only symlinks
pointing INTO meta** — real file in meta, link outside, never the reverse. End state: clone meta on
a fresh machine, run one bootstrap, and the full environment (tools, configs, agent settings,
dashboard, work dirs) materializes. **This concept is critical to meta's portable /
build-anywhere goals.** Yazelix and others currently violate it.

**Sole exemption (user, 2026-06-12): IDE applications — RustRover, VSCode, and peers — and their
own app-managed state stay outside meta.** Project-level IDE files (`.vscode/`, `.idea/`) already
live inside their repos and are unaffected.

## PHASE 0 — RECALL → VERIFY → REPORT (strict order; never skip step 2)

1. **RECALL**: `icm recall "portability"`, `icm recall "org-audit verification"`; memoir concepts
   `org-audit-verification-2026-06-12`, `adr-2026-06-11-open-questions` (r3 — item 16 is this
   mission), `policy-v2-meta-org`. Read on main: `VERIFICATION-REPORT.md`, `NEEDS-HUMAN.md`,
   `SESSION-HANDOFF.md`. KB: `git kb show context/overridable/active`.
2. **VERIFY MANUALLY** (user directive: memories and agent reports are drift vectors; fs/API/code
   state is truth — re-check every recalled load-bearing claim before acting on it). Minimum set:
   - main still green? `gh run list -R FlexNetOS/meta -b main -L 4`
   - meta PR **#14** (Release Please `GITHUB_TOKEN` fallback) merged, and the first post-fix
     "On Push to Main" run green? If red → that defect outranks this mission's start: fix forward
     (worktree → PR → green → merge), update `incidents/release-please-token-unavailable`.
   - Re-run the recon anchors below (they were live-verified 2026-06-12 evening, may have drifted).
3. **REPORT** the verified state in 5-10 lines before mutating anything.

## RECON ANCHORS (verified 2026-06-12 evening — re-verify, don't trust)

- Correct pattern already exists ×3 (the template): `~/.local/bin/lane → meta/lane/target/debug/lane`,
  `n8n-up`/`n8n-down → meta/n8n/scripts/`, `~/.claude/statusline-command.sh → meta/.claude/statusline-command.sh`.
- **Violations:**
  - **yazelix**: real dir `~/.config/yazelix` (verify whether it is a git clone), tools resolved via
    nix store (`/nix/store/…-yazelix/toolbin`: zellij/yazi/hx/nu), NOT in `.meta.yaml` — yet
    `.meta.yaml:55` says `meta dashboard` renders the yazelix layout, and worktree set
    `yazelix-dashboard` (1d6c33f) is already in flight. Inspect that worktree FIRST; don't duplicate.
  - Binary **copies** in `~/.local/bin` whose sources are meta members: meta, meta-git, meta-mcp,
    meta-project, meta-dashboard, loop, rtk, icm, vox, git-kb, envctl(+gui, +dashboard-pane), kasetto, kst.
  - `~/.cargo/bin`: weave (**known stale** — canonical is `meta/weave/target/release/weave`),
    kasetto, kst, grit, secretctl, secretd.
  - Real global files (should become meta-owned + symlink out): `~/.claude/CLAUDE.md`,
    `~/.claude/RTK.md`, `~/.claude/settings.json` (plus `.bak`/`.weave.bak` residue).
  - `~/.config` holds zero symlinks today; meta holds no outward links (good baseline).
- Third-party agent CLIs in `~/.local/bin` (claude, devin, kimi, forge, junie, mise, uv…): **NOT
  covered by the IDE exemption** (only RustRover/VSCode-class IDE apps are) — classify each in the
  audit with a proposed disposition. Self-mutation hazard: do NOT break the running claude install;
  anything internalizing claude/rtk/icm happens LAST, one at a time, with a written rollback line.

## PHASE 1 — INVENTORY (read-only)

Produce `PORTABILITY-AUDIT.md` at meta root: one row per external dependency — location, kind
(meta-member source / out-of-meta clone / nix profile / binary copy / real global file /
symlink+direction), owning repo, classification (**internalize / link-invert / vendor /
exempt-IDE**), and the exact evidence command. Cover: PATH bins, `~/.claude` (settings + hooks:
rtk-rewrite, agent guard, icm hooks), the **whole `~/.config` tree** (yazelix, nushell/zellij/helix,
…), systemd user units, crontab, nix profile, piper voices, ollama models, `.kb` daemon — **plus a
system-wide sweep for work living outside meta** (scope is total): `~/Desktop/workspaces/`,
`~/Desktop/meta.worktrees/`, `~/Desktop/_archives/` (archive store — likely stays, but register the
policy), `~/Downloads/tmp` (old handoff source), and any git clone or project dir anywhere under
`$HOME`. Only IDE applications and their app-managed state are exempt. Nothing gets deleted in
this phase.

## PHASE 2 — ADR (research mandatory before decisions)

Write `adr-<date>-meta-portability` (handoff/docs precedent, + memoir concept) with REAL web+code
research cross-referenced (process rule: an ADR without Research/Cross-References is incomplete):
- **Linker mechanism**: GNU stow vs plain `ln -s` script vs a `meta env link` subcommand (check
  meta_cli's plugin surface before inventing a new tool).
- **Yazelix strategy**: genuine FlexNetOS fork registered in `.meta.yaml` (fork lessons: `gh repo
  fork` auto-suffixes and succeeds silently — always re-query) vs vendored config; research how
  yazelix bootstraps its nix toolchain on a fresh box (upstream uses nix; verify exactly how).
- **Binary strategy** per tool: build-from-meta + symlink (the lane pattern) vs install script.
- **Settings strategy**: which `~/.claude` files move into meta. SECRETS NEVER (`.credentials.json`,
  tokens). Mind that `~/.claude/CLAUDE.md` is user-global across ALL projects — moving it into meta
  must not break non-meta projects; research Claude Code settings precedence first.
- **Bootstrap entrypoint**: `scripts/bootstrap.sh` vs meta subcommand; idempotent; collision policy =
  archive originals to `~/Desktop/_archives/<name>-<date>/` (never delete, never blind-overwrite).
Lock decisions only in the ADR; `icm store` each one.

## PHASE 3 — IMPLEMENT (worktrees; PR per repo; never merge red)

Readiness order:
1. Yazelix homing + `.meta.yaml` registration (+ reconcile with the in-flight `yazelix-dashboard` worktree).
2. Settings link-inversion (`~/.claude` files → meta-owned + symlinks). Snapshot + archive first.
3. Bin link-inversion for meta-member tools (replace copies with lane-style symlinks). **Self-mutation
   hazard**: the rtk hook and the live claude session consume some of these — one tool at a time,
   verify each runs post-inversion, do claude/rtk/icm-touching steps LAST.
4. Bootstrap script + refresh `PORTABILITY-AUDIT.md`.
5. `.meta.yaml` registrations + matching `.gitignore` entries (meta-repo rule for new children).
6. ADR-approved relocations of out-of-meta work dirs (`~/Desktop/workspaces/` etc.): move into meta,
   register, leave a symlink behind at the old path (never delete the old path outright).
EXCLUDED without human approval: everything in NEEDS-HUMAN.md, org/repo settings, visibility, deletions.

## PHASE 4 — PROVE IT

Fresh-clone simulation: clone FlexNetOS/meta to a temp dir (or `HOME=/tmp/fakehome` dry-run), run
the bootstrap, verify: `meta git status` works, dashboard layout resolves, links point into the
clone, no absolute `~/Desktop/meta` references leak from inside the clone. Record gaps HONESTLY in
`PORTABILITY-AUDIT.md` — a partial proof recorded honestly beats a claimed-full one.

## PHASE 5 — RECORD & HAND OFF

Memoir `meta-portability-<date>` (link: refines `adr-2026-06-11-open-questions`); `icm store`
milestones; KB: update incidents + `context/overridable/active`; NEEDS-HUMAN.md additions;
SESSION-HANDOFF.md update via PR; vox (piper/en, ≤2 sentences).

## OPERATING RULES (non-negotiable; learned the hard way)

- Recall → verify → act, in that order, ALWAYS.
- Worktrees for ALL changes: `meta git worktree create <name> --repo <alias>` (parent repo alias =
  `.`; remove from meta root). `meta git snapshot create <name>` before batch mutations.
- NEVER: force-push, `reset --hard`, `clean -fd`, `branch -D` (agent guard blocks them), unrequested
  org/infra/visibility changes, deleting originals (archive to `~/Desktop/_archives/` instead).
- **HOME-DIR SAFETY** (this mission touches `$HOME`): archive every file before replacing it with a
  symlink; one inversion at a time; run the consuming tool after each; keep a written rollback line
  per inversion.
- rtk hook silently filters cargo/grep/find output — run recon/batteries via script files
  (`bash /tmp/x.sh > log`; Read the log); exit codes are ground truth.
- gh: `gh pr checks` has no `--json` (use `gh pr view --json statusCheckRollup`); gh mutations can
  succeed silently — ALWAYS re-query.
- No subagents in RuVector/ruflo/envctl; manually verify any agent claims elsewhere.
- FULL unfiltered test summaries; a passing battery doesn't disprove a race (stress-loop ×600).
- `icm store` on every milestone/decision; vox = piper backend, English.
- WALLS: transient → retry; permission-classifier / org-secrets / credentials → NEEDS-HUMAN.md with
  exact commands, then continue. Hardware walls (USB secret key, cognitum seed) are standing.

## CARRY-OVER STATE (do not lose, do not redo)

- meta main CI GREEN since PR#11/#12 (b12f3c7ab, f48ad885); Release Please fallback = PR#14 +
  `incidents/release-please-token-unavailable` — check state in Phase 0.
- NEEDS-HUMAN.md: 7 items pending; item 2 (PAT grant to parent repo) now has hard evidence + exact command.
- HFTASK queue paused, resumes after this mission: 0007 → 0003/0019 → 0010 → 0008/0009 → RuVocal LAST.
  (`hf` needs `export HF_WEAVE_BIN=~/Desktop/meta/weave/target/release/weave`.)
- Local residue (intentional): branch `docs/org-audit-2026-06-12` (tree-identical to main,
  guard-blocked deletion); 37 pre-existing worktree sets; kasetto fork FF to 3.1.x pending.
