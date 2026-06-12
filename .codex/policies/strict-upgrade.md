# Strict Upgrade Policy

This workspace is upgrade-first. Dirty files are not rollback targets by default.

## Required Behavior

- Treat dirty state as intentional upgrade work until repo evidence proves it is accidental.
- Fix missing follow-through instead of reverting the upgrade.
- Preserve `.claude/settings.json` Bash push permission additions unless the user explicitly asks to remove them.
- Preserve root `Cargo.lock` changes when they reflect child workspace member upgrades.
- If a lockfile changed because a workspace member changed, reconcile manifests, lockfiles, tests, and docs instead of reversing the lockfile.
- If an upgrade is incomplete, report the missing companion work and complete it when asked.

## Current Intentional Upgrade State

- `.claude/settings.json` includes Bash push permission allowances for `git push`, `meta git push`, and `git -C * push`.
- Root `Cargo.lock` may include generated dependency changes from child workspace member upgrades, including `rtk-tokenkill` and other workspace members.

## Wrong Default

Do not propose `git checkout --`, reset, revert, or lockfile rollback as the default plan for these files.

## Right Default

Explain why the files are dirty, identify what was missed, then upgrade the missing policy, docs, manifests, lockfiles, tests, or commits needed to make the state coherent.
