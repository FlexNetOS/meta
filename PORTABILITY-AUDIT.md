# PORTABILITY-AUDIT — everything outside meta, classified

mission: PORTABILITY-SESSION-PROMPT.md · phase: 1 (read-only inventory) · date: 2026-06-12
evidence: `/tmp/recon-portability.out` + `/tmp/portability-sweep.out` (scripts `/tmp/recon-portability.sh`, `/tmp/portability-sweep.sh`)
principle: scope is TOTAL — real file in meta, symlink outside, never the reverse. Sole exemption: IDE applications + their app-managed state.

## Classifications

| class | meaning |
|---|---|
| **link-invert** | source already a meta member → replace external copy with symlink into meta (the `lane` pattern) |
| **internalize** | real config/content outside meta → move into a meta-owned repo + leave symlink at old path |
| **vendor/fork** | external software → genuine FlexNetOS fork registered in `.meta.yaml`, bootstrap installs from it |
| **bootstrap-step** | not symlink-able (nix store, root-owned, installers) → declarative step in the bootstrap |
| **state-stays** | machine-local runtime state (dbs, caches, histories, versions) → recreated by bootstrap, never in git |
| **secret-never** | credentials/tokens/keyrings → NEVER into any repo; bootstrap prompts or envctl relay mints them |
| **exempt-IDE** | per user 2026-06-12: IDE apps + their app-managed state |
| **exempt-system** | OS/desktop platform (GNOME, pulse, snap, apt) — not meta work product |
| **relocate** | work dir outside meta → move into meta (or archive), symlink left behind |

The correct pattern already exists ×3 (template): `~/.local/bin/lane → meta/lane/target/debug/lane`, `n8n-up`/`n8n-down → meta/n8n/scripts/`, `~/.claude/statusline-command.sh → meta/.claude/statusline-command.sh`.

## A. Binaries

### ~/.local/bin (meta-member sources → link-invert)
| binary | source repo (meta member) | class | note |
|---|---|---|---|
| meta, meta-git, meta-mcp, meta-project, loop | meta_cli/meta_git_cli/meta_mcp/meta_project_cli/loop_cli | link-invert | copies dated Jun 2 |
| meta-dashboard | meta_dashboard_cli | link-invert | private repo (NEEDS-HUMAN #3) |
| rtk, rtk-monitor | rtk-tokenkill | link-invert | **self-mutation hazard: live PreToolUse hook** — invert LAST |
| icm | icm | link-invert | **self-mutation hazard: 6 live hooks** — invert LAST |
| vox | vox | link-invert | also a root-owned copy in /usr/local/bin (older twin) |
| git-kb | (FlexNetOS gitkb stack; verify owning repo) | link-invert | 78MB copy, May 27 — likely stale vs source |
| envctl, envctl-gui, envctl-dashboard-pane | envctl | link-invert | |
| kasetto, kst | kasetto | link-invert | DUPLICATE copies also in ~/.cargo/bin (different dates: Jun 5 vs Jun 3) |
| yazelix-gpu-verify.sh, yazelix-gpu-verify-launch.sh | none yet | internalize | belongs in the yazelix meta repo (D1) |
| n8n-open | n8n | internalize | 302-byte script, sibling of already-linked n8n-up/down |

### ~/.local/bin (third-party, NOT exempt — classify per ADR)
| binary | class (proposed) | note |
|---|---|---|
| claude (→ ~/.local/share/claude/versions/2.1.175) | bootstrap-step | self-updating installer; **do not touch live install**; bootstrap = official installer |
| devin, kimi, kimi-cli, kimi-legacy, junie, forge | bootstrap-step | agent CLIs, own updaters/installers |
| mise, uv, uvx | bootstrap-step | toolchain managers; mise already pinned by `meta/.tool-versions` (rust stable) |
| bat, fd, fzf, sqld | bootstrap-step | utilities; sqld also has a systemd unit (B4) |
| node, npm, npx (→ ~/.local/node) | bootstrap-step | node runtime |

### ~/.cargo/bin
| binary | class | note |
|---|---|---|
| weave | **link-invert (STALE — known pre-lease copy)** | canonical = `meta/weave/target/release/weave` |
| kasetto, kst | link-invert | older duplicates of the ~/.local/bin pair |
| grit | link-invert | grit is a meta member |
| secretctl, secretd | link-invert | envctl/secrets stack (verify owning repo: flexnetos_secrets vs envctl) |
| rustup shims (cargo, rustc, …), cargo-{audit,deny,expand,machete,miri,oxide}, git-cliff* | bootstrap-step | rustup + cargo-install tools; declarative list in bootstrap |

### /usr/local/bin (root-owned — bootstrap needs sudo phase)
| binary | class | note |
|---|---|---|
| archon (110MB, drdave-owned!) | link-invert | Archon IS a meta member |
| vox (root copy, Jun 11) | link-invert | twin of ~/.local/bin/vox — one canonical link only |
| yazelix-config.sh, yazelix-setup.sh, yazelix-gpu-verify-install.sh | internalize | → yazelix meta repo (D1); re-link with sudo in bootstrap |
| ollama, determinate-nixd | bootstrap-step | vendor installers (ollama models dir ~/.ollama = state-stays, 20K/empty) |
| ubuntu-boot-repair.sh | internalize | one-off ops script → ops/tools repo |

### ~/Desktop strays (binaries/scripts at top level)
| item | class | note |
|---|---|---|
| weave-x86_64 (Jun 2) | relocate→archive | prehistoric weave binary |
| mcp-broker-server.py | internalize | → mcp_hub or tools repo |
| yazelix-config.sh, yazelix-setup.sh (copies) | internalize | dupes of /usr/local/bin versions — diff first, keep one source in repo |
| ubuntu-boot-repair.sh (copy) | internalize | dupe of /usr/local/bin version |
| n8n.desktop | internalize | → n8n repo + symlink from ~/.local/share/applications |
| autoinstall.yaml | internalize | machine provisioning answer file → bootstrap repo |
| CLAUDE.md, HANDOFF.md, SESSION-HANDOFF.md (Desktop-level, Jun 2-3) | relocate→archive | superseded by meta-root equivalents; archive, don't delete |

## B. Configs

### B1. ~/.claude (agent settings)
| item | class | note |
|---|---|---|
| settings.json | internalize | already half-points into meta (statusline, weave hooks, 2 plugin marketplaces). **Fix while moving: weave hook paths use `target/debug/weave` — canonical is release build.** icm hooks → `~/.local/bin/icm` copy (becomes meta link). |
| CLAUDE.md, RTK.md | internalize | user-global memory/instructions. CAUTION: applies to ALL projects, not just meta — precedence research in ADR before moving. |
| commands/ (recall.md, remember.md, speak.md) | internalize | 3 tiny user commands |
| settings.json.bak, settings.json.weave.bak | relocate→archive | residue |
| .credentials.json, history.jsonl, sessions/, session-env/, file-history/, telemetry/, stats-cache, plugins/cache | secret-never / state-stays | plugins/installed_plugins.json points at meta marketplaces already |

### B2. ~/.config (user configs)
| item | class | note |
|---|---|---|
| yazelix/ (settings.jsonc, configs/, helix/, shell_bash.sh, shell_nu.nu, terminal_ghostty.conf, tombi.toml) | internalize | THE yazelix user config (not a clone). → yazelix meta repo (D1) |
| yazelix_ghostty_cursors/ | internalize | sibling of above |
| nushell/ (config.nu, rtk-wrappers.nu) | internalize | rtk-wrappers.nu is meta-work product; history.txt = state-stays |
| ghostty/ (config.ghostty, empty) | internalize | trivial |
| rtk/ (config.toml, filters.toml) | internalize | rtk runtime config — pairs with rtk-tokenkill repo |
| vox/ (piper/ voices + vox.db) | split | piper voice models = bootstrap-step (download); vox.db = state-stays |
| kasetto/, env-ctl/ | internalize (verify contents) | kasetto config likely = the dotfiles-manager manifest — load-bearing for the ADR |
| git/ignore, gh/config.yml | internalize | gh/hosts.yml = **secret-never** (token) |
| carapace/, turborepo/, openspec/, jgit/, opencode/, devin/, goose+Goose/, github-copilot/ | state-stays / bootstrap-step | tool-managed; classify final in ADR |
| Code/, JetBrains/ (RustRover2026.1), zed/ | **exempt-IDE** | per user directive |
| Claude/ (desktop app) | exempt-IDE-adjacent | app-managed |
| google-chrome, gnome-*, pulse, dconf, evolution, ibus, nautilus, snap-adjacent, transmission, remmina, … | exempt-system | OS/desktop platform |

### B3. Shell rc files
| item | class | note |
|---|---|---|
| ~/.bashrc | internalize (snippet pattern) | contains: 4× duplicated PATH exports, cargo env, nix-daemon source, **"yazelix auto-enter" block added by envctl** → meta-owned `shell.d` sourced by one line; dedupe PATH while at it |
| ~/.profile, ~/.zshrc | internalize (same pattern) | |
| .bashrc.bak.× 9, .zshrc.bak.× 3 | relocate→archive | hook/installer residue |
| ~/.gitconfig, ~/.ideavimrc | internalize / exempt-IDE | .ideavimrc is IDE config — user call; default exempt |

### B4. systemd user units (~/.config/systemd/user)
| unit | class | note |
|---|---|---|
| env-ctl.service (enabled) | internalize | + .bak residue → archive |
| repowire.service (enabled) | internalize | verify owning repo (envctl stack?) |
| sqld.service (enabled) | internalize | ExecStart paths must point at meta-linked binaries after inversion |
| crontab | n/a | none exists |

### B5. nix layer
| item | class | note |
|---|---|---|
| nix profile: yazelix (github:luccahuguet/yazelix @ e60d15e) | vendor/fork + bootstrap-step | fork → FlexNetOS/yazelix, register in .meta.yaml, bootstrap installs `nix profile install github:FlexNetOS/yazelix` (or local flake path) — upstream-pin policy applies |
| nix profile: home-manager (nixpkgs pinned) | bootstrap-step | record exact pin in bootstrap |
| determinate-nixd (/usr/local/bin) | bootstrap-step | nix installer itself = first bootstrap step |

## C. Work dirs (scope-is-total sweep)

| dir | class | note |
|---|---|---|
| ~/Desktop/workspaces/Devin/ | relocate | agent workspace → meta (or archive if dead) |
| ~/Desktop/workspaces/RustRover-2026.1.2/ | **exempt-IDE** | IDE install itself |
| ~/Desktop/meta.worktrees/, ~/Desktop/.meta-worktrees/ | relocate→archive | both EMPTY — residue of old worktree layouts |
| ~/Desktop/_archives/ | stays (register policy) | the safety net (weave prune SHAs live here); policy: archives are machine-local, listed in audit, never in git |
| ~/Downloads/tmp/{brainery, cli_hub, env-config, handoff, github, browser, media, notes, extracted, .archive, *.zip} | relocate per-dir (ADR) | `handoff` = the FORGOTTEN-DIRECTIVE cross-ref (diff vs meta/handoff for lite-version check) — do NOT archive blindly; `env-config` likely prior art for THIS mission — read before ADR |
| ~/.codex/{memories,.tmp/plugins} (git clones) | internalize/relocate | codex agent state with embedded git repos |
| ~/java_error_in_rustrover.hprof (3.2GB!) | exempt-IDE artifact | flag to human: 3.2GB heap dump, deletion is human's call |
| ~/Desktop/meta (86 entries) + ~/.cargo/{registry,git,advisory-db*}, ~/.rustup | home / state-stays | the workspace itself + toolchain caches |

## D. Implementation targets (feeds Phase 2/3)

1. **D1 — yazelix repo**: new meta child (fork github:luccahuguet/yazelix → FlexNetOS/yazelix per fork lessons) + a config overlay dir (current ~/.config/yazelix contents) — exact split decided in ADR (upstream flake vs config-overlay repo vs both).
2. **D2 — env/dotfiles home**: where internalized configs live. Candidates: envctl repo (already owns env materialization + wrote the bashrc block), kasetto (upstream pivoshenko/kasetto is a dotfiles manager; fork already registered; `kasetto sync --locked` already referenced by HFTASK-0007), or a new `dotfiles`/`env_home` repo. **ADR must research kasetto + envctl capabilities first — the linker may already be owned.**
3. **D3 — bootstrap entrypoint**: scripts/bootstrap.sh at meta root vs `meta env` subcommand vs kasetto-driven. Stages: (0) nix + rustup + installers, (1) clone/`meta git update`, (2) build workspace, (3) link binaries, (4) link configs, (5) systemd units, (6) verify. Idempotent; archives collisions to ~/Desktop/_archives/<name>-<date>/.
4. **D4 — binary link-inversion list**: §A rows marked link-invert (~20 binaries; rtk/icm/claude-adjacent LAST).
5. **D5 — relocations**: §C rows (per-dir ADR decisions).

## Gaps / risks / honest notes

- `git-kb` 78MB binary (May 27) — owning source repo not yet pinned down (gitkb stack was migrated INTO FlexNetOS; verify which repo builds it; it predates the meta migration?).
- `settings.json` weave hooks → `target/debug/weave` while the canonical loop binary is the **release** build — decide one (likely release) during B1 inversion.
- kst/kasetto exist as 2 copy-generations (~/.local/bin Jun 5, ~/.cargo/bin Jun 3) — inversion kills the drift class permanently.
- vox exists 3× (~/.local/bin, /usr/local/bin root-owned, + source repo) — same.
- `/usr/local/bin` items need a sudo phase in bootstrap (or relocation to ~/.local/bin) — ADR call.
- PATH has 6 duplicate `~/.local/bin` entries + claude-plugin cache paths + `meta/harness_hub/harness/bin` (a meta path already on PATH — precedent for meta-owned PATH dirs).
- Piper voice models + ollama models are multi-GB downloads → bootstrap downloads, never git.
- Secrets inventory (never in git): ~/.claude/.credentials.json, ~/.config/gh/hosts.yml, keyrings, env-ctl/ secret material → envctl relay/minting is the sanctioned channel (forgotten-directive #1).
- This phase changed NOTHING. All mutations wait for the ADR + worktrees.

---

## APPLIED (phase 3, 2026-06-12 evening) — live state after the first inversion wave

**40 symlinks now point into meta (was 3).** Archive of every displaced original:
`~/Desktop/_archives/home-links-2026-06-12/`.

- **Configs linked (18)**: .gitconfig, ghostty, nushell (config.nu + rtk-wrappers.nu), kasetto global
  yaml, yazelix user config (7 files), systemd units (env-ctl, sqld, repowire), home/bin scripts (3).
- **Claude global linked (6)**: settings.json (weave hooks now → release build), CLAUDE.md, RTK.md,
  commands ×3 (speak.md fixed: `vox -b piper`). Smoke: JSON parses, claude --version OK; definitive
  proof = next session start.
- **Binaries linked (15)**: meta, meta-git, meta-project, loop, lane (debug→release), grit, envctl,
  envctl-gui, meta-dashboard, icm (0.10.50=0.10.50), vox (0.14.0=0.14.0); cargo-bin: weave (stale
  copy KILLED — lease verbs now present, HF_WEAVE_BIN workaround obsolete), grit, secretctl, secretd.
- **Version guard fired correctly**: rtk SKIPPED — installed 0.42.2 > repo build 0.42.0 (the
  rtk-tokenkill checkout is behind the installed binary; sync + rebuild + re-run to converge).
- **kasetto/kst SKIPPED**: local build blocked until the root `workspace.exclude` lands (this PR).
- **repowire**: unit disabled (was crash-looping on a missing binary, 268MB log) →
  `incidents/repowire-unit-crash-loop`. Unit file is meta-owned + linked, state `linked/inactive`.
- **Gotcha learned**: `systemctl --user disable` DELETES a symlinked unit file (treats it as a
  linked unit) — disable first, link after; the component scripts must handle re-linking.
- **Daemons survived the conversion**: env-ctl + sqld enabled/active throughout.

**Phase-4 proof (partial, honest)**: branch clone carries bootstrap+audit+registrations; bootstrap
`--dry-run --phase 0` runs; zero dangling links across ~/.local/bin, ~/.cargo/bin, ~/.config,
~/.claude. NOT yet proven: full `envctl install` materialization on a virgin `$HOME`.

**Remaining residue (next wave)**: rtk checkout sync; meta-mcp + kasetto/kst release builds + links;
/usr/local/bin sudo phase (archon, vox root copy, yazelix-* root scripts); absolute-path
substitution in settings.json/config.nu/shell_bash.sh; work-dir relocations (§C — Downloads/tmp
pending the handoff cross-ref directive); bashrc legacy PATH dedupe; `wiring.symlink` engine kind
(Feature Forge); meta_mcp release build.
