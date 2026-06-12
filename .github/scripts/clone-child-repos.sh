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
# Third-party forks compiled into the workspace; not yet forked into
# FlexNetOS (tracked as policy debt — local checkouts may carry mods
# these upstream clones don't have).
clone_child teri SHA888/teri
clone_child shimmy Michael-A-Kuykendall/shimmy
