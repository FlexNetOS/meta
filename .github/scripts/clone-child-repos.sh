#!/usr/bin/env bash
set -euo pipefail

# Clone every Cargo workspace member that lives in a child repo.
# Keep the clone_child list at the bottom in sync with [workspace] members
# in Cargo.toml. FlexNetOS children are private, so CI must inject
# CHILD_CLONE_TOKEN (PARENT_REPO_PAT); empty token = anonymous (public only).

auth_url() {
  local slug="$1"
  if [[ -n "${CHILD_CLONE_TOKEN:-}" ]]; then
    echo "https://x-access-token:${CHILD_CLONE_TOKEN}@github.com/${slug}.git"
  else
    echo "https://github.com/${slug}.git"
  fi
}

# Diagnostic preamble — never prints the token itself. The 4-char prefix
# identifies the token KIND (ghs_=github.token, ghp_=classic PAT,
# gith=fine-grained PAT), which tells us whether secrets.PARENT_REPO_PAT
# actually resolved or the workflow fell back to github.token.
if [[ -n "${CHILD_CLONE_TOKEN:-}" ]]; then
  echo "child-clone auth: token present (${#CHILD_CLONE_TOKEN} chars, prefix '${CHILD_CLONE_TOKEN:0:4}')"
else
  echo "child-clone auth: token EMPTY — anonymous clones; private repos will fail"
fi

probe() {
  local label="$1" slug="$2"
  if git ls-remote --exit-code "$(auth_url "$slug")" HEAD >/dev/null 2>&1; then
    echo "probe ${label} (${slug}): OK"
  else
    echo "probe ${label} (${slug}): FAIL"
  fi
}
probe public  FlexNetOS/rtk-tokenkill
probe private FlexNetOS/loop_lib

child_branch="${META_CHILD_BRANCH:-${GITHUB_HEAD_REF:-${GITHUB_REF_NAME:-}}}"

branch_candidates=()
if [[ -n "$child_branch" ]]; then
  branch_candidates+=("$child_branch")

  normalized_branch="${child_branch//\//-}"
  if [[ "$normalized_branch" != "$child_branch" ]]; then
    branch_candidates+=("$normalized_branch")
  fi
fi

clone_child() {
  local repo="$1"
  local slug="${2:-FlexNetOS/${repo}}"
  local url
  url="$(auth_url "$slug")"
  local branch
  local ls_remote_status

  for branch in "${branch_candidates[@]}"; do
    set +e
    # Output suppressed: the URL carries credentials in CI.
    git ls-remote --exit-code --heads "$url" "$branch" >/dev/null 2>&1
    ls_remote_status=$?
    set -e

    if [[ $ls_remote_status -eq 0 ]]; then
      echo "Cloning ${slug} (-> ${repo}/) from branch ${branch}"
      git clone --depth 1 --branch "$branch" "$url" "$repo"
      return
    fi

    if [[ $ls_remote_status -ne 2 ]]; then
      echo "Failed to query branch '${branch}' for ${slug} (status: ${ls_remote_status})" >&2
      exit "$ls_remote_status"
    fi
  done

  echo "Cloning ${slug} (-> ${repo}/) from default branch"
  git clone --depth 1 "$url" "$repo"
}

clone_child loop_lib
clone_child loop_cli
clone_child meta_cli
clone_child meta_core
clone_child meta_git_cli
clone_child meta_git_lib
clone_child meta_mcp
clone_child meta_plugin_protocol
clone_child meta_plugin_api
clone_child meta_rust_cli
clone_child meta_project_cli
clone_child rtk-tokenkill
# Third-party tools homed as genuine FlexNetOS forks so the workspace
# builds from org-controlled sources. The fork mains carry the
# meta-fit patch (shimmy drops its standalone [workspace] root, which
# otherwise collides with the meta workspace). Keep upstream synced
# via each repo's `upstream` remote (Michael-A-Kuykendall/shimmy,
# SHA888/teri) — re-apply the patch on sync.
clone_child teri
clone_child shimmy

# envctl — meta's environment manager. Excluded from the root [workspace] (it owns its own
# workspace for its no-C pins) but built/tested in the dedicated `envctl` CI job below, which
# needs it cloned at meta/envctl so its path-deps (loop_lib, meta_plugin_protocol) resolve.
# Windows cannot check out envctl today because that repo deliberately contains Codex prompt
# filenames with ':' (invalid on NTFS). The root meta workspace does not include envctl, and the
# dedicated envctl CI job is Linux-only, so skip only this non-workspace child on Windows.
if [[ "${RUNNER_OS:-}" == "Windows" ]]; then
  echo "Skipping envctl clone on Windows (not a root workspace member; contains NTFS-invalid prompt filenames)"
else
  clone_child envctl
fi
