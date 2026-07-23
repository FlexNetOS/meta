---
id: 019f21c2-89ff-7e00-a898-83a1625f44d9
slug: tasks/meta-diff-claude-to-codex-wiring
title: "Extract Claude integration and diff missing Codex wiring"
type: task
status: draft
priority: high
---

# Summary
Extract the current .claude integration, compare it against the generated .codex integration, and produce diffs showing what is missing before adding any Codex wiring. Add only supported, non-conflicting Codex files after the diff is understood.

# Scope
- Source surface: .claude/ agents, commands, rules, settings, and skills.
- Target surface: .codex/ instructions, skills, and any supported Codex config/hook mechanism.
- Preserve Claude behavior; do not mutate .claude except to read and compare.
- Do not invent unsupported Codex structure.

# Acceptance Criteria
- [ ] Inventory .claude/ at full depth with file list and purpose categories.
- [ ] Inventory .codex/ at full depth with file list and purpose categories.
- [ ] Produce a Claude-to-Codex diff report showing missing rules, skills, commands/workflows, settings, and hooks.
- [ ] Identify which .claude settings/hooks have a supported Codex equivalent and which do not.
- [ ] Add missing Codex instructions/skills/config only where supported and non-conflicting.
- [ ] Record any unsupported hook or automation parity gaps as separate KB tasks.
- [ ] Verify generated .codex files are readable, symlinks resolve, and no .claude files were changed.
- [ ] Commit changes with evidence and update this task.