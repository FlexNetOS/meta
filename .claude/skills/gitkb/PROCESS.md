# GitKB Process Discipline Reference

Moved verbatim from `.kb/AGENTS.md` (2026-07-11) to load on demand via the `gitkb` skill instead of residing in every session context.

## Process Discipline

Process discipline creates organizational observability. When followed well, it enables:
- **High-fidelity information discovery**: Everything is linked, nothing is orphaned
- **Minimal information loss**: Work survives session restarts, agent handoffs
- **Organizational observability**: Anyone can see what's happening, what's blocked, what's done

**Core Principle**: The document you're working on IS your plan. There is no separate "plan" artifact.

| Working On | Your Plan Is |
|------------|--------------|
| Investigating an incident | The incident document |
| Implementing a fix | The task document |
| Designing a system | The spec document |
| Understanding a codebase | The context documents |

The workspace checkout IS your focus. What's checked out is what you're working on.

### 9. Judgment: When to Create Documents

**The Threshold Test**: Ask "Would someone else benefit from knowing this exists?"
- **Yes** → Create a document
- **No** → Probably trivial, do it inline

**The Future Agent Test**: Before skipping documentation, ask "If I lose all context right now, could another agent pick this up?"
- **Yes** → You've documented enough
- **No** → Document more before proceeding

| Situation | Action |
|-----------|--------|
| Bug report from user | Create incident |
| Bug you discover while coding | Create incident if non-trivial, or note in current task |
| Feature request | Create task |
| Work item during implementation | Add to current task, or create child task if substantial |
| Design decision needed | Create spec if complex, or document in task |
| Learning something important | Update relevant context doc |
| Single-line typo fix | Just fix it |
| Refactor touching 3+ files | Create task |

### 10. Document Quality Standards

A document should enable **cold-start continuation** - someone with zero context should be able to pick it up and make progress.

**Required sections for tasks:**

```markdown
# Overview
What is this task? Why does it exist? (1-2 paragraphs)

## Goals
What are we trying to achieve? (bullet points)

## Acceptance Criteria
How do we know when it's done? (checkboxes)
- [ ] Specific, verifiable criterion
- [ ] Another specific criterion

## Context
What does someone need to understand to work on this?
- Links to related documents
- Key decisions already made
- Constraints or requirements
```

**As work progresses, add:**

```markdown
## Progress Log
Reverse chronological notes of significant progress.

### YYYY-MM-DD
- Discovered X while investigating Y
- Decided to approach via Z because...
- Commit: abc123 - implemented first part

## Blockers
What's preventing progress? (remove when resolved)

## Completion Evidence
- Commit hashes: abc123, def456
- Test results: all passing
- Verification: manually tested X, Y, Z
```

**Quality Checklist** before considering a document "good enough":
- [ ] Someone with no context can understand the goal
- [ ] Acceptance criteria are specific and verifiable
- [ ] Links exist to related docs (parent task, incident, spec)
- [ ] Key decisions are recorded with rationale
- [ ] Progress is logged (not just final state)

### 11. Discovery: Search Before Create

**Before creating any document:**

1. **Search for existing work**:
   ```
   kb_search with query: "<keywords>"
   kb_list with type: "task", status: "active"
   ```

2. **Check relationships**:
   ```
   kb_graph with slug: "<related-doc>", direction: "both"
   ```

3. **Decide**:
   - Related doc exists → Update it, or create linked child
   - No related doc → Create new

**When to Extend vs. Create New:**

| Situation | Action |
|-----------|--------|
| Additional acceptance criteria for existing task | Extend the task |
| Significantly different scope | Create child task |
| Same symptom, different root cause | New incident, link to related |
| Implementing spec that exists | Create task linking to spec |

### 12. Granularity: Breaking Down Work

**A task is too big when:**
- It has more than 7-10 acceptance criteria
- It spans multiple distinct areas of the codebase
- Different parts could be done in parallel by different agents

**The Hierarchy:**
```
Epic (tasks/gitkb-1: "M3: Local Platform")
  └─→ Task (tasks/gitkb-5: "Service Daemon")
        └─→ Subtask (could be separate task with parent link)
```

**When NOT to break down:**
- The work is straightforward and cohesive
- Breaking it up would add overhead without benefit
- It's investigative (don't know scope yet) - start working, break down as you learn

### 13. Context Documents: The Bigger Picture

**When to update context documents** (`context/overridable/active`, `context/overridable/progress`):
- Starting a major piece of work
- Completing a significant milestone
- Discovering something that changes project direction
- Hitting a blocker that affects overall progress

**The Bootstrap Flow** - every session should start with context:
1. **Load context**: `kb_context` or `kb_checkout --path context/`
2. **Read active context**: Understand current focus
3. **Check board**: `kb_board` to see task states
4. **Then work**: With full situational awareness

**Keeping Context Fresh:**
- `context/overridable/active`: Update when focus changes
- `context/overridable/progress`: Update at end of work session
- Don't let context docs get stale - they're the handoff point

### 14. Incredible Engineer Behaviors

**Proactive Documentation** - Don't just record what you did, record what future-you needs:
- **Dead ends**: "Tried X, didn't work because Y" saves someone else the same mistake
- **Rationale**: "Chose A over B because..." prevents re-litigating decisions
- **Gotchas**: "Watch out for X when doing Y" prevents bugs
- **Dependencies**: "This assumes Z is true" makes assumptions explicit

**Breadcrumbs for Future Agents** - When you learn something, ask "Where should this live so it's discoverable?"
- Code insight → Comment in code + note in task
- Architecture insight → Update context/immutable/architecture
- Pattern discovered → Update context/immutable/patterns
- Temporary state → Note in context/overridable/active

**Anticipate Questions** - Before marking something complete, ask:
- "What would someone ask if they read this?"
- "What context am I assuming that isn't written down?"
- "If this breaks in 6 months, what info would help debug it?"

**Signal Over Noise:**
- Don't document the obvious
- Do document the surprising
- Focus on "why" more than "what" (code shows what)
- Keep documents scannable (headings, bullets, short paragraphs)

### 15. Error Recovery Patterns

**"I Started Coding Without a Document"**
1. Stop coding
2. Create the document now with what you know
3. Add what you've already done to progress log
4. Continue with document as guide

Don't throw away work - just get it documented.

**"I Realized Mid-Task the Scope Changed"**
1. Update the task document:
   - Revise acceptance criteria
   - Add note explaining scope change and why
2. If scope grew significantly:
   - Consider creating child tasks for new scope
   - Update estimates/priority if needed

**"The Workspace Has Stale Checkouts"**
1. `kb_status` - see what's there
2. `kb_diff` - check for uncommitted changes
3. If changes are valuable: `kb_commit` with message explaining the context
4. If changes are stale/irrelevant: `kb_reset` then `kb_clear`
5. Proceed with fresh focus

**"I Forgot to Link Things"**
Go back and add links:
1. Update task with incident it resolves
2. Update incident with task that fixes it
3. Add commit hashes to task document
4. Better late than never - traceability degrades gracefully

**"I Marked Complete Too Early"**
1. Reopen: `kb_set` with status back to `active`
2. Add note explaining what was missed
3. Complete the remaining work
4. Then mark complete again with full evidence

### 16. Traceability Rules

**Everything Links to Everything:**
```
incident
  └─→ references task(s) that fix it
        └─→ references commit(s) that implement it
              └─→ commit message references task slug

parent task (epic)
  └─→ contains child tasks
        └─→ child references parent in frontmatter
```

**In practice:**

1. **Commits reference tasks**: Every commit message includes the task slug
   ```
   fix: resolve auth timeout issue

   Implements [[tasks/gitkb-33]]

   Co-authored-by: Claude <claude@anthropic.com>
   ```

2. **Tasks reference incidents**: When a task fixes an incident, link it
   ```yaml
   # In task frontmatter
   resolves: incidents/inc-009-auth-timeout
   ```

3. **Child tasks reference parents**: Hierarchical work is linked
   ```yaml
   # In child task frontmatter
   parent: tasks/gitkb-1
   ```

4. **Incidents reference tasks**: After creating fix task, update incident
   ```markdown
   ## Resolution
   Fixed by [[tasks/gitkb-45]]
   ```

### 17. Document Lifecycle Patterns

**Incident Lifecycle:**
```
draft → active → investigating → resolved
```
1. **Create incident** when issue discovered
2. **Document symptoms**, impact, timeline
3. **Investigate** - add findings to document
4. **Create task** when fix is identified, link from incident
5. **Resolve** only after task is completed and verified

**Task Lifecycle:**
```
draft → backlog → active → blocked → completed
```
1. **Create task** with goals and acceptance criteria
2. **Move to active** when starting work
3. **Update document** as you progress
4. **Link commits** after making them
5. **Complete** only after all criteria met and verified

**Spec Lifecycle:**
```
draft → review → active → superseded
```
1. **Create spec** with proposed design
2. **Iterate** based on feedback
3. **Activate** when approved
4. **Supersede** (don't delete) when replaced

### 18. Workspace Discipline

**The Workspace IS Your Focus** - `.kb/workspace/` represents your current working context:
- **Check `kb_status`** before starting - what's already checked out?
- **Checkout what you need** - only documents you're actively working on
- **Commit frequently** - make progress visible
- **Clear when done** - don't let stale docs accumulate

**Resuming Work:**
1. `kb_status` - see what's checked out
2. `kb_diff` - see uncommitted changes
3. Decide:
   - **Continue**: Resume where you left off
   - **Commit first**: Save previous work, then continue
   - **Discard**: `kb_reset` + `kb_clear` for fresh start

**Multi-Agent Coordination** (when multiple agents work concurrently):
1. **Check board first**: `kb_board` to see what's active
2. **Claim explicitly**: Set status to `active` when you start
3. **Commit often**: Make progress visible to others
4. **Release when done**: Update status, clear workspace
