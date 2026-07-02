# Local-First CI and GitHub Receipt Policy

FlexNetOS `meta` work defaults to **local-first validation**. GitHub Actions is
valuable, but it should usually act as a recorded receipt for the exact pushed
commit rather than the primary engineering feedback loop.

This policy is especially important for single-user or single-admin FlexNetOS
workspaces where the operator already controls the repo, the machine, and the
release decision. In that mode, repeating the same heavy validation locally and
again on GitHub is often slower, more expensive, and less informative than a
local full gate plus a lightweight GitHub receipt.

## Decision hierarchy

1. **Local full validation is the primary development gate.** Run heavy tests,
   audits, code generation checks, and agent/self-upgrade loops locally first.
2. **GitHub PR/push CI is a receipt.** It should prove that the pushed commit
   can run in a clean, recorded environment, not duplicate every local loop by
   default.
3. **Self-hosted runners are preferred for expensive receipt checks.** They keep
   GitHub's green/red status and audit trail while avoiding hosted compute cost.
4. **Cloud full CI is opt-in.** Use release tags, `workflow_dispatch`, scheduled
   maintenance, critical-path labels, or an explicit operator request.
5. **Token-consuming AI/Codex checks are opt-in only.** Do not run LLM-backed
   checks in GitHub Actions by default unless a release policy or explicit label
   requires them.

## What to run where

| Validation | Default place | GitHub role |
|---|---|---|
| TDD loops and root-cause debugging | Local checkout or isolated worktree | None until ready to push |
| Heavy multi-repo tests | Local `meta exec` or self-hosted runner | Manual/label/release receipt |
| Format, lint, compile smoke | Local first, then lightweight GitHub | PR/push receipt |
| Release packaging | Local proof, then GitHub release workflow | Release artifact receipt |
| Agentic/Codex/LLM checks | Local or manually triggered runner | Never default PR/push |

## Operator examples

### Local full validation

```bash
# Inspect the fleet before broad work.
meta project list --json
meta git status

# Scope validation to the repos that matter.
meta --include meta_cli,meta_git_cli exec -- cargo test
meta --include meta_cli,meta_git_cli exec -- cargo clippy --all-targets -- -D warnings

# Run dependency-aware validation when changes touch shared crates.
meta --ordered exec -- cargo test
```

### Lightweight GitHub receipt

A lightweight PR/push workflow should prefer fast, deterministic checks such as:

```bash
cargo fmt --all -- --check
cargo clippy --workspace --all-targets -- -D warnings
cargo test --workspace --lib
```

Use this to prove the pushed commit is coherent in a clean environment. Do not
add long matrix jobs, release packaging, or AI checks to default PR/push CI
without an explicit policy exception.

### Manual or label-triggered full CI

Use one of these patterns when a full cloud receipt is truly needed:

```yaml
on:
  workflow_dispatch:
    inputs:
      full:
        type: boolean
        default: false
```

```yaml
if: contains(github.event.pull_request.labels.*.name, 'run-full-ci')
```

Good trigger reasons include release preparation, cross-platform packaging,
security-sensitive changes, or a PR that cannot be reproduced on local hardware.

### Self-hosted runner receipt

For expensive checks that still need a GitHub status, route them to a self-hosted
runner:

```yaml
runs-on: [self-hosted, flexnetos, linux]
```

This preserves the GitHub audit trail while keeping the compute local to
FlexNetOS.

## Bootstrap and command semantics

GitKB and Meta initialization commands are separate:

| Command | Meaning |
|---|---|
| `git-kb init` | Create/configure the repository knowledge base. |
| `git-kb init codex` | Install Codex integration files from GitKB. |
| `git-kb init claude` | Install Claude integration files from GitKB. |
| `meta init claude` | Install Meta-owned Claude skills/rules/hooks in current `meta 0.2.22`. |
| `meta exec -- <cmd>` | Run `<cmd>` across repos selected from `.meta.yaml`. |

There is no `meta exec init` subcommand in current `meta 0.2.22`. To initialize
GitKB/Codex across a fleet, run the GitKB command through `meta exec`:

```bash
meta exec -- /home/flexnetos/FlexNetOS/usr/bin/git-kb init
meta exec -- /home/flexnetos/FlexNetOS/usr/bin/git-kb init codex
```

## Drift checklist

When changing CI, hooks, or agent surfaces, update all relevant places in the
same change:

- [ ] Durable docs: this file and any workflow-specific docs.
- [ ] Codex guidance under `.codex/`.
- [ ] Claude guidance under `.claude/` and `claude-plugin/skills/`.
- [ ] GitKB guidance under `.kb/` and the active KB task.
- [ ] GitHub workflow comments/triggers when cloud behavior changes.
- [ ] Hook audit evidence proving no hook silently starts expensive cloud or
      token-consuming AI work without an explicit gate.

## Current policy for GitHub Actions

GitHub Actions may still be useful for branch protection, releases, and external
status visibility. The default rule is not "never use GitHub"; it is:

> Run the heavy proof locally first. Use GitHub for the smallest useful receipt,
> and make expensive cloud or token-consuming checks explicit.
