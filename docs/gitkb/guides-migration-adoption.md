<!-- Source: https://gitkb.com/docs/guides/migration/ -->
<!-- Snapshot: 2026-07-02 -->

# Migration &  Adoption

## Adding GitKB to a project

Two commands, then let your AI assistant take over:

```
git-kb init
git-kb init claude
```

For Codex, use the Codex harness instead:

```
git-kb init
git-kb init codex
```

Live verification in this repository, 2026-07-02: this KB is already initialized. Re-running `git-kb init --remote https://gitkb.com/my-org/my-kb --no-verify` returned `Knowledge base already initialized` and made no file changes. Use `git-kb init <harness> --dry-run` before writing harness files into an existing repo.

Then open Claude Code (or your MCP-connected editor) and write:

>

“We just added GitKB to help guide project development. Help me bootstrap it.”

That’s it. GitKB’s skills and prompts guide the agent through creating context documents, understanding your project, and setting up structured task management. The agent asks about your project — what it does, who it’s for, what decisions you’ve made — and populates the knowledge base from your answers.

From that point forward, every agent session loads your project context first, works with full awareness of your architecture and decisions, and updates the KB as things change. The knowledge compounds over time — each session leaves the project better documented than it found it.

## What the bootstrapping creates

The agent creates context documents organized by how often they change:

| Level | What it captures | How often it changes |
| --- | --- | --- |
| Immutable | Project brief, architecture, design patterns | Rarely — foundational decisions |
| Extensible | Product context, tech stack details | As the project evolves |
| Overridable | Active work focus, progress, blockers | Every session |

These documents become the persistent memory that agents and humans share. New team members pull context documents and immediately understand the project. Agents load them at the start of every session and never start cold again.

Local verification: `git-kb list --type context --json` currently returns four context documents: `context/overridable/active`, `context/overridable/progress`, `context/extensible/product`, and `context/extensible/tech`. The immutable context documents are present in the board output but are currently typed/loaded differently than this command's `type=context` filter, so agents should use `git-kb context` or explicit slugs when bootstrapping rather than assuming one list filter contains every context-level document.

## Coming from other tools

GitKB isn’t a replacement for your issue tracker or wiki — it’s the technical knowledge layer that sits closer to the code. Use GitKB for the context that agents need to do their work effectively: architecture decisions, design patterns, task context with acceptance criteria, incident investigations, and the living record of how your project evolves.

Your existing tools (Jira, Linear, Notion, Confluence) continue to serve their purpose. GitKB serves the purpose that none of them can: giving AI agents precise, structured, code-connected context for the task at hand.

## Team rollout

### Setting up sync

Push your KB to a remote so the team can access it:

```
git-kb remote add origin https://gitkb.com/my-org/my-kb
git-kb push origin
```

Each team member pulls only the documents they need:

```
git-kb pull origin 'context/*'
```

For the FlexNetOS `meta` checkout, do not add or push to a remote until the
remote target is explicitly approved. The local policy is tracked in
[[tasks/meta-gitkb-sync-auth-remote-policy]].

Live verification in this repository:

- `git-kb remote list` reports no configured remotes.
- `git-kb auth status` reports default cloud domain `gitkb.com`, `GITKB_DOMAIN` unset, and active cloud domain `gitkb.com`.
- `tasks/meta-gitkb-sync-auth-remote-policy` is completed and says this KB remains local-only until the user approves a concrete FlexNetOS org/remote target.
- Do not copy generic examples such as `https://gitkb.com/my-org/my-kb` into `.kb/config.toml` for this checkout.

### Per-developer setup

Each developer needs:

1. GitKB installed

2. MCP configured  in their editor

3. `git-kb init`  and ` git-kb pull`  to bootstrap their local KB

The agent guides them from there — same as it guided you.

Harness dry-run proof in this repository:

- `git-kb init claude --dry-run` would create 14 missing `.claude/skills/*` adapter symlinks and skip 42 existing assets.
- `git-kb init codex --dry-run` would skip 53 existing assets, including `.codex/skills/*` symlinks and `.codex/instructions/*`.
- These dry-runs did not mutate the repository. Do not run the non-dry-run harness initializers here until the Claude retirement/meta-plugin work explicitly approves the target adapter state.

## Next steps

- Quick Start  — Create your first documents

- Configuration  — Customize your setup

- Team Collaboration  — Sparse sync and multi-agent coordination

- Agent Workflows  — How AI agents use GitKB
