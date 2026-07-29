<!-- Source: https://gitkb.com/docs/getting-started/quick-start/ -->
<!-- Snapshot: 2026-07-02 -->

# Quick Start

## Try code intelligence instantly

After installing , you can use code intelligence on any Git repo immediately — no initialization needed:

```
cd your-project
git-kb code index
git-kb code callers your-function
git-kb code impact src/your-file.ts
```

That’s it. You have a call graph. See Code Intelligence  for the full command reference.

## Set up your agent harness

To let your AI agent use code intelligence (and the full knowledge engineering platform) automatically, initialize your harness:

```
git-kb init
git-kb init claude   # or: git-kb init codex
```

This creates the knowledge base and scaffolds your agent’s rules, skills, and MCP configuration so it knows how to use GitKB effectively.

## Start building

Open Claude Code and ask a question:

>

“What’s the blast radius of changing the authenticate function?”

>

“Find all the dead code in src/api/ and tell me what’s safe to delete.”

>

“Let’s use GitKB to start a new project.”

The agent uses code intelligence tools automatically. With a full KB initialized, it also walks you through creating context documents for your project — what it does, who it’s for, what technical decisions you’ve made. From there, it guides you into task-based, pragmatic engineering: creating tasks with acceptance criteria, tracking progress, and building a knowledge base that compounds in value with every session.

## What happens behind the scenes

Natural language and an agent with skills are enough to leverage all of GitKB’s capabilities — you can use it extensively before needing to master the CLI yourself. But understanding the commands helps you see what the agent is doing on your behalf.

### Documents

Everything in GitKB is a document  — Markdown with YAML frontmatter. Tasks, specs, incidents, architecture decisions, context documents. They have types, statuses, tags, and relationships to each other via ` [[wikilinks]]` .

```
# Create a document
git-kb create --type task --slug tasks/auth-refactor --title "Refactor auth module"

# View a document (tip: install glow for colorized output — see Installation)
git-kb show tasks/auth-refactor

# List all documents
git-kb list

# List tasks filtered by status
git-kb list --type task --status active
```

### The workspace

The workspace (` .kb/workspace/` ) is where documents are checked out for editing. Check out, edit the Markdown file, and commit your changes back:

```
git-kb checkout tasks/auth-refactor
# Edit .kb/workspace/tasks/auth-refactor.md
git-kb commit -m "Add acceptance criteria"
```

### The board

View your tasks organized by status, priority, or tags:

```
git-kb board
git-kb board --group-by priority
git-kb board --sort-by updated --sort-direction desc
```

### Search and graph

Find documents by content, and explore how they relate to each other:

```
git-kb search "authentication"
git-kb graph tasks/auth-refactor
```

### Sync

Share your KB with your team by pushing to a remote. Pull only the documents you need:

```
git-kb push
git-kb pull 'context/*'
```

## Next steps

- MCP Setup  — Connect GitKB to Cursor, Cline, Windsurf, and other editors

- Documents  — Learn about document types and frontmatter

- Code Intelligence  — Index your source code for call graph analysis

- Configuration  — Customize your GitKB setup
