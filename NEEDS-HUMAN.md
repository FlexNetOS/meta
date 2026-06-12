# NEEDS-HUMAN — consolidated walls (org-audit mission, 2026-06-12)

Genuine walls only — everything else was retried or routed around. Each entry has the exact command(s) to run.

## 1. Delete auto-suffix fork artifacts (org-destructive → human)
Residue of the silent-fork lesson; the genuine forks exist under proper names (`FlexNetOS/shimmy`, `FlexNetOS/teri`).
```bash
gh repo delete FlexNetOS/shimmy-1 --yes
gh repo delete FlexNetOS/teri-1 --yes
```

## 2. Org-secrets listing blocked (permission classifier)
Phase 4 wanted to confirm `PARENT_REPO_PAT` / `REPO_WRITE_PACKAGES_PAT` are org-level (not repo-level copies). PARENT_REPO_PAT was verified org-level on 2026-06-11; please confirm both:
```bash
gh api orgs/FlexNetOS/actions/secrets --jq '.secrets[] | {name, visibility}'
```

## 3. meta_dashboard_cli inconsistencies (visibility = human-only decision)
A2-tier code repo that is **private** + default `master` + zero CI, vs 8 public/main canon peers. If intended to follow canon:
```bash
gh repo edit FlexNetOS/meta_dashboard_cli --visibility public --accept-visibility-change-consequences
gh api -X PATCH repos/FlexNetOS/meta_dashboard_cli -f default_branch=main   # after creating/renaming the branch
# then roll the canon 3-workflow template onto it
```
Same visibility question for `meta-plugins` (private, A2).

## 4. meta_plugin_api disposition (superseded stub)
109-line legacy trait API, no workflows, zero reverse deps (verified). Preferred: archive.
```bash
gh repo archive FlexNetOS/meta_plugin_api --yes
# + remove from .meta.yaml + root Cargo.toml members + .gitignore in a follow-up PR
```

## 5. Unregistered org repos — disposition wanted
`harness` (fork of revfactory/harness), `slim` (fork of nilbuild/slim), `global_projects_config` (private, 9KB), `demo-repository` (profile fetch hit a network timeout during audit). Register in `.meta.yaml` as Tier C members, or archive/delete.

## 6. Optional: rename `env_manager_agent` → `kasetto`
Aligns repo name with the registered project name (redirects preserve the old URL):
```bash
gh repo rename kasetto -R FlexNetOS/env_manager_agent --yes
# then update .meta.yaml kasetto.repo to git@github.com:FlexNetOS/kasetto.git
```

## 7. atc workflow-approval gating
atc PR runs end `action_required` (manual workflow approval), which blocks autonomous loops on that repo. Settings → Actions → General → adjust fork/first-time-contributor approval policy if autonomy on atc is wanted.

## Standing hardware/network walls (unchanged, from memoir)
- lane relay unfinished → cross-machine paths unreliable.
- envctl vault development gated by the USB secret-key (separate device from the cognitum seed).
- Cognitum seed plugged but unreachable (USB data-port issue).
