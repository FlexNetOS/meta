# Codex Rules (Harmony)

## GitKB First

- For non-trivial work, create or update a GitKB document before coding.
- Use `git-kb` for tasks, context, and traceability.

## Code Intelligence

- Do not use grep to find callers/definitions.
- Use GitKB code tools (`kb_callers`, `git-kb code callers "<symbol>" --json`, etc.).
- Use `--json` for every GitKB command that supports it when discovering slugs, IDs, symbols, relationships, or task state.

## Local-First CI

- Run heavy validation locally first with scoped `meta exec`; treat GitHub Actions as a receipt for the exact pushed commit.
- Keep default PR/push CI lightweight unless a release tag, `workflow_dispatch`, approved label, scheduled job, self-hosted runner route, or explicit operator task requests full validation.
- Do not add token-consuming AI/Codex/OpenAI checks to default GitHub CI. Gate them explicitly.

## Bootstrap Semantics

- `git-kb init` creates/configures a repository KB.
- `git-kb init codex` installs GitKB Codex integration files.
- `meta init` owns Meta integration bootstrap; current `meta 0.2.22` exposes `meta init claude`.
- `meta exec -- <cmd>` only runs `<cmd>` across selected repos. There is no `meta exec init` subcommand.

## Commit Discipline

- Always scope `git-kb commit` with pathspecs.
- Include task slugs in commit messages (e.g., `[[tasks/<task-slug>]]`).
