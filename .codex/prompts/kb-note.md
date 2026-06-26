---
description: Create a durable FlexNetOS note in meta/.kb.
argument-hint: TITLE="note title" [SLUG="notes/slug"] [BODY="note body"]
---

Create a durable git-kb note in the FlexNetOS meta knowledge base.

Inputs:
- `TITLE` is required.
- `SLUG` is optional. If omitted, derive a kebab-case slug from `TITLE`.
- `BODY` is optional. If omitted, ask once for the note body unless the user already provided enough content.

Rules:
1. Operate from `/home/drdave/Desktop/meta` or the active meta worktree; never create loose notes outside the repo KB.
2. Prefer the git-kb MCP document-create tool when it is available. CLI fallback:
   ```bash
   git kb create note --slug "$SLUG" --title "$TITLE" --body "$BODY" --tags codex,note --json
   ```
3. Normalize note slugs under `notes/`. If the user provides `foo`, use `notes/foo`; if they provide `notes/foo`, keep it. Do not use task/spec/context paths for notes.
4. Commit the KB workspace after the note is created:
   ```bash
   git kb commit -m "docs(kb): add note $SLUG"
   ```
5. Verify repo durability before reporting done:
   ```bash
   bash scripts/check-kb-store-tracked.sh
   git status --short .kb/store .kb/config.toml .kb/AGENTS.md
   ```
6. If durable `.kb/store/**` files changed, include them in the normal git commit/PR for the note-capture change or explicitly report the exact files that still need to be committed. Never leave `.kb/store` as invisible or ignored state.

Completion response: include the created slug, the KB commit message, and whether `.kb/store` is clean or which durable files remain to be committed.
