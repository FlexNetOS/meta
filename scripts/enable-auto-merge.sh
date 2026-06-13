#!/usr/bin/env bash
# enable-auto-merge.sh — make GitHub auto-merge actually work across the fleet.
#
# Auto-merge needs TWO things per repo: (1) the `allow_auto_merge` repo setting,
# and (2) branch protection on the default branch with at least one required
# status check (so auto-merge has something to wait for, then self-merges).
#
# This is a SECURITY-CONFIG change to shared repos — review before running.
# Run `--dry-run` first. It is idempotent and conservative:
#   - enables allow_auto_merge=true everywhere (safe, reversible),
#   - sets branch protection ONLY where it's missing AND the repo actually has
#     CI checks to require (a repo with no checks would otherwise stall forever),
#   - SKIPS forks (their default branch syncs from upstream — protection breaks that),
#   - never overwrites existing protection,
#   - requires NO human review (so PRs self-land on green), strict=false.
#
# Required-check contexts are detected from the latest commit's check-runs on the
# default branch. Review the printed contexts — if a repo runs a check only on
# push (not pull_request), requiring it would stall PRs; exclude such repos.
#
# Usage:  bash scripts/enable-auto-merge.sh [--dry-run]
#         REPOS="a b c" bash scripts/enable-auto-merge.sh   # limit to a subset
set -uo pipefail

META_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ORG="FlexNetOS"
DRY=0; [ "${1:-}" = "--dry-run" ] && DRY=1

command -v gh >/dev/null || { echo "FATAL: gh CLI required" >&2; exit 1; }

# Repo slugs: explicit $REPOS, else every FlexNetOS repo in .meta.yaml.
if [ -n "${REPOS:-}" ]; then
  slugs="$REPOS"
else
  slugs="$(python3 -c "
import yaml
d=yaml.safe_load(open('$META_ROOT/.meta.yaml'))['projects']
seen=set()
for n,v in d.items():
    r=v.get('repo','') if isinstance(v,dict) else ''
    if '$ORG/' in r:
        s=r.split('$ORG/')[1].replace('.git','').strip()
        if s and s not in seen: seen.add(s); print(s)
")"
fi

setting=0 prot=0 skip_fork=0 skip_noci=0 skip_have=0 skip_nf=0
for s in $slugs; do
  meta="$(gh api "repos/$ORG/$s" --jq '{fork:.fork, db:.default_branch}' 2>/dev/null)" || { echo "?? $s (no access)"; skip_nf=$((skip_nf+1)); continue; }
  fork="$(printf '%s' "$meta" | python3 -c "import json,sys;print(json.load(sys.stdin)['fork'])")"
  db="$(printf '%s' "$meta" | python3 -c "import json,sys;print(json.load(sys.stdin)['db'])")"

  # (1) allow_auto_merge — safe everywhere.
  if [ "$DRY" = 1 ]; then echo "DRY: set allow_auto_merge=true on $s"; else
    gh api -X PATCH "repos/$ORG/$s" -F allow_auto_merge=true >/dev/null 2>&1 && setting=$((setting+1))
  fi

  # (2) branch protection — only where safe + meaningful.
  if [ "$fork" = "True" ]; then echo "  skip $s: fork (don't protect synced branch)"; skip_fork=$((skip_fork+1)); continue; fi
  if gh api "repos/$ORG/$s/branches/$db/protection" --jq .url >/dev/null 2>&1; then
    echo "  skip $s: already protected"; skip_have=$((skip_have+1)); continue; fi
  sha="$(gh api "repos/$ORG/$s/commits/$db" --jq .sha 2>/dev/null)"
  ctxs="$(gh api "repos/$ORG/$s/commits/$sha/check-runs" --jq '[.check_runs[].name]|unique' 2>/dev/null)"
  cnt="$(printf '%s' "$ctxs" | python3 -c "import json,sys
try: print(len(json.load(sys.stdin)))
except Exception: print(0)" 2>/dev/null)"
  if [ "${cnt:-0}" -lt 1 ]; then echo "  skip $s: no CI checks on $db (would stall)"; skip_noci=$((skip_noci+1)); continue; fi

  if [ "$DRY" = 1 ]; then
    echo "DRY: protect $s/$db requiring $cnt checks: $ctxs"
  else
    printf '{"required_status_checks":{"strict":false,"contexts":%s},"enforce_admins":false,"required_pull_request_reviews":null,"restrictions":null}' "$ctxs" \
      | gh api -X PUT "repos/$ORG/$s/branches/$db/protection" --input - >/dev/null 2>&1 \
      && { echo "  + $s/$db: $cnt required checks"; prot=$((prot+1)); } \
      || echo "  FAIL $s (protection PUT)"
  fi
done

echo ""
echo "allow_auto_merge set: $setting | newly protected: $prot"
echo "skipped: $skip_fork forks, $skip_noci no-CI, $skip_have already-protected, $skip_nf no-access"
[ "$DRY" = 1 ] && echo "(dry-run — nothing changed)"
