#!/usr/bin/env bash
# idd-backup-sweep.sh — relocate loose tool-generated safe-write backups into the
# never-delete, compressed, out-of-tree backup store. Authoritative policy:
# META-BACKUP-POLICY.md (META-ORG-POLICY.md P5.25).
#
# What it does, per repo:
#   1. find loose *.idd-bak-* / *.idd-bak files (excluding target/ .git/ .worktrees/),
#   2. content-address each by SHA-256 and append it (deduplicated) into the repo's
#      single append-only archive  meta/.backups/<repo>/idd-backups.tar.zst,
#   3. log every occurrence in  meta/.backups/<repo>/index.tsv,
#   4. ONLY after the bytes are verified present in the store, remove the loose copy
#      (and `git rm --cached` it if it was tracked).
#
# A backup's CONTENT is never deleted — the loose file is removed only because its
# exact bytes are preserved (SHA-verified) in the store. The archive is rebuilt
# atomically and integrity-checked before any loose file is touched.
#
# Usage:
#   scripts/idd-backup-sweep.sh [REPO_ROOT]      # dry-run (default): report only
#   scripts/idd-backup-sweep.sh [REPO_ROOT] --apply
#   STORE_ROOT=/path scripts/idd-backup-sweep.sh ...   # override store location
#
# Fleet sweep:  meta exec -- "$PWD/scripts/idd-backup-sweep.sh" --apply
#
# Exit: 0 = ok (swept or nothing to do); non-zero = error (store left untouched).
set -uo pipefail

# ---- args ------------------------------------------------------------------
apply=0
repo_root=""
for a in "$@"; do
  case "$a" in
    --apply) apply=1 ;;
    -h|--help) sed -n '2,30p' "$0"; exit 0 ;;
    *) repo_root="$a" ;;
  esac
done
repo_root="${repo_root:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
repo_root="$(cd "$repo_root" && pwd)"
repo_name="$(basename "$repo_root")"

# ---- locate the meta root (holds .meta.yaml) to anchor the store -----------
find_meta_root() {
  local d="$1"
  while [ "$d" != "/" ]; do
    if [ -f "$d/.meta.yaml" ] || [ -f "$d/.meta" ]; then echo "$d"; return 0; fi
    d="$(dirname "$d")"
  done
  return 1
}
meta_root="$(find_meta_root "$repo_root" || true)"
if [ -z "${STORE_ROOT:-}" ] && [ -z "$meta_root" ]; then
  echo "idd-backup-sweep[$repo_name]: cannot find meta root (.meta.yaml); set STORE_ROOT=" >&2
  exit 2
fi
store_root="${STORE_ROOT:-$meta_root/.backups}"
store="$store_root/$repo_name"
archive="$store/idd-backups.tar.zst"
index="$store/index.tsv"

command -v zstd   >/dev/null || { echo "idd-backup-sweep: zstd not found" >&2; exit 2; }
command -v sha256sum >/dev/null || { echo "idd-backup-sweep: sha256sum not found" >&2; exit 2; }

# ---- find loose backups ----------------------------------------------------
mapfile -d '' loose < <(find "$repo_root" \
  \( -path '*/target' -o -path '*/.git' -o -path '*/.worktrees' -o -path "$store_root" \) -prune -o \
  -type f \( -name '*.idd-bak-*' -o -name '*.idd-bak' \) -print0)

if [ "${#loose[@]}" -eq 0 ]; then
  echo "idd-backup-sweep[$repo_name]: no loose backups — conformant."
  exit 0
fi

run_id="$(git -C "$repo_root" rev-parse --short HEAD 2>/dev/null || echo nogit)-$$"
echo "idd-backup-sweep[$repo_name]: found ${#loose[@]} loose backup(s)."
echo "  store:   $archive"
if [ "$apply" -eq 0 ]; then
  total=0
  for f in "${loose[@]}"; do
    sz=$(wc -c <"$f"); total=$((total+sz))
    printf '  would archive: %s (%s bytes)\n' "${f#$repo_root/}" "$sz"
  done
  echo "  DRY-RUN: $total bytes across ${#loose[@]} files would be archived (none removed). Re-run with --apply."
  exit 0
fi

# ---- apply: build new archive atomically in a temp dir --------------------
mkdir -p "$store"
tmp="$(mktemp -d "${TMPDIR:-/tmp}/idd-bak.XXXXXX")"
trap 'rm -rf "$tmp"' EXIT
acc="$tmp/acc.tar"

# seed accumulator tar from the existing archive (decompress), or empty.
if [ -f "$archive" ]; then
  if ! zstd -dqc "$archive" >"$acc"; then
    echo "idd-backup-sweep[$repo_name]: FAILED to read existing archive — aborting, store untouched." >&2
    exit 1
  fi
else
  tar -cf "$acc" -T /dev/null
fi
[ -f "$index" ] || printf 'iso_ts\trepo_rel_path\tsha256\torig_bytes\trun_id\n' >"$index"

# known shas already in the store (content-addressed entry names)
declare -A known=()
while IFS= read -r name; do [ -n "$name" ] && known["$name"]=1; done < <(tar -tf "$acc" 2>/dev/null)

prior_count=$(tar -tf "$acc" 2>/dev/null | grep -c . || true)
added=0
declare -a swept_files=()
declare -a index_rows=()

obj="$tmp/obj"; mkdir -p "$obj"
for f in "${loose[@]}"; do
  sha="$(sha256sum "$f" | awk '{print $1}')"
  sz="$(wc -c <"$f")"
  rel="${f#$repo_root/}"
  ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  if [ -z "${known[$sha]:-}" ]; then
    cp "$f" "$obj/$sha"
    tar --append -f "$acc" -C "$obj" "$sha"
    known["$sha"]=1
    added=$((added+1))
  fi
  index_rows+=("$(printf '%s\t%s\t%s\t%s\t%s' "$ts" "$rel" "$sha" "$sz" "$run_id")")
  swept_files+=("$f")
done

# recompress atomically
if ! zstd -q -19 -T0 -f "$acc" -o "$archive.tmp"; then
  echo "idd-backup-sweep[$repo_name]: FAILED to compress new archive — aborting, store untouched." >&2
  exit 1
fi

# integrity gate: the new archive must contain prior_count + added entries, and
# every swept file's sha must be present, before we remove ANY loose file.
new_count=$(zstd -dqc "$archive.tmp" | tar -tf - 2>/dev/null | grep -c . || true)
if [ "$new_count" -lt "$((prior_count + added))" ]; then
  echo "idd-backup-sweep[$repo_name]: integrity check FAILED ($new_count < $((prior_count+added))) — aborting." >&2
  rm -f "$archive.tmp"
  exit 1
fi
mapfile -t present < <(zstd -dqc "$archive.tmp" | tar -tf - 2>/dev/null)
declare -A present_set=(); for p in "${present[@]}"; do present_set["$p"]=1; done

mv -f "$archive.tmp" "$archive"
printf '%s\n' "${index_rows[@]}" >>"$index"

# now safe to remove loose copies (content verified in store)
removed=0
for f in "${swept_files[@]}"; do
  sha="$(sha256sum "$f" | awk '{print $1}')"
  if [ -n "${present_set[$sha]:-}" ]; then
    # untrack if it was committed, then remove from disk
    if git -C "$repo_root" ls-files --error-unmatch "$f" >/dev/null 2>&1; then
      git -C "$repo_root" rm --cached -q "$f" 2>/dev/null || true
    fi
    rm -f "$f"
    removed=$((removed+1))
  fi
done

# seed a restore README once
if [ ! -f "$store/README.md" ]; then
  cat >"$store/README.md" <<EOF
# Backup store — $repo_name

Never-delete, compressed, append-only safe-write backups. Policy: META-BACKUP-POLICY.md.

- \`idd-backups.tar.zst\` — content-addressed by SHA-256 (entry name = sha256).
- \`index.tsv\` — iso_ts, repo_rel_path, sha256, orig_bytes, run_id (one row per occurrence).

Restore a version:
  sha=\$(grep '<path>' index.tsv | sort | tail -1 | cut -f3)
  zstd -dc idd-backups.tar.zst | tar -xO "\$sha" > restored-file
EOF
fi

echo "idd-backup-sweep[$repo_name]: archived $added new object(s), logged ${#index_rows[@]} occurrence(s), removed $removed loose file(s). Store: $archive"
