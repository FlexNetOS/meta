# LifeOS Portable Release Roadmap Task

## Summary

Create the roadmap and release-architecture package for making meta the control
plane for a portable LifeOS Agentic OS release targeting Ubuntu 26.04 x86_64.
This task is sourced from GitHub issue #98 and tracked in GitKB as
tasks/meta-lifeos-portable-agentic-os-release-roadmap.

## Current evidence

| Area | Evidence status |
|---|---|
| meta | Local checkout inspected before edits |
| lifeos | Remote GitHub inspection at commit 2c6e43894e54c0fc6a79fd284e3eb36a25579636 |
| flexnetos_runner | Local dirty checkout inspected read-only |
| Yazelix | Local checkout inspected at fdcecb70237406555c79a4d1acfd87463d28f9e8 |

## Deliverables

- docs/lifeos-portable-release-roadmap.md
- docs/lifeos-agentic-os-architecture.md
- docs/lifeos-release-filesystem-layout.md
- docs/lifeos-runner-build-pipeline.md
- docs/lifeos-install-update-rollback-contract.md
- docs/lifeos-security-and-sandbox-policy.md
- docs/lifeos-toolchain-and-dependency-bundle.md
- docs/lifeos-release-acceptance-gates.md
- .context/tasks/lifeos-release-task-graph.csv
- .context/tasks/lifeos-release-task-file-map.csv

## Acceptance criteria

- Roadmap docs exist and are linked from README.md and architecture/MCP docs.
- Current-state evidence separates FACT, TARGET, QUESTION, and BLOCKER.
- Portable prefix tree and artifact names are fully specified.
- Meta, runner, LifeOS, Yazelix, and runtime manager responsibilities are
  separated.
- Ubuntu 26.04 x86_64 is the explicit first release target.
- No Docker or default-container dependency is introduced.
- No kernel isolation, Ring 0, host service, or privileged host ownership claim
  is made.
- CSV task graph and file map parse successfully.
- Validation commands and results are recorded in the PR body.

## Next executable task

Start with LOR000 and LOR014:

- LOR000 seals evidence across meta, LifeOS, flexnetos_runner, and Yazelix.
- LOR014 implements the first read-only meta release plan scaffold.

## Open questions and blockers

| ID | Type | Detail |
|---|---|---|
| Q1 | QUESTION | LifeOS was inspected remotely because no local checkout exists in this workspace. |
| Q2 | BLOCKER | Yazelix/Nix closure relocatability is not proven. |
| Q3 | QUESTION | Runner labels and Ubuntu 26.04 host image need final proof. |
| Q4 | QUESTION | meta release may be built-in, plugin-based, or both. |
| Q5 | BLOCKER | GPU/CUDA route has no current proof. |

## Validation log

Record results here before closing the GitKB task:

| Command | Result | Notes |
|---|---|---|
| git diff --check | PASS | Clean after new files were marked intent-to-add |
| CSV DictReader check | PASS | 19 task graph rows and 19 task-file map rows parsed |
| secret/large-file scan | PASS | No secret-marker matches; changed files are text/CSV docs |
