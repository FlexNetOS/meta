<!-- Source: https://gitkb.com/docs/ -->
<!-- Snapshot: 2026-07-02 -->

# GitKB Documentation

GitKB is a git-like distributed knowledge base  with sparse sync and checkout semantics. If you know ` git commit` , ` git checkout` , and ` git push` , you already know the mental model — but GitKB’s protocol is purpose-built for knowledge, not source code. There are no branches — a KB is a single linear stream where each document maintains its own commit chain. These design choices unlock GitKB’s core capability: truly sparse sync. Agents and humans pull only the documents they need for the task at hand. No need to clone an entire repo.

## Why GitKB?

Organizational knowledge is scattered — across IDEs, Jira, Confluence, Linear, Sharepoint, Notion, Slack threads, and the heads of people who’ve moved on. AI agents start every session cold, with no awareness of the decisions, patterns, or context that matter for the task at hand. GitKB solves this by providing a persistent knowledge layer  that humans and agents can load, update, and build on — one that compounds in value over time.

- Grows like a tree, not a DAG  — Git-like commits and sparse sync, but knowledge doesn’t branch and fork. Active edges grow while stale ones naturally fade — attention follows what matters.

- Agent-ready  — 49 MCP tools give AI assistants full read/write access to your knowledge base. No copy-pasting context.

- Code intelligence  — 17 per-language crates for call graph analysis. Understand callers, callees, and blast radius before making changes.

- Sparse by default  — Pull only the documents you need. Each document has its own version chain and sync marker, so different team members hold different subsets of the KB.

- Open protocol  — GitKB is built on an open protocol. The wire format, sync semantics, document schema, and knowledge graph spec are all published at gitkb.org  and freely available for the community to drive forward.

## Quick overview

### Documents

Everything in GitKB is a document  with YAML frontmatter and Markdown content:

```
---
slug: tasks/my-feature
title: "Add user authentication"
type: task
status: active
tags: [feature, auth]
---

## Overview
What this task accomplishes and why it exists.

## Acceptance Criteria
- [ ] JWT-based auth flow
- [ ] Session management
- [ ] Tests passing
```

Documents have types (` task` , ` spec` , ` incident` , ` note` , ` context` ), statuses, tags, and relationships to other documents via ` [[wikilinks]]` .

### The knowledge graph

Documents link to each other through wikilinks, frontmatter references, and code symbols — forming a knowledge graph  you can query:

```
git-kb graph tasks/my-feature --direction both
```

### MCP integration

Connect GitKB to your editor and AI assistants gain full access:

```
{
  "mcpServers": {
    "gitkb": {
      "command": "git-kb",
      "args": ["mcp"]
    }
  }
}
```

The MCP server auto-starts the daemon — no manual setup needed.

## Next steps

 Installation

Install GitKB and set up your first knowledge base.

 Quick Start

Create your first documents and explore the CLI.

 MCP Setup

Connect GitKB to Claude Code, Cursor, and other editors.

 Agent Harnesses &  Skills

Compare Claude Code, Codex, Cursor, Windsurf, and MCP clients.

 Core Concepts

Understand documents, the knowledge graph, and code intelligence.

 Migration &  Adoption

Add GitKB to an existing project and roll it out to your team.

 Configuration

Customize remotes, embeddings, code indexing, and more.
