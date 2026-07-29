<!-- Source: https://gitkb.com/docs/getting-started/claude-code/ -->
<!-- Snapshot: 2026-07-02 -->

# GitKB with Claude Code

GitKB ships with a first-class Claude Code integration. A single command scaffolds the files Claude needs — rules that teach it your knowledge management workflow, skill adapters that point at canonical ` .kb/skills/`  workflows, MCP settings, and a ` CLAUDE.md`  entry point.

## Scaffold the integration

After initializing your KB  and configuring MCP , run:

```
git-kb init claude
```

This generates the Claude Code integration into your project:

```
.claude/
├── rules/
│   ├── code-intelligence.md      # Teaches Claude to use call graph tools
│   ├── refactoring-safety.md     # Blast radius checks before changes
│   └── knowledge-management.md   # KB workflow and commit discipline
├── skills/
│   ├── gitkb                    # Forwarder to .kb/skills/gitkb
│   ├── code-intelligence        # Call graph and symbol workflows
│   ├── explore                  # Discovery workflows
│   ├── understand               # File/symbol understanding
│   ├── refactor-safety          # Blast radius checks
│   ├── kb-board                 # View the kanban board
│   ├── kb-close                 # Complete a task with verification
│   ├── kb-commit                # Commit KB workspace changes safely
│   ├── kb-context               # Load/validate project context
│   ├── kb-create                # Create tasks/incidents/specs/notes
│   ├── kb-handoff               # End-of-session context handoff
│   ├── kb-progress              # Log progress on a task
│   ├── kb-review                # Review task against criteria
│   ├── kb-search                # Search the knowledge base
│   ├── kb-start                 # Task startup workflow
│   ├── kb-status                # Show workspace status
│   └── kb-tasks                 # List and filter tasks
├── settings.json                 # MCP + daemon configuration
└── CLAUDE.md                     # Points Claude to your AGENTS.md
```

Most entries under ` .claude/skills/`  are symlinks into ` .kb/skills/` , so Claude loads the same canonical GitKB workflows used by other harnesses. The ` kb-*`  command-style workflows are installed as skills. See Agent Harnesses &  Skills  for the full skill inventory and local skill-pack symlink model.

Preview what would be generated without writing anything:

```
git-kb init claude --dry-run
```

## How Claude uses it

Once scaffolded, Claude Code reads ` .claude/rules/`  as always-on project guidance, loads GitKB workflows from ` .claude/skills/` , and uses ` .claude/settings.json`  to connect to the GitKB MCP server.

## What the rules teach Claude

The scaffolded rules in ` .claude/rules/`  shape how Claude works with your codebase:

- Code intelligence  — Use ` kb_callers` , ` kb_callees` , and ` kb_impact`  instead of grep for finding usages. Understand the call graph before modifying functions.

- Refactoring safety  — Always check blast radius before changing signatures. Assess risk by caller count. Update leaf callers first.

- Knowledge management  — Check the board before starting work. Create documents before implementing. Scope commits to specific documents. Link everything with ` [[wikilinks]]` .

## Example workflow

A typical Claude Code session with GitKB:

```
> Show the GitKB board

  Board shows 3 active tasks, 1 blocked

> Start tasks/auth-refactor with GitKB

  Loads project context, checks out task docs,
  sets status to active, shows acceptance criteria

> Check refactor safety for src/auth.ts::validateToken

  Shows 12 callers across 4 files — medium risk.
  Lists all call sites that need updating.

  ... Claude implements the changes ...

> Log GitKB progress

  Logs timestamped progress entry to the task

> Close the GitKB task

  Verifies all acceptance criteria are met,
  records completion evidence, updates status
```

## Next steps

- Codex  — Codex integration with GitKB skills and instructions

- Agent Harnesses &  Skills  — Supported harnesses and canonical skill list

- Agent Workflows  — Patterns for how AI agents use GitKB effectively

- Code Intelligence  — Deep dive into call graph analysis

- CLI Reference  — Full command reference including ` init claude`
