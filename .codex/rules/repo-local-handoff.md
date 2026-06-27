# Repo-local handoff and idea files

When a task asks for `.handoff/.idea`, `.dea`, idea files, handoff notes, or session artifacts, resolve them relative to the active repository root by default:

- Use `$REPO_ROOT/.handoff/.idea` for repo-specific idea/session artifacts.
- Do not use `~/.handoff/.idea` or `$META_ROOT/.handoff/.idea` unless the user explicitly asks for a global/meta-level artifact.
- If the current working directory is nested, find `$REPO_ROOT` with `git rev-parse --show-toplevel` before reading or writing these files.
- If both repo-local and global locations exist, report both and ask only when the intended scope is ambiguous.
