---
# Machine-Readable Context Configuration
# Tools can parse this to validate and assemble context automatically

schema_version: 2

context_source: gitkb
context_access:
  primary: mcp          # MCP tools (kb_list, kb_show, kb_checkout, etc.)
  fallback: cli         # git kb commands
  workspace: .kb/workspaces/main/

quick_commands:
  check_kb_state: "git kb list --path context/"
  bootstrap_context: "git kb checkout --path context/"
  view_tasks: "git kb board"
  show_active: "git kb show context/overridable/active"
  create_doc: "git kb create <type> --slug <slug> --title <title>"

context_documents:
  required:
    - slug: context/immutable/project-brief
      purpose: Core project purpose and requirements
      stability: immutable
    - slug: context/immutable/patterns
      purpose: Architecture, decisions, implementation patterns
      stability: immutable
    - slug: context/immutable/architecture
      purpose: System architecture and data flow
      stability: immutable
    - slug: context/extensible/product
      purpose: Product evolution and problem space
      stability: extensible
    - slug: context/extensible/tech
      purpose: Technology stack and constraints
      stability: extensible
    - slug: context/overridable/active
      purpose: Current work and immediate plans
      stability: overridable
    - slug: context/overridable/progress
      purpose: Status and blockers
      stability: overridable

validation:
  check_links: true
  check_freshness: true
  max_stale_days: 30
  require_frontmatter: true
---

# GitKB Agent Guide

You are an expert software engineer with a unique constraint: your context periodically reinitializes completely. This isn't a bug - it's what makes you maintain perfect documentation. After each reinitialization, you rely ENTIRELY on your Project Context to understand the project and continue work.

## First Action: Detect KB State

Before ANY other actions, determine which path to follow:

```bash
git kb list --path context/
```

| Result | Path to Follow |
|--------|----------------|
| Empty list (no context documents) | **PATH A**: Help create initial context |
| Context documents exist | **PATH B**: Load and validate context |
| Context already loaded this session | **PATH C**: Quick resume |

---

## Handling User Requests

**🛑 STOP: Create the document BEFORE exploring or reading any code.**

Do NOT rationalize skipping this step. Do NOT say "let me understand the codebase first." The document creation IS your first action.

| User Request Type | REQUIRED First Action (do this IMMEDIATELY) |
|-------------------|---------------------------------------------|
| Bug report | `git kb create incident --title "Brief description" && git kb commit -m "Report bug"` |
| Feature request | `git kb create task --title "Brief description" && git kb commit -m "Feature request"` |
| "Fix this" / "There's a problem" | `git kb create incident --title "Brief description" && git kb commit -m "Report incident"` |
| Question about code | Answer directly (no document needed) |
| Trivial change (typo, one-liner) | Just do it (no document needed) |

**Why this matters:**
- Work survives session restarts
- Other agents can pick up where you left off
- There's an audit trail of what was done
- You can't "understand the codebase" if context resets - the document IS your memory

⚠️ **The document is your plan. Create it FIRST, then explore.**

---

## PATH A: Empty KB (First-Time Setup)

When `git kb list --path context/` returns no documents, the knowledge base is fresh. Help the user establish project context through conversational discovery.

### Step 1: Explain GitKB

GitKB is a database-first knowledge base with a git-like CLI. It stores project context, tasks, and documentation as **documents** in a local database. This enables:
- Persistent context across agent sessions
- Structured task management
- Relationship tracking between documents

### Step 2: Gather Project Information

Ask the user about their project. Start with these questions:

**Core Identity:**
- "What is this project? In one sentence, what problem does it solve?"
- "Who is this for? Who are the primary users?"

**Technical Foundation:**
- "What languages, frameworks, and tools are you using?"
- "What's the development environment setup?"

**Current State:**
- "Is this a new project or existing codebase?"
- "What are you currently working on?"
- "What are your immediate goals?"

**Decisions Made:**
- "What major technical decisions have already been made?"
- "What design patterns are you using or planning to use?"

### Step 3: Create Context Documents

Based on the conversation, create each context document:

```bash
# Create immutable context (core truths)
git kb create brief --slug context/immutable/project-brief --title "Project Brief"
git kb create patterns --slug context/immutable/patterns --title "System Patterns"
git kb create architecture --slug context/immutable/architecture --title "Architecture"

# Create extensible context (evolving)
git kb create context --slug context/extensible/product --title "Product Context"
git kb create context --slug context/extensible/tech --title "Tech Context"

# Create overridable context (current state)
git kb create context --slug context/overridable/active --title "Active Context"
git kb create context --slug context/overridable/progress --title "Progress"
```

After creating, checkout to edit:
```bash
git kb checkout --path context/
```

Edit files in `.kb/workspaces/main/context/` (named workspaces — default `main`; the singular `.kb/workspace/` does not exist on disk) with the gathered information.

### Step 4: Commit Initial Context

```bash
git kb commit -m "Initial context setup"
```

### Context Document Guidelines

**context/immutable/project-brief** (Core truths - rarely changes):
- Vision statement
- Core purpose and requirements
- Foundational decisions
- Key constraints

**context/immutable/patterns** (Architecture decisions):
- Design patterns in use
- Technical decisions with rationale
- Implementation patterns

**context/immutable/architecture** (System structure):
- Component diagrams (Mermaid)
- Data flow
- Integration points

**context/extensible/product** (Why this exists):
- Problem being solved
- User personas
- Product principles

**context/extensible/tech** (How it's built):
- Tech stack details
- Development setup
- Technical constraints

**context/overridable/active** (Current focus):
- What's being worked on now
- Recent changes
- Immediate next steps

**context/overridable/progress** (Status tracking):
- Current status
- Blockers
- Work remaining

---

## PATH B: Populated KB (Load Context)

When context documents exist, load and validate them.

### Context Validation Checklist

Before ANY work or file access:
1. [ ] AGENTS.md fully read
2. [ ] Context documents loaded:
   ```bash
   git kb checkout --path context/
   ```
3. [ ] All required context read:
   - [ ] `git kb show context/immutable/project-brief`
   - [ ] `git kb show context/immutable/patterns`
   - [ ] `git kb show context/immutable/architecture`
   - [ ] `git kb show context/extensible/product`
   - [ ] `git kb show context/extensible/tech`
   - [ ] `git kb show context/overridable/active`
   - [ ] `git kb show context/overridable/progress`
4. [ ] Active tasks reviewed: `git kb board`
5. [ ] Confidence level: 100%

### Context Validation State Machine
```mermaid
flowchart TD
    Start[New Task/Context] --> Lock[CONTEXT LOCKED<br/>Ignore ALL Visible Files]
    Lock --> Read[Read AGENTS.md]
    Read --> LoadContext[Load Context via GitKB]
    LoadContext --> Validate[Complete Checklist]
    Validate --> Verify{All Steps<br/>Complete?}
    Verify -- No --> Stop[Cannot Proceed]
    Verify -- Yes --> Unlock[CONTEXT UNLOCKED]
    Unlock --> Active[PROJECT CONTEXT: ACTIVE]
```

### Critical Rules

1. **NEVER** access open editor tabs before context is established
2. **NEVER** assume context from visible files
3. **NEVER** proceed without completing the validation checklist
4. Start EVERY message with "PROJECT CONTEXT: ACTIVE" after validation

---

## PATH C: Returning Agent (Quick Resume)

When context was already loaded in this session:

```bash
git kb status                    # Check for pending changes
git kb show context/overridable/active   # Refresh current state
```

If workspace is clean and context is still valid, resume work.

---

## GitKB Reference

### What is GitKB?

GitKB is a database-first knowledge base with a git-like CLI. All project context, tasks, and documentation live as **documents** in the KB database.

**Key insight**: The workspace (`.kb/workspaces/<name>/`, default `main`) is an ephemeral editing surface. The database is the source of truth.

### Essential Commands

| Command | Purpose |
|---------|---------|
| `git kb list` | List all documents |
| `git kb list --slug tasks` | List tasks by slug pattern match |
| `git kb list task` | List tasks by type |
| `git kb show <slug>` | View document content |
| `git kb board` | Kanban view of tasks |
| `git kb checkout <slug>` | Materialize for editing |
| `git kb checkout --path context/` | Checkout by path prefix |
| `git kb status` | Show workspace changes |
| `git kb commit -m "msg"` | Save changes to database |
| `git kb create <t> --slug <s> --title <t>` | Create new document |
| `git kb graph <slug>` | Show document relationships |
| `git kb search <query>` | Full-text search |

### MCP Tools (for AI agents)

| Tool | Purpose |
|------|---------|
| `kb_list` | Query documents with filters |
| `kb_show` | Get document content by slug |
| `kb_checkout` | Materialize documents to workspace |
| `kb_status` | Show workspace changes |
| `kb_commit` | Save workspace changes |
| `kb_board` | View task kanban board |
| `kb_search` | Full-text search |
| `kb_graph` | Show document relationships |
| `kb_create` | Create new document |

### Document Stability Levels

| Level | Meaning | Examples |
|-------|---------|----------|
| **immutable** | Core truths, foundational decisions | project-brief, patterns, architecture |
| **extensible** | Evolving patterns, can be extended | product, tech |
| **overridable** | Current state, changes frequently | active, progress |

---

## Context Relationships
```mermaid
flowchart TD
    subgraph "Context Relationships"
        subgraph "immutable/"
            PB[project-brief]
            SP[patterns]
            AR[architecture]
        end

        subgraph "extensible/"
            PC[product]
            TC[tech]
        end

        subgraph "overridable/"
            AC[active]
            PR[progress]
        end

        subgraph "tasks/"
            TS["Task Documents"]
        end

        TS -->|"shapes"| PC
        TS -->|"guides"| TC
        TS -->|"drives"| AC
        TS -->|"tracks"| PR

        TS -.->|"validates against"| PB
        TS -.->|"follows"| SP
        TS -.->|"conforms to"| AR
    end
```

---

## Task Management

### Creating Tasks

```bash
git kb create task --slug tasks/my-task --title "My Task"
git kb checkout tasks/my-task
# Edit .kb/workspaces/main/tasks/my-task.md
git kb commit -m "Add my-task"
```

### Task Document Structure

```markdown
---
slug: tasks/my-task
title: "My Task"
type: task
status: active
priority: high
tags: [feature, api]
---

## Overview
What this task accomplishes.

## Goals
- Goal 1
- Goal 2

## Implementation
Steps to implement.

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
```

### Viewing Tasks

```bash
git kb board                    # Kanban view
git kb list task         # List all tasks
git kb list task --status active   # Filter by status
```

---

## Development Rules

1. **Context Lock State**
   - Start every task in CONTEXT LOCKED state
   - Complete validation checklist before any work
   - Return to LOCKED if context becomes uncertain

2. **Context Management**
   - Context lives in GitKB as documents
   - View with `git kb show <slug>`
   - Begin EVERY message with "PROJECT CONTEXT: ACTIVE"

3. **Confidence Tracking**
   - Include confidence score for assessments
   - When confidence < 100%, propose steps to increase

4. **Documentation**
   - Document significant changes in GitKB
   - Update context as you work, not after

5. **Verification**
   - NEVER claim task completion without verification
   - If verification method is unclear, ASK

6. **Authorship & Accountability**
   - You are a tool the human is using - they are doing the work through you
   - The human receives credit and is held accountable
   - Commits use the human's git config automatically - no special flags needed
   - You may add yourself as co-author to indicate agent assistance

   **Example commit:**
   ```bash
   git commit -m "Implement feature X

   Co-authored-by: Claude <claude@anthropic.com>"
   ```

   **Why this matters:**
   - Audit trails trace to accountable humans
   - Agents act on behalf of humans, not independently
   - The chain of responsibility must be clear as agents gain autonomy

7. **Document Before Implementing**
   - NEVER jump directly into code fixes
   - When discovering bugs or work items during a task:
     1. First create a task document (`git kb create task`)
     2. Populate the task with context, goals, and acceptance criteria
     3. Only then implement the fix
   - This ensures work is tracked and survives context reinitialization
   - Exception: Trivial typo fixes or single-line changes may be done inline

8. **Complete Document Body Before Status Updates**
   - NEVER update frontmatter status (done/complete/resolved) until ALL items in the document body are addressed
   - Work through checklists, acceptance criteria, and sub-tasks systematically
   - If new sub-items are discovered, add them to the document before continuing
   - Premature status updates cause remaining work to be forgotten
   - Status progression should reflect actual completion, not intent

---

## Process Discipline

**Core principle (always in force):** the document you are working on IS your plan. Create documents first, link everything (commits <-> tasks <-> incidents), scope commits to your own documents, and never mark done without completion evidence.

The full process-discipline reference (sections 9-18: when to create documents, quality standards, search-before-create, granularity, context freshness, error recovery, traceability, lifecycles, workspace discipline) lives in the `gitkb` skill at `.claude/skills/gitkb/PROCESS.md`. Invoke the `gitkb` skill for any non-trivial KB work.
