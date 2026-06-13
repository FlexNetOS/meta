# HANDOFF — FIX-MISSION Phase 6 close (session relay)

staged_utc: 2026-06-13 (session 6, Opus 4.8) — relay so a fresh session finishes Phase 6 without idling on CI.
authoritative_signal: this committed file + the witnessed fleet ledger (`handoff/.handoff/ledger.db`).
state_precedence: Git > .handoff/ledger.db > task cards > this file.

## TL;DR for the resuming session

The FIX-MISSION is **done except a CI-gated tail**. All six FIX tasks shipped and merged; the only
open thread is **prompt_hub#78** (greens prompt_hub's own pre-existing red `main`), whose required
6-way Test matrix is just slow (~45+ min). Everything downstream is **already staged** — you mostly
wait for #78, then run three short steps and close.

## Verify-on-resume baseline (run first)

```bash
cd ~/Desktop/meta
gh pr view 78 -R FlexNetOS/prompt_hub --json state,mergeStateStatus --jq '"\(.state) \(.mergeStateStatus)"'
gh pr checks 78 -R FlexNetOS/prompt_hub --required        # the 3 stable Test jobs are the gate
gh pr view 77 -R FlexNetOS/prompt_hub --json state --jq .state
git -C handoff fetch origin && git -C handoff log origin/master -1 --oneline   # #17/#18 fleet verbs are in
```

If `git status` in a child shows another session active (e.g. copilot-plugin, prompt_hub
`feat/auto-ci-fail-notify`, the envctl agenticOS loop) — stay out of their lanes; coordinate via weave.

## Remaining work (in order)

1. **When #78 is green on REQUIRED checks → merge it** (auto-merge is armed; if it stalls on BEHIND,
   `gh api repos/FlexNetOS/prompt_hub/pulls/78/update-branch -X PUT`). This greens prompt_hub `main`
   and unblocks the dependabot stack (#63–76) too.
   - Note: **Code Coverage is NOT a required check** and is red only on a tarpaulin ptrace timeout
     (every test passes). Do not block #78 on it.

2. **Push the coverage `--timeout` fix** (already committed locally, ungated by anything but #78's main):
   ```bash
   cd ~/Desktop/meta/prompt_hub/.worktrees/cov-timeout      # branch fix/coverage-tarpaulin-timeout, commit d07f80d
   git fetch origin && git rebase origin/main               # pick up #78's braille fix so THIS PR's Test jobs pass
   git push -u origin fix/coverage-tarpaulin-timeout
   gh pr create -R FlexNetOS/prompt_hub --title "ci(coverage): tarpaulin --timeout 300 (ptrace stall guard)" --body "Makes the non-required Code Coverage job green; tests already pass, only tarpaulin's 60s default ptrace ceiling tripped." 
   gh pr merge fix/coverage-tarpaulin-timeout -R FlexNetOS/prompt_hub --auto --squash
   ```

3. **Update prompt_hub#77** (the P7 `.handoff` seed) onto green main → it merges:
   ```bash
   gh api repos/FlexNetOS/prompt_hub/pulls/77/update-branch -X PUT
   # monitor → MERGED. That closes the last of the 4 stuck P7 seeds.
   ```

4. **Land the Phase 6 docs PR** (this PR — `docs/fix-mission-close`): it carries GAP-REGISTER (defects
   D1/D2/D3/D9/D10/D12 marked resolved + the prompt_hub#78 row), SESSION-HANDOFF session-6, and this
   relay. Should already be merging when you read this; confirm it landed.

5. **Close**: witness + render via the kernel (dogfood FIX-6):
   ```bash
   HF=~/Desktop/meta/handoff/target/debug/hf   # build if absent: (cd handoff && cargo build -p hf)
   cd ~/Desktop/meta/handoff
   "$HF" checkpoint fleet-handoff-rollout "FIX-MISSION fully closed: prompt_hub#77+#78 merged, coverage green, docs landed"
   "$HF" fleet status            # expect more members with .handoff as seeds propagate
   "$HF" handoff                 # render the next-session packet (kernel-native; do NOT hand-write one)
   vox "Fix mission complete."   # piper, English
   ```
   Then `icm store -t context-meta` a one-line completion note.

## What's already done (do NOT redo)

- FIX-1 teri#3 · FIX-2 (handoff#10, verified) · FIX-3 mint/sync-cards/done (handoff#11) + fleet/render/sync (handoff#17/#18) ·
  FIX-4 kb drop resolved + meta#21 · FIX-5 claude-plugins#1 / vault_hub#2 / shimmy#5 · FIX-6 meta#20 + agent#2 + harness_hub#2.
- 4 stuck P7 seeds: meta#15, atc#2, rusty-idd#39 merged; prompt_hub#77 = step 3 above.
- prompt_hub#78 source fixes verified: Documentation ✅, Safety Check ✅, braille tests pass.

## Owner queue (do NOT self-authorize — NEEDS-HUMAN.md)
A (hub stub batches) · B (Seed data-port) · C (dependabot high) · D (2 settings.json hook entries,
classifier-gated) · E (gitkb-claude-plugin FlexNetOS fork) · G/H (GitHub App, flexnetos_secrets archive) · walls 1–8.

## Observations to surface (not Phase 6, for the owner)
- `copilot-plugin` has no own `.git` (git there resolves to parent); parent `.gitignore` doesn't cover
  `.claude/` runtime caches (backups/cache/sessions/…). Pre-existing; another session active there.
- Two ledgers exist: meta-root `.handoff/ledger.db` (fleet, ~0 events) vs `handoff/.handoff/ledger.db`
  (kernel, 238+ events where checkpoints land). `hf fleet status` reads the meta-root one — worth a
  reconcile pass (likely an envctl agenticOS-loop / handoff-session item).
