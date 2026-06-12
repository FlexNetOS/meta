# Strict Upgrade Rule Notes

The executable Codex rule file is `.codex/rules/strict-upgrade.rules`.
This Markdown file explains the intent for humans and agent context.

When `.claude/settings.json`, root `Cargo.lock`, or child repo manifests are dirty:

1. Assume upgrade intent first.
2. Inspect diffs and related manifests before recommending any cleanup.
3. Preserve intended upgrade changes.
4. Fix missing companion changes.
5. Validate with the narrowest relevant parser, inventory, build, or test command.
6. Mention rollback only when the user explicitly asks for rollback or evidence proves the dirty state is accidental.

For this workspace, `.claude/settings.json` push permissions and root `Cargo.lock` upgrade drift are intentional.
