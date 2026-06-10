#!/usr/bin/env bash
# Claude Code status line — rich contextual one-liner
# Layout: repo/remote/branch[@wt]   task · PR · loop   ctx-bar · git · meta · rtk icm   net · gh · svc   model

set -euo pipefail

json=$(cat)

# ── Parse JSON fields ─────────────────────────────────
model=$(echo "$json"        | jq -r '.model.display_name // "cli"'                  2>/dev/null)
repo_obj=$(echo "$json"     | jq -r '.workspace.repo // empty'                      2>/dev/null)
used_pct=$(echo "$json"     | jq -r '.context_window.used_percentage // empty'      2>/dev/null)
total_in=$(echo "$json"     | jq -r '.context_window.total_input_tokens // empty'   2>/dev/null)
total_out=$(echo "$json"    | jq -r '.context_window.total_output_tokens // empty'  2>/dev/null)
cwd_json=$(echo "$json"     | jq -r '.cwd // empty'                                 2>/dev/null)

# repo identity
if [ -n "$repo_obj" ]; then
  repo=$(echo "$json" | jq -r '.workspace.repo.name // empty' 2>/dev/null)
else
  repo=""
fi
if [ -z "$repo" ]; then
  _top=$(git rev-parse --show-toplevel 2>/dev/null) || _top=""
  if [ -n "$_top" ]; then repo=$(basename "$_top"); fi
fi
[ -z "$repo" ] && repo="?"

# ── Colors ────────────────────────────────────────────
ESC=$'\033'
magenta="${ESC}[01;35m"
dim="${ESC}[02;37m"
yellow="${ESC}[01;33m"
green="${ESC}[01;32m"
red="${ESC}[01;31m"
cyan="${ESC}[01;36m"
orange="${ESC}[38;5;208m"
reset="${ESC}[0m"

# ── Branch + remote ───────────────────────────────────
branch=$(git -c gc.auto=0 branch --show-current 2>/dev/null) || true
branch=${branch:-?}
remote=$(git config --get branch."${branch}".remote 2>/dev/null \
         || git remote 2>/dev/null | head -1) || true
remote=${remote:-origin}

# ── Worktree label ────────────────────────────────────
wt=""
wt_json=$(echo "$json" | jq -r '.worktree.name // empty' 2>/dev/null)
if [ -n "$wt_json" ]; then
  wt="@${wt_json}"
else
  main_wt=$(git -c gc.auto=0 worktree list --porcelain 2>/dev/null \
            | sed -n 's/^worktree //p' | head -1) || true
  my_real=$(pwd -P 2>/dev/null)
  main_real=$(cd "$main_wt" 2>/dev/null && pwd -P) || true
  if [ -n "$main_real" ] && [ "$my_real" != "$main_real" ]; then
    wt="@$(basename "$my_real")"
  fi
fi
git_wt=$(echo "$json" | jq -r '.workspace.git_worktree // empty' 2>/dev/null)
[ -z "$wt" ] && [ -n "$git_wt" ] && wt="@${git_wt}"

# ── KB current task (active, highest priority) ────────
task_label=""
tb=$(git -c gc.auto=0 kb board 2>/dev/null) || true
if [ -n "$tb" ]; then
  active_line=$(echo "$tb" | grep -i 'active\|▶\|→' | head -1 2>/dev/null) || true
  [ -z "$active_line" ] && active_line=$(echo "$tb" | grep '\[' | head -1 2>/dev/null) || true
  if [ -n "$active_line" ]; then
    slug=$(echo "$active_line" | grep -oP '[\w-]+/[\w-]+' | tail -1 2>/dev/null) || true
    short=${slug##*/}
    count=$(echo "$tb" | grep -c '\[' 2>/dev/null) || count=0
    if [ -n "$short" ]; then
      task_label="${yellow}${short}${reset}"
      [ "$count" -gt 1 ] && task_label="${task_label}${dim}+$((count-1))${reset}"
    fi
  fi
fi

# ── PR: #N[state] ─────────────────────────────────────
pr=""
pr_json=$(echo "$json" | jq -r '.pr.number // empty' 2>/dev/null)
if [ -n "$pr_json" ]; then
  pr_state=$(echo "$json" | jq -r '.pr.review_state // "open"' 2>/dev/null)
  case "$pr_state" in
    approved)          pr="${green}#${pr_json}[A]${reset}" ;;
    changes_requested) pr="${red}#${pr_json}[CR]${reset}" ;;
    draft)             pr="${dim}#${pr_json}[D]${reset}" ;;
    *)                 pr="${green}#${pr_json}[O]${reset}" ;;
  esac
elif [ -n "$repo_obj" ] && command -v gh &>/dev/null; then
  pr_line=$(gh pr list --state any --limit 1 \
            --head "$branch" \
            --format '{{.number}}|{{.state}}' 2>/dev/null | head -1) || true
  if [ -n "$pr_line" ]; then
    pnum=$(echo "$pr_line" | cut -d'|' -f1)
    pstate=$(echo "$pr_line" | cut -d'|' -f2)
    case "$pstate" in
      OPEN) pr="${green}#${pnum}[O]${reset}" ;;
      *)    pr="${dim}#${pnum}[${pstate}]${reset}" ;;
    esac
  fi
fi

# ── Lane-loop indicator ───────────────────────────────
ll=""
if [ -f "_workspace/HANDOFF.md" ]; then
  ll="${cyan}LL:res${reset}"
elif ls _workspace/commits/*.md 2>/dev/null | head -1 &>/dev/null; then
  last=$(ls -t _workspace/commits/*.md 2>/dev/null | head -1) || true
  last=${last##*/}; last=${last%.md}
  [ -n "${last#_}" ] && ll="${cyan}LL:${last:0:8}${reset}"
fi

# ── Context usage bar ─────────────────────────────────
# Renders a 5-block bar: ▰▰▱▱▱  colored green/orange/red by threshold
ctx_display=""
if [ -n "$used_pct" ]; then
  pct_int=$(printf '%.0f' "$used_pct" 2>/dev/null) || pct_int=0
  if [ "$pct_int" -ge 80 ]; then
    ctx_color="$red"
  elif [ "$pct_int" -ge 50 ]; then
    ctx_color="$orange"
  else
    ctx_color="$green"
  fi
  # 5-block bar: each block = 20%
  filled=$(( pct_int / 20 ))
  [ "$filled" -gt 5 ] && filled=5
  bar=""
  for i in 1 2 3 4 5; do
    if [ "$i" -le "$filled" ]; then
      bar="${bar}▰"
    else
      bar="${bar}▱"
    fi
  done
  ctx_display="${ctx_color}${bar} ${pct_int}%${reset}"
fi

# ── Token counts ──────────────────────────────────────
tok_display=""
if [ -n "$total_in" ] && [ "$total_in" != "null" ]; then
  fmt_k() {
    local n=$1
    if [ "$n" -ge 1000 ]; then printf '%dk' "$((n / 1000))"; else printf '%d' "$n"; fi
  }
  in_fmt=$(fmt_k "$total_in")
  if [ -n "$total_out" ] && [ "$total_out" != "null" ] && [ "$total_out" -gt 0 ]; then
    out_fmt=$(fmt_k "$total_out")
    tok_display="${dim}↑${in_fmt} ↓${out_fmt}${reset}"
  else
    tok_display="${dim}↑${in_fmt}${reset}"
  fi
fi

# ── Git dirty + ahead/behind indicator ───────────────
# Source: `git status --porcelain` + `git rev-list` — fast, local-only.
# Shows: ±N for modified files, ↑M↓K for ahead/behind. Green check when clean+synced.
git_dirty=""
if git rev-parse --git-dir &>/dev/null 2>&1; then
  mod_count=$(git -c gc.auto=0 status --porcelain 2>/dev/null | wc -l | tr -d ' ') || mod_count=0
  # ahead/behind vs tracking branch (no network — uses local refs only)
  ab=""
  tracking=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null) || tracking=""
  if [ -n "$tracking" ]; then
    ahead=$(git -c gc.auto=0 rev-list --count "${tracking}..HEAD" 2>/dev/null) || ahead=0
    behind=$(git -c gc.auto=0 rev-list --count "HEAD..${tracking}" 2>/dev/null) || behind=0
    [ "$ahead"  -gt 0 ] && ab="${ab}↑${ahead}"
    [ "$behind" -gt 0 ] && ab="${ab}↓${behind}"
  fi
  if [ "$mod_count" -eq 0 ] && [ -z "$ab" ]; then
    git_dirty="${green}✓${reset}"
  else
    parts=""
    [ "$mod_count" -gt 0 ] && parts="${orange}±${mod_count}${reset}"
    [ -n "$ab" ] && parts="${parts}${dim}${ab}${reset}"
    git_dirty="$parts"
  fi
fi

# ── Meta workspace dirty-repo count ──────────────────
# Hot path: read cached dirty count from a file; render instantly.
# Background: after rendering, spawn a detached job (TTL=8s) that runs
#   `git status --porcelain` per child repo and atomically refreshes the cache.
# Cache layout:
#   ~/.cache/claude-statusline/meta-health   — plain integer (dirty count)
#   ~/.cache/claude-statusline/meta-health.lock/ — mkdir-based lock directory

meta_badge=""
meta_yaml="${cwd_json:-$(pwd)}/.meta.yaml"
proj_dir=$(echo "$json" | jq -r '.workspace.project_dir // empty' 2>/dev/null)
[ ! -f "$meta_yaml" ] && [ -n "$proj_dir" ] && meta_yaml="${proj_dir}/.meta.yaml"

if [ -f "$meta_yaml" ]; then
  _cache_dir="${HOME}/.cache/claude-statusline"
  _cache_file="${_cache_dir}/meta-health"
  _lock_dir="${_cache_dir}/meta-health.lock"
  _ttl=8   # seconds before a background refresh is triggered

  # Ensure cache directory exists (silent, no-op if already present)
  mkdir -p "$_cache_dir" 2>/dev/null || true

  # ── SYNCHRONOUS HOT PATH: read cache ──
  _cached_val=""
  if [ -f "$_cache_file" ]; then
    _cached_val=$(<"$_cache_file") 2>/dev/null || _cached_val=""
  fi

  if [ -z "$_cached_val" ]; then
    # Cache file absent — first run; show pending placeholder
    meta_badge="${dim}meta:…${reset}"
  else
    # Guard: only coerce to int if the cached value looks numeric
    case "$_cached_val" in
      ''|*[!0-9]*) _n=0 ;;
      *) _n=$(( _cached_val + 0 )) ;;
    esac
    if [ "$_n" -gt 0 ]; then
      meta_badge="${orange}meta:${_n}✎${reset}"
    else
      meta_badge="${dim}meta:✓${reset}"
    fi
  fi

  # ── BACKGROUND REFRESH (throttled, non-blocking) ──
  # Trigger only when cache is missing OR older than TTL seconds.
  _needs_refresh=0
  if [ ! -f "$_cache_file" ]; then
    _needs_refresh=1
  else
    # Portable mtime age check using find (works on Linux & macOS)
    _stale=$(find "$_cache_file" -mmin +"$(awk "BEGIN{printf \"%.4f\", $_ttl/60}")" 2>/dev/null) || _stale=""
    [ -n "$_stale" ] && _needs_refresh=1
  fi

  if [ "$_needs_refresh" -eq 1 ]; then
    # Acquire mkdir-based lock (atomic on Linux); if lock already held, skip.
    if mkdir "$_lock_dir" 2>/dev/null; then
      # Capture variables needed inside the subshell before forking.
      _bg_meta_yaml="$meta_yaml"
      _bg_proj_dir="${proj_dir:-$(pwd)}"
      _bg_cache_file="$_cache_file"
      _bg_lock_dir="$_lock_dir"

      (
        # Release lock on any exit (normal or error)
        trap 'rmdir "$_bg_lock_dir" 2>/dev/null || true' EXIT

        _dirty=0
        # Parse project names from .meta.yaml: lines with exactly 2-space indent
        # followed by a word (key), colon, and optional space.
        while IFS= read -r _line; do
          if printf '%s' "$_line" | grep -qP '^\s{2}[\w_-]+\s*:'; then
            _rname=$(printf '%s' "$_line" | grep -oP '[\w_-]+(?=\s*:)')
            _rdir="${_bg_proj_dir}/${_rname}"
            if [ -d "${_rdir}/.git" ]; then
              # Accurate check: porcelain output non-empty means dirty.
              # --no-optional-locks avoids writing lock files from a background job.
              _out=$(git -C "$_rdir" \
                         -c gc.auto=0 \
                         status --porcelain \
                         --no-optional-locks \
                         2>/dev/null) || _out=""
              [ -n "$_out" ] && _dirty=$(( _dirty + 1 ))
            fi
          fi
        done < "$_bg_meta_yaml"

        # Atomic write: write to temp then rename so the hot path never reads a partial file.
        _tmp="${_bg_cache_file}.tmp.$$"
        printf '%d' "$_dirty" > "$_tmp" && mv "$_tmp" "$_bg_cache_file" || rm -f "$_tmp"
      ) </dev/null &>/dev/null &
      disown $! 2>/dev/null || true
    fi
  fi
fi

# ── rtk token savings ─────────────────────────────────
# Runs `rtk gain` with a 80ms timeout. On success parses the headline %.
# Falls back to a plain green/red binary badge if rtk is absent or slow.
rtk_badge=""
if command -v rtk &>/dev/null; then
  # try to get savings number quickly
  rtk_out=$(timeout 0.08 rtk gain 2>/dev/null) || rtk_out=""
  if [ -n "$rtk_out" ]; then
    # look for a line like "Overall savings: 87%" or "87%" anywhere
    savings=$(echo "$rtk_out" \
      | grep -oP '\d+(?=%)' \
      | sort -rn | head -1 2>/dev/null) || savings=""
    if [ -n "$savings" ]; then
      rtk_badge="${green}rtk ${savings}%${reset}"
    else
      rtk_badge="${green}rtk${reset}"
    fi
  else
    rtk_badge="${green}rtk${reset}"
  fi
else
  rtk_badge="${red}rtk${reset}"
fi

# ── ICM injection live check ──────────────────────────
# Green only when BOTH:
#   (a) the icm binary exists AND is executable
#   (b) at least one of the injection hooks (SessionStart/UserPromptSubmit/PreToolUse)
#       referencing "icm hook" is wired in ~/.claude/settings.json
# Parse settings.json with jq; grep fallback if jq absent.
icm_badge=""
icm_bin="/home/drdave/.local/bin/icm"
settings_file="/home/drdave/.claude/settings.json"
icm_bin_ok=0
icm_hook_ok=0
[ -x "$icm_bin" ] && icm_bin_ok=1
if [ -f "$settings_file" ]; then
  if command -v jq &>/dev/null; then
    # Check for any hook command containing "icm hook" under the injection-relevant events
    hook_count=$(jq -r '
      [
        .hooks.SessionStart,
        .hooks.UserPromptSubmit,
        .hooks.PreToolUse
      ]
      | map(select(. != null))
      | flatten
      | map(.hooks // [])
      | flatten
      | map(select(.command? | strings | test("icm hook")))
      | length
    ' "$settings_file" 2>/dev/null) || hook_count=0
    [ "${hook_count:-0}" -gt 0 ] && icm_hook_ok=1
  else
    # grep fallback: look for icm hook in the file
    grep -q 'icm hook' "$settings_file" 2>/dev/null && icm_hook_ok=1
  fi
fi
if [ "$icm_bin_ok" -eq 1 ] && [ "$icm_hook_ok" -eq 1 ]; then
  icm_badge="${green}icm${reset}"
else
  icm_badge="${red}icm${reset}"
fi

# ══════════════════════════════════════════════════════
# NETWORK / SERVICE SEGMENTS
# Hot path: ONLY reads cache files — never probes.
# Background refreshes are spawned (non-blocking, lock-guarded) when the
# cache is absent or older than the segment's TTL.
# Cache dir: ~/.cache/claude-statusline/
# Files:
#   net-status   — connectivity + latency badge  (TTL 15s)
#   gh-rate      — GitHub API rate-limit badge   (TTL 60s)
#   svc-status   — local daemon health badge     (TTL 10s)
# ══════════════════════════════════════════════════════

_sl_cache_dir="${HOME}/.cache/claude-statusline"
mkdir -p "$_sl_cache_dir" 2>/dev/null || true

# ── Helper: should we refresh? ────────────────────────
# Usage: _sl_needs_refresh <cache_file> <ttl_seconds>
# Sets _sl_do_refresh=1 if file absent or older than TTL.
_sl_do_refresh=0
_sl_check_ttl() {
  local _f="$1" _ttl="$2"
  _sl_do_refresh=0
  if [ ! -f "$_f" ]; then
    _sl_do_refresh=1
  else
    local _stale
    _stale=$(find "$_f" -mmin +"$(awk "BEGIN{printf \"%.6f\", $_ttl/60}")" 2>/dev/null) || _stale=""
    if [ -n "$_stale" ]; then _sl_do_refresh=1; fi
  fi
  return 0
}

# ── SEGMENT 1 — Connectivity + latency ───────────────
# Cache: net-status   TTL: 15s
# Probe (background): curl -s -o /dev/null -w '%{time_total}' --max-time 2 https://api.github.com/zen
# Result file: raw seconds as float, or "fail" on error.
# Render: green net:NNms (<150ms), orange (150-999ms), red net:✗ (fail/timeout).
net_badge=""
_net_cache="${_sl_cache_dir}/net-status"
_net_lock="${_sl_cache_dir}/net-status.lock"
_net_ttl=15

# Hot path: read cache
_net_val=""
[ -f "$_net_cache" ] && _net_val=$(<"$_net_cache") 2>/dev/null || true

if [ -z "$_net_val" ]; then
  net_badge="${dim}net:...${reset}"
else
  case "$_net_val" in
    fail|FAIL)
      net_badge="${red}net:X${reset}" ;;
    *)
      # Convert seconds (e.g. 0.048321) to integer ms
      _ms=$(awk "BEGIN{printf \"%d\", $_net_val * 1000 + 0.5}" 2>/dev/null) || _ms=0
      if [ "$_ms" -lt 150 ]; then
        net_badge="${green}net:${_ms}ms${reset}"
      elif [ "$_ms" -lt 1000 ]; then
        net_badge="${orange}net:${_ms}ms${reset}"
      else
        net_badge="${red}net:X${reset}"
      fi
      ;;
  esac
fi

# Background refresh
_sl_check_ttl "$_net_cache" "$_net_ttl"
if [ "$_sl_do_refresh" -eq 1 ]; then
  if mkdir "$_net_lock" 2>/dev/null; then
    _bg_nc="$_net_cache" _bg_nl="$_net_lock"
    (
      trap 'rmdir "$_bg_nl" 2>/dev/null || true' EXIT
      _t=$(curl -s -o /dev/null -w '%{time_total}' --max-time 2 \
             https://api.github.com/zen 2>/dev/null) || _t=""
      if [ -z "$_t" ] || [ "$_t" = "0" ] || [ "$_t" = "0.000000" ]; then
        _t="fail"
      fi
      _tmp="${_bg_nc}.tmp.$$"
      printf '%s' "$_t" > "$_tmp" && mv "$_tmp" "$_bg_nc" || rm -f "$_tmp"
    ) </dev/null &>/dev/null &
    disown $! 2>/dev/null || true
  fi
fi

# ── SEGMENT 2 — GitHub API health + rate limit ───────
# Cache: gh-rate   TTL: 60s
# Probe (background): timeout 3 gh api rate_limit --jq '.resources.core.remaining'
# Result file: integer remaining, or "fail" on error.
# Render: green gh:NNN (>1000), orange (100-1000), red gh:✗ (fail/<100).
# Omit entirely if gh binary absent.
gh_badge=""
if command -v gh &>/dev/null; then
  _gh_cache="${_sl_cache_dir}/gh-rate"
  _gh_lock="${_sl_cache_dir}/gh-rate.lock"
  _gh_ttl=60

  # Hot path: read cache
  _gh_val=""
  [ -f "$_gh_cache" ] && _gh_val=$(<"$_gh_cache") 2>/dev/null || true

  if [ -z "$_gh_val" ]; then
    gh_badge="${dim}gh:...${reset}"
  else
    case "$_gh_val" in
      fail|FAIL)
        gh_badge="${red}gh:X${reset}" ;;
      *)
        case "$_gh_val" in
          ''|*[!0-9]*) _ghn=0 ;;
          *) _ghn=$(( _gh_val + 0 )) ;;
        esac
        if [ "$_ghn" -gt 1000 ]; then
          gh_badge="${green}gh:${_ghn}${reset}"
        elif [ "$_ghn" -ge 100 ]; then
          gh_badge="${orange}gh:${_ghn}${reset}"
        else
          gh_badge="${red}gh:X${reset}"
        fi
        ;;
    esac
  fi

  # Background refresh
  _sl_check_ttl "$_gh_cache" "$_gh_ttl"
  if [ "$_sl_do_refresh" -eq 1 ]; then
    if mkdir "$_gh_lock" 2>/dev/null; then
      _bg_gc="$_gh_cache" _bg_gl="$_gh_lock"
      (
        trap 'rmdir "$_bg_gl" 2>/dev/null || true' EXIT
        _r=$(timeout 3 gh api rate_limit --jq '.resources.core.remaining' \
               2>/dev/null) || _r=""
        case "$_r" in
          ''|*[!0-9]*) _r="fail" ;;
        esac
        _tmp="${_bg_gc}.tmp.$$"
        printf '%s' "$_r" > "$_tmp" && mv "$_tmp" "$_bg_gc" || rm -f "$_tmp"
      ) </dev/null &>/dev/null &
      disown $! 2>/dev/null || true
    fi
  fi
fi

# ── SEGMENT 3 — Local daemon / service health ────────
# Cache: svc-status   TTL: 10s
# Services probed (only if binary present):
#
#   weave  — binary: /home/drdave/.cargo/bin/weave
#            probe:  timeout 2 weave daemon status 2>/dev/null
#            up  if stdout contains "running" AND NOT "stopped"/"not running"
#            down if stdout contains "stopped", command fails, or output empty
#
#   gitkb  — binary: /home/drdave/.local/bin/git-kb  (invoked as `git kb`)
#            probe:  cd <project_dir> && timeout 2 git-kb daemon status 2>/dev/null
#            down if stdout contains "not running"
#            up   if stdout contains "running" but NOT "not running"
#            down if command fails or output is empty
#            cwd = workspace.project_dir (KB-aware; avoids false-green from a
#            daemon serving a different KB)
#
#   ollama — binary: /usr/local/bin/ollama
#            probe:  curl -s --max-time 1 http://localhost:11434/api/tags
#            rationale: ollama exposes a well-known HTTP API. curl with max-time 1
#            is the canonical check — success (exit 0) = serving; failure = down.
#
# Result file: compact string like "weave:1,kb:0,ollama:1" — one key:0/1 per svc.
# Render: svc:weave·kb·ollama where each name is green=up, red=down.
#         Absent binary → service omitted from badge entirely.
svc_badge=""
_svc_cache="${_sl_cache_dir}/svc-status"
_svc_lock="${_sl_cache_dir}/svc-status.lock"
_svc_ttl=10

# Detect which services are installed (hot path — only command -v, no exec)
_svc_has_weave=0
_svc_has_kb=0
_svc_has_ollama=0
[ -x "/home/drdave/.cargo/bin/weave" ]    && _svc_has_weave=1
[ -x "/home/drdave/.local/bin/git-kb" ]   && _svc_has_kb=1
[ -x "/usr/local/bin/ollama" ]             && _svc_has_ollama=1

# Only render if at least one service is present
if [ $(( _svc_has_weave + _svc_has_kb + _svc_has_ollama )) -gt 0 ]; then

  # Hot path: read cache
  _svc_val=""
  [ -f "$_svc_cache" ] && _svc_val=$(<"$_svc_cache") 2>/dev/null || true

  # Parse cached values: format "weave:N,kb:N,ollama:N"
  _svc_weave_up=-1  # -1 = unknown/not-in-cache
  _svc_kb_up=-1
  _svc_ollama_up=-1
  if [ -n "$_svc_val" ]; then
    for _tok in $(echo "$_svc_val" | tr ',' ' '); do
      _k="${_tok%%:*}" _v="${_tok##*:}"
      case "$_k" in
        weave)  _svc_weave_up="$_v"  ;;
        kb)     _svc_kb_up="$_v"     ;;
        ollama) _svc_ollama_up="$_v" ;;
      esac
    done
  fi

  # Render badge
  _svc_parts=""
  _render_svc() {
    local _name="$1" _up="$2" _installed="$3"
    [ "$_installed" -eq 0 ] && return
    local _piece
    if [ "$_up" -eq 1 ] 2>/dev/null; then
      _piece="${green}${_name}${reset}"
    elif [ "$_up" -eq 0 ] 2>/dev/null; then
      _piece="${red}${_name}${reset}"
    else
      # Unknown (first run / no cache): show dim
      _piece="${dim}${_name}${reset}"
    fi
    if [ -z "$_svc_parts" ]; then
      _svc_parts="$_piece"
    else
      _svc_parts="${_svc_parts}${dim}·${reset}${_piece}"
    fi
  }
  _render_svc "weave" "$_svc_weave_up"  "$_svc_has_weave"
  _render_svc "kb"    "$_svc_kb_up"     "$_svc_has_kb"
  _render_svc "ollama" "$_svc_ollama_up" "$_svc_has_ollama"

  [ -n "$_svc_parts" ] && svc_badge="${dim}svc:${reset}${_svc_parts}"

  # Background refresh
  _sl_check_ttl "$_svc_cache" "$_svc_ttl"
  if [ "$_sl_do_refresh" -eq 1 ]; then
    if mkdir "$_svc_lock" 2>/dev/null; then
      _bg_sc="$_svc_cache" _bg_sl="$_svc_lock"
      _bg_has_weave="$_svc_has_weave"
      _bg_has_kb="$_svc_has_kb"
      _bg_has_ollama="$_svc_has_ollama"
      _bg_proj_dir="${proj_dir:-${cwd_json:-$(pwd)}}"
      (
        trap 'rmdir "$_bg_sl" 2>/dev/null || true' EXIT
        _out=""
        _append() {
          [ -z "$_out" ] && _out="$1" || _out="${_out},$1"
        }

        # weave: daemon status command
        # `weave daemon status` exits 0 either way; parse stdout.
        # up   = output contains "running" AND does NOT contain "stopped"/"not running"
        # down = output contains "stopped", command fails, or output is empty
        if [ "$_bg_has_weave" -eq 1 ]; then
          _weave_out=$(timeout 2 weave daemon status 2>/dev/null) || _weave_out=""
          if echo "$_weave_out" | grep -qi 'running' \
             && ! echo "$_weave_out" | grep -qiE 'stopped|not running'; then
            _append "weave:1"
          else
            _append "weave:0"
          fi
        fi

        # gitkb: per-KB daemon status command (KB-aware; avoids false-green from
        # a daemon serving a different KB).
        # Run with cwd = project dir so git-kb finds the right KB.
        # `git-kb daemon status` exits 0 either way; parse stdout.
        # down = output contains "not running"; up = "running" without "not running"
        if [ "$_bg_has_kb" -eq 1 ]; then
          _kb_proj="${_bg_proj_dir:-$(pwd)}"
          _kb_out=$(cd "$_kb_proj" && timeout 2 git-kb daemon status 2>/dev/null) || _kb_out=""
          if echo "$_kb_out" | grep -qi 'not running'; then
            _append "kb:0"
          elif echo "$_kb_out" | grep -qi 'running'; then
            _append "kb:1"
          else
            _append "kb:0"
          fi
        fi

        # ollama: HTTP API probe
        if [ "$_bg_has_ollama" -eq 1 ]; then
          if curl -s --max-time 1 http://localhost:11434/api/tags >/dev/null 2>&1; then
            _append "ollama:1"
          else
            _append "ollama:0"
          fi
        fi

        _tmp="${_bg_sc}.tmp.$$"
        printf '%s' "$_out" > "$_tmp" && mv "$_tmp" "$_bg_sc" || rm -f "$_tmp"
      ) </dev/null &>/dev/null &
      disown $! 2>/dev/null || true
    fi
  fi
fi

# ── Assembly ──────────────────────────────────────────
# Groups are collected into an array; the wrap routine
# packs them greedily onto lines based on $COLUMNS.

# Group 1: repo/remote/branch[@wt]
_g_repo="${magenta}${repo}${reset}/${dim}${remote}/${branch}${reset}"
if [ -n "$wt" ]; then _g_repo="${_g_repo}${yellow}${wt}${reset}"; fi

# Group 2: task · PR · loop  (always present, even if just ".")
_g_mid=""
_sep="${dim}·${reset}"
for _piece in "$task_label" "$pr" "$ll"; do
  if [ -z "$_piece" ]; then continue; fi
  if [ -n "$_g_mid" ]; then _g_mid="${_g_mid} ${_sep} "; fi
  _g_mid="${_g_mid}${_piece}"
done
if [ -z "$_g_mid" ]; then _g_mid="${dim}.${reset}"; fi

# Groups 3-9: individual right-side segments
_g_ctx=""
if [ -n "$ctx_display" ]; then _g_ctx="${ctx_display}"; fi

_g_tok=""
if [ -n "$tok_display" ]; then _g_tok="${tok_display}"; fi

_g_git=""
if [ -n "$git_dirty" ]; then _g_git="${git_dirty}"; fi

_g_meta=""
if [ -n "$meta_badge" ]; then _g_meta="${meta_badge}"; fi

_g_rtk_icm="${rtk_badge} ${icm_badge}"

_g_net=""
_net_gh_svc=""
if [ -n "$net_badge" ]; then _net_gh_svc="${net_badge}"; fi
if [ -n "$gh_badge" ]; then
  if [ -n "$_net_gh_svc" ]; then _net_gh_svc="${_net_gh_svc} ${gh_badge}"; else _net_gh_svc="${gh_badge}"; fi
fi
if [ -n "$svc_badge" ]; then
  if [ -n "$_net_gh_svc" ]; then _net_gh_svc="${_net_gh_svc} ${svc_badge}"; else _net_gh_svc="${svc_badge}"; fi
fi

_g_model="${dim}${model}${reset}"

# Build ordered array of non-empty groups
_groups=()
_groups+=("$_g_repo")
_groups+=("$_g_mid")
if [ -n "$_g_ctx" ];     then _groups+=("$_g_ctx");     fi
if [ -n "$_g_tok" ];     then _groups+=("$_g_tok");     fi
if [ -n "$_g_git" ];     then _groups+=("$_g_git");     fi
if [ -n "$_g_meta" ];    then _groups+=("$_g_meta");    fi
_groups+=("$_g_rtk_icm")
if [ -n "$_net_gh_svc" ]; then _groups+=("$_net_gh_svc"); fi
_groups+=("$_g_model")

# ── ANSI-strip + visible-width helpers ────────────────
# Strip ANSI escape sequences from a string; result in _sl_stripped.
_sl_strip_ansi() {
  _sl_stripped=$(printf '%s' "$1" | sed $'s/\033\\[[0-9;]*m//g')
  return 0
}

# Visible (printable) character count of a string (ANSI already stripped).
_sl_vis_len() {
  _sl_vlen=${#1}
  return 0
}

# ── Greedy line-wrap routine ───────────────────────────
# Reads: _groups array, _cols (terminal width)
# Prints each packed line via printf '%s\n'.
_sl_wrap_groups() {
  local _SEP="   "   # 3-space separator between groups on same line
  local _sep_vis=3

  # Determine terminal width; 0 means unknown → single-line fallback.
  local _cols=${COLUMNS:-0}
  # Validate: must be a positive integer.
  case "$_cols" in
    ''|*[!0-9]*) _cols=0 ;;
  esac
  if [ "$_cols" -le 0 ]; then
    # Fallback: emit all groups on one line exactly as before.
    local _line="" _i
    for _i in "${!_groups[@]}"; do
      if [ -z "$_line" ]; then
        _line="${_groups[$_i]}"
      else
        _line="${_line}${_SEP}${_groups[$_i]}"
      fi
    done
    printf '%s\n' "$_line"
    return 0
  fi

  # Greedy packing.
  local _cur_line=""
  local _cur_vis=0
  local _i
  for _i in "${!_groups[@]}"; do
    local _g="${_groups[$_i]}"
    _sl_strip_ansi "$_g"
    _sl_vis_len "$_sl_stripped"
    local _gvis="$_sl_vlen"

    if [ -z "$_cur_line" ]; then
      # Start a new line with this group (even if it's wider than _cols).
      _cur_line="$_g"
      _cur_vis="$_gvis"
    else
      # Would appending fit?
      local _needed=$(( _cur_vis + _sep_vis + _gvis ))
      if [ "$_needed" -le "$_cols" ]; then
        _cur_line="${_cur_line}${_SEP}${_g}"
        _cur_vis="$_needed"
      else
        # Flush current line, start a new one.
        printf '%s\n' "$_cur_line"
        _cur_line="$_g"
        _cur_vis="$_gvis"
      fi
    fi
  done
  # Flush last line.
  if [ -n "$_cur_line" ]; then
    printf '%s\n' "$_cur_line"
  fi
  return 0
}

_sl_wrap_groups
