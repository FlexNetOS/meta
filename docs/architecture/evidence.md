---
slug: docs/architecture/evidence
title: "Architecture Evidence"
type: evidence
status: active
source_task: tasks/meta-system-architecture-documentation
last_verified: 2026-07-02
related:
  - docs/architecture/index
  - docs/architecture/component-inventory
  - docs/architecture/gitkb-generated-maps
---

# Architecture Evidence

## GitKB Workflow Evidence

Commands run from `/home/flexnetos/FlexNetOS/src/meta`:

```bash
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb context --task tasks/meta-system-architecture-documentation --code-refs
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb graph tasks/meta-system-architecture-documentation --json
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb checkout tasks/meta-system-architecture-documentation
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb status --json
```

Result:

- Task was active and checked out through GitKB CLI workflow.
- KB status was clean before source docs edits.
- Graph output proved the task references architecture context, patterns,
  tech context, release tasks, code-intelligence proof, graph policy, loop test,
  and active plugin tasks.

## Source Walk Evidence

Files and directories inspected:

- `.kb/AGENTS.md`
- `.kb/skills/gitkb/SKILL.md`
- `.kb/skills/kb-start/SKILL.md`
- `.kb/skills/kb-progress/SKILL.md`
- `.kb/skills/kb-commit/SKILL.md`
- `.kb/` file inventory through `find .kb -maxdepth 3 -type f`
- `.codex/instructions/codex-rules.md`
- `.codex/instructions/gitkb-process.md`
- `.context/CONTEXT.md`
- `docs/` file inventory through `find docs -maxdepth 3 -type f`
- `README.md`
- `docs/architecture_overview.md`
- `.meta.yaml`
- `/home/flexnetos/FlexNetOS/src/flexnetos_runner/release/catalog.tsv`
- `/home/flexnetos/FlexNetOS/src/flexnetos_runner/scripts/build-local-ubuntu-release.sh`
- `/home/flexnetos/FlexNetOS/usr/bin` executable inventory

## Repo And Component Evidence

Commands:

```bash
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH meta project list --json
find /home/flexnetos/FlexNetOS/src -maxdepth 2 -name .git -type d
find /home/flexnetos/FlexNetOS/usr/bin -maxdepth 1 -type f -executable -printf '%f\n'
find /home/flexnetos/FlexNetOS -path '*/release/catalog.tsv' -o -path '*/release/*.tsv'
```

Key findings:

- `meta project list --json` reported 14 `src/meta` projects.
- Workspace-level source repos found under `/home/flexnetos/FlexNetOS/src`
  include `beads_rust`, `envctl`, `flexnetos_runner`, `loop_lib`, `meta`,
  `meta_plugin_protocol`, `nu_plugin`, `rtk-tokenkill`, `yazelix-helix`, and
  `yazelix`.
- Release catalogs were found at:
  - `/home/flexnetos/FlexNetOS/src/flexnetos_runner/release/catalog.tsv`
  - `/home/flexnetos/FlexNetOS/release/staging/flexnetos-ubuntu-26.04-x86_64-20260702T121553Z/provenance/catalog.tsv`

## Code Intelligence Evidence

Commands:

```bash
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb code stats --json
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb code index --dry-run
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb code index
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb code doctor --json
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb code symbols --file meta_cli/src/main.rs --json --compact
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb code callers meta_cli/src/main.rs::function::main --json
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb code callees meta_cli/src/main.rs::function::main --json
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb code impact meta_cli/src/main.rs --json --compact
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb code entrypoints --refresh --json
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb code flows --refresh --json
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb code query hotspots --json --limit 10
PATH=/home/flexnetos/FlexNetOS/usr/bin:$PATH git-kb code refs meta_cli/src/main.rs::function::main --json
```

Key findings:

- `git-kb code stats --json`: 1429 symbols, 314 files, 2787 call edges,
  11517 unresolved calls.
- `git-kb code index --dry-run`: would index 1427 symbols from 240 files,
  14304 call sites, 246 imports, 27 forwarding facts.
- `git-kb code index`: indexed 1427 symbols from 240 files, extracted 14304
  call sites, 246 imports, and 27 symbol-forwarding facts; all 240 files were
  unchanged.
- `git-kb code doctor --json`: repo discovery strategy `meta`, status `ok`,
  and recommendations around unresolved calls.
- `git-kb code symbols --file meta_cli/src/main.rs --json --compact`: 50
  symbols.
- `git-kb code callers meta_cli/src/main.rs::function::main --json`: zero
  callers.
- `git-kb code callees meta_cli/src/main.rs::function::main --json`: 20
  callees.
- `git-kb code impact meta_cli/src/main.rs --json --compact`: 9 direct caller
  entries.
- `git-kb code query hotspots --json --limit 10`: top hotspots included
  `LockGuard.path`, `Grade.display`, `evaluate_command`, `RepoSpec.from_str`,
  and `SubprocessPluginManager.new`.

## Known Gaps

- `git-kb code index` reported all indexed files unchanged after extraction.
- Markdown/config files are detected by code intelligence but are not symbolized.
- Root-level FlexNetOS source peers outside `src/meta/.meta.yaml` need their own
  peer-specific docs if the architecture set is expanded beyond control-plane
  and release inventory.
