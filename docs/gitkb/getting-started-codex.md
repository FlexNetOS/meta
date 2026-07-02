<!-- Source: https://gitkb.com/docs/getting-started/codex/ -->
<!-- Snapshot: 2026-07-02 -->

# GitKB with Codex

Local verification: this extracted page was executed against the FlexNetOS
`meta` checkout. The repo-local `.codex/skills/` directory contains all 17
GitKB skill adapters as symlinks to `.kb/skills/`, and
`.codex/instructions/` contains `codex-rules.md` and `gitkb-process.md`.
`git-kb init codex --dry-run` currently skips 53 existing assets.

GitKB ships with a Codex integration that scaffolds agent-ready skills and instructions. Use it to keep Codex sessions grounded in GitKB context, code intelligence, and task traceability. Repo-local Codex skills are adapters for the canonical workflows in ` .kb/skills/` .

## Scaffold the integration

After initializing your KB  and configuring MCP , run:

```
git-kb init codex
```

This generates the Codex integration into your project:

```
.codex/
├── skills/
│   ├── gitkb                    # Core KB management skill
│   ├── code-intelligence        # Call graph and symbol workflows
│   ├── explore                  # Discovery workflows
│   ├── understand               # File/symbol understanding
│   ├── refactor-safety          # Blast radius checks
│   ├── kb-board                 # View the kanban board
│   ├── kb-close                 # Complete a task with verification
│   ├── kb-commit                # Commit KB workspace changes
│   ├── kb-context               # Load project context
│   ├── kb-create                # Create KB documents
│   ├── kb-handoff               # End-of-session context handoff
│   ├── kb-progress              # Log progress on a task
│   ├── kb-review                # Review task against criteria
│   ├── kb-search                # Search the knowledge base
│   ├── kb-start                 # Start task workflow
│   ├── kb-status                # Show workspace status
│   └── kb-tasks                 # List and filter tasks
└── instructions/
    ├── codex-rules.md           # GitKB-first workflow and discipline
    └── gitkb-process.md         # Session start/work/completion guidance
```

Most entries under ` .codex/skills/`  are symlinks into ` .kb/skills/` , so Codex loads the same canonical GitKB workflows used by other harnesses. The ` kb-*`  command-style workflows are installed as skills. See Agent Harnesses &  Skills  for the full skill inventory and local skill-pack symlink model.

Preview what would be generated without writing anything:

```
git-kb init codex --dry-run
```

In this checkout, the dry-run reports `Dry run: 53 skipped`, meaning the
repo-local Codex scaffold is already present.

## Install into CODEX_HOME

By default, ` git-kb init codex`  only creates repo-local ` .codex/` . To install the assets into your global Codex home directory, run:

```
git-kb init codex --install-home
```

This installs into ` $CODEX_HOME`  when set, or ` ~/.codex`  by default. Command-style workflows are still provided as skills, not as a separate ` .codex/commands/`  install.

In this checkout, `git-kb init codex --dry-run --install-home` would add
`$CODEX_HOME/skills/meta-9f262555` and
`$CODEX_HOME/instructions/meta-9f262555`, while skipping the 53 repo-local
assets.

## What the instructions teach Codex

The scaffolded instructions in ` .codex/instructions/`  set the workflow expectations:

- GitKB-first  — start with ` git-kb context`  and keep progress logged in task docs.

- Code intelligence  — prefer ` git-kb code`  tools (or MCP equivalents) over grep.

- Task traceability  — scope commits to task docs and include task references.

For the full skill inventory, including task lifecycle skills such as ` kb-review` , ` kb-close` , and ` kb-handoff` , see Agent Harnesses &  Skills .

## Example workflow

A typical Codex session with GitKB:

```
git-kb context --compact --code-refs
git-kb board
git-kb checkout tasks/example-task
git-kb code callers src/app.ts::handler
git-kb commit -m "Update task progress [[tasks/example-task]]" tasks/example-task
```

For a clean local verification pass, use existing task and symbol names rather
than creating the placeholder task:

```
git-kb context --compact --code-refs
git-kb board --json
git-kb checkout tasks/meta-plugin-gitkb-harness-generation
git-kb code callers handle_command_dispatch --json
git-kb diff
```

## Next steps

- Claude Code  — Full Claude integration (rules, skills, and MCP configuration)

- Agent Harnesses &  Skills  — Supported harnesses and canonical skill list

- Code Intelligence  — Call graph and symbol workflows

- CLI Reference  — Full command reference including ` init codex`
