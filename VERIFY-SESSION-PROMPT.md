# NEXT-SESSION PROMPT — Adversarial verification of the 2026-06-12 org-audit session

Copy-paste everything below the line into the next session.

---

You are Fable 5 with persistent ICM memory operating in `/home/drdave/Desktop/meta` (a meta-repo of ~63
independent git repos, NOT a monorepo). This is a **VERIFICATION mission**: the previous session (org-audit,
2026-06-12) claims six phases of delivered work. Your job is to **adversarially verify every load-bearing
claim against live state** — treat the prior session as an untrusted research agent (the standing process
rule). Code/API/ledger state is truth; its reports, memoir entries, and audit docs are claims until checked.
Where a claim fails, fix forward (worktree → PR → green checks → merge) or record it honestly. Do NOT
re-implement what verifies clean. Use `/verify` where observing real behavior applies; use direct
`gh api`/git/ledger checks everywhere else.

## PHASE 0 — Recall + ground state (report before proceeding)

1. Recall memoir concepts: `policy-v2-meta-org`, `org-audit-results-2026-06-12`,
   `org-protection-rollout-2026-06-12`, `loop-e2e-proof-2026-06-12`, `adr-2026-06-11-open-questions` (should
   be r2, refreshed 06-12). Plus `icm recall "org-audit phase"` for the session trail.
2. Read (claims inventory): `META-ORG-POLICY.md`, `META-ORG-AUDIT.md`, `NEEDS-HUMAN.md` — note these live on
   branch `docs/org-audit-2026-06-12` (commit 8da58ac); on main they may be untracked-or-absent depending on
   whether the docs PR merged. `SESSION-HANDOFF.md` on main may still be the session-2 version (the session-3
   version is on the docs branch) — that is expected, not drift.
3. Operating rules unchanged: worktrees for all changes; snapshot before batch mutations; never
   force-push/reset-hard/clean -fd; no subagents in RuVector/ruflo/envctl; no unrequested org
   infrastructure/visibility changes; vox=piper/en; `icm store` on milestones; **capture FULL unfiltered test
   summaries** (filtered/tail'd logs hid real failures twice last session); `gh pr checks` has no `--json` on
   this gh build (use `gh pr view --json statusCheckRollup`); gh fork/merge can succeed silently (always
   re-query); after `git remote rename`, branch tracking follows the renamed remote (check `--set-upstream-to`).

## PHASE 1 — FINISH THE IN-FLIGHT CHAIN FIRST (it may have stalled at session close)

The session ended with monitors armed on an unfinished chain. Establish where it stopped and complete it:

```bash
gh pr view 2  -R FlexNetOS/teri --json state,mergedAt          # teri#2 (/tmp→temp_dir fix): expect MERGED; if open+green, merge --squash --delete-branch
git -C teri pull --ff-only                                      # sync local after merge
gh pr view 11 -R FlexNetOS/meta --json state,mergedAt,statusCheckRollup   # the parent CI fix PR
gh pr list -R FlexNetOS/meta --state all --search "org-audit"  # the docs PR (may not exist yet)
```
Decision table:
- teri#2 unmerged → merge on green, then **fresh full rerun** of meta PR #11 CI
  (`gh api repos/FlexNetOS/meta/actions/runs/27429059428/rerun -X POST`; if 403 "already running", wait).
- PR #11 red → diagnose the EXACT failing job/test from logs (prior failures were, in order: meta_cli fmt;
  shimmy clippy+publish+binary-paths; shimmy vestigial MLX (macos); teri /tmp (windows) — all fixed+merged).
  A NEW failure means a NEW defect: fix in the owning fork via worktree→PR→merge, rerun #11. Never merge red.
- PR #11 green → merge it (squash). Then open the docs PR: head `docs/org-audit-2026-06-12`, base main,
  update branch if strict-checks demand, merge on green. **End state: meta main CI green** (first time since
  2026-06-04) and the docs on main.

## PHASE 2 — VERIFY THE CLAIM MATRIX (live state vs claims; spot-check, don't trust)

**A. Merged-PR cluster** (expect all MERGED with green checks at merge time):
meta_cli#1+#2, teri#1+#2, shimmy#1+#2+#3, loop_lib#1, loop_cli#1, meta_core#1, meta_plugin_protocol#1,
meta_git_lib#1, meta_git_cli#1, meta_project_cli#1, meta_rust_cli#1, meta_mcp#1, meta-plugins#1, vox#1,
handoff#2+#3. Sample-verify ~6 via `gh pr view N -R FlexNetOS/<repo> --json state,mergedAt,mergeCommit`
and confirm the conventions files actually exist on main
(`gh api repos/FlexNetOS/loop_lib/contents/.github/workflows/semantic-pr-title.yml --jq .path`, same for
`renovate.json` on the 5 canon gaps: loop_lib, loop_cli, meta_core, meta_plugin_protocol, meta_git_lib).

**B. Fork homing** (the redirect lesson — verify GENUINE org ownership, not redirects):
```bash
gh api repos/FlexNetOS/ruflo --jq '{owner: .owner.login, fork, parent: .parent.full_name}'   # Organization, true, ruvnet/ruflo
git -C ruflo remote -v          # origin=FlexNetOS/ruflo, upstream=ruvnet; local main INTENTIONALLY behind (pin)
git -C ruflo ls-remote origin pin-meta-2026-06-12   # pin branch exists at dfe1b9cf9
gh api repos/FlexNetOS/env_manager_agent --jq '.parent.full_name'   # pivoshenko/kasetto
ls kasetto vox rusty-idd        # all three cloned/moved under meta; check .meta.yaml entries (docs branch)
gh api repos/FlexNetOS/vox --jq '{fork, parent: .parent.full_name}'; git -C vox log --oneline -1  # e0be5c4 english-defaults on main
```

**C. Stray sweep** (nothing deleted, only archived):
`~/Desktop/weave`, `~/Desktop/weave-review`, `~/Desktop/workspaces/kasetto-main` GONE from original spots;
present under `~/Desktop/_archives/` (weave-desktop-pruned-2026-06-12, weave-review-pruned-2026-06-12,
kasetto-main-3.0.0-archive-extract). `~/.git` gone. `~/Desktop/idd-merge-idd` → now `meta/rusty-idd`.
Adversarial check: confirm the prune claim "zero local-exclusive commits" still holds — the personal remote
drdave-flexnetos/weave must still carry the 6 P2–P7 feature-branch SHAs (`git -C _archives/weave-desktop-pruned-2026-06-12 ls-remote origin | grep -c feat/` or via gh api).

**D. Protection rollout** (24 repos; sample ≥6 + the special ones):
```bash
for r in meta:main loop_lib:main prompt_hub:main handoff:master rusty-idd:develop atc:main rtk-tokenkill:develop icm:main; do
  gh api "repos/FlexNetOS/${r%:*}/branches/${r#*:}/protection" --jq '{checks: [.required_status_checks.checks[]?.context], strict: .required_status_checks.strict, force: .allow_force_pushes.enabled, del: .allow_deletions.enabled}'
done
```
Expected: meta=8 checks; canon=5–6 (+Semantic PR Title); **handoff=4** (Test ubuntu/macos, Clippy, Format —
added AFTER the bulk rollout); rusty-idd=[rust,msrv]; atc=[CI]; icm/rtk = empty-checks anti-force-push;
everything strict where checks exist; force/del=false everywhere; `allow_auto_merge` + `delete_branch_on_merge`
true on all 24 + weave + lane. Also verify NO repo had visibility changed this session (private list should
still match the audit table) and weave/lane/.github protections were left untouched.

**E. The autonomous-loop proof** (the crown — verify every link):
```bash
cd ~/Desktop/meta/handoff && git log --oneline -3      # 1894a7c (PR#3), 00fdf85 (PR#2) on master
gh pr view 3 -R FlexNetOS/handoff --json state,mergedAt,autoMergeRequest,mergedBy   # MERGED; auto-merge evidence
git log --oneline -1 origin/develop                     # develop == master (FF'd)
./target/debug/hf status | head -5                      # builds; ship + review verbs exist (hf 2>&1 | grep ship)
./target/debug/hf resume --json                         # witnessed_events_verified ≥ 16
ls docs/adr-0002-weave-a2a-conventions.md               # ADR-0002 merged
sqlite3 .handoff/ledger.db "SELECT kind, count(*) FROM events GROUP BY kind"   # claim/checkpoint/pr_opened?/review_verdict present (schema names may differ — inspect)
```
weave side: `weave job show job_1781288389_4006551383679797497` and `job_1781288736_4006552163327211592`
(both `completed` with result payloads; use the canonical build: `~/Desktop/meta/weave/target/release/weave`
— `~/.cargo/bin/weave` is STALE, no lease support). Re-verify the witness chain integrity, not just count.

**F. Workspace health** (the original red-CI story):
```bash
meta git status | head -70        # everything clean/synced; main checkouts on default branches
cargo fmt --all -- --check && cargo clippy --workspace --all-targets -- -D warnings && cargo test --workspace
```
Full workspace gates must be green locally (this mirrors meta main CI post-#11). Run FULL summaries, no tail/grep filtering.

**G. Intentional states — do NOT "fix" these** (they are decisions, not drift):
shimmy `publish = false` + 2 `#[ignore]`d MLX tests + gate_4 workspace-skip; teri temp_dir shadow bindings;
ruflo local main behind origin (pin-branch pattern); 4 weave-* entries REMOVED from .meta.yaml (stale second
checkouts); claude-plugin/copilot-plugin = parent path-aliases; 37 pre-existing worktree sets in `.worktrees/`
(hygiene backlog, untouched by design); orchestrator-as-reviewer stand-in on handoff PR#3 (documented HFTASK-0010
gap, ask_66_1781294399867172); `pr_opened` event lives in the (removed) worktree ledger — canonical copy is a
checkpoint in the main ledger (HFTASK-0007 design point #13).

## PHASE 3 — VERDICT + PERSISTENCE

- Produce `VERIFICATION-REPORT.md` at meta root: per-cluster PASS/FAIL/FIXED table with evidence (command +
  observed value), any new defects found + their fix PRs, and an honest delta list (claims that did not match).
- Memoir: add `org-audit-verification-<date>` (ADR structure incl. Research/Cross-References) linked
  `instance_of → org-audit-results-2026-06-12`; refine `adr-2026-06-11-open-questions` if any status moved;
  `icm store` the outcome. Update `context/overridable/active` via git kb if the KB is in use this session.
- Check `NEEDS-HUMAN.md` items: report which were actioned by the human in the interim (e.g. shimmy-1/teri-1
  deleted? dashboard visibility changed?) — refresh the file.
- vox (piper, English, ≤2 sentences) on completion. End with the standard resume packet (`hf handoff` if you
  touched handoff state, + SESSION-HANDOFF.md update on a branch if docs changed).

## WALLS
Transient network/CI flakes → retry. Permission-classifier denials (org-secrets listing, some merges) →
NEEDS-HUMAN with exact commands, continue. If merge authority is needed, ask ONCE for session-wide green-PR
merge authority (precedent: granted last session).
