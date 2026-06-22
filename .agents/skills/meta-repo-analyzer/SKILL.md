---
name: meta-repo-analyzer
description: Deep research skill for reviewing target repositories, understanding their architecture, and logically organizing them within the FlexNetOS/meta framework. Use this skill when asked to evaluate a new or existing repository, define its relationship to other meta components like hubs or core libs, or determine its tags and placement in `.meta.yaml`.
---

# meta-repo-analyzer

When activated, follow this deep research and organization methodology:

1. **Information Gathering & Synchronization**
   - **Sync:** Pull the latest updates for the target repository and any related context repositories using `git pull` or `meta git update`.
   - **Discover:** Identify the repository's core files: `README.md`, `Cargo.toml`, `package.json`, or architecture docs.
   - **Read:** Consume these documents to understand the repository's stated purpose, its level of abstraction (e.g., L1 primitive, L2 orchestrator, L3 builder), and its dependencies.

2. **Framework Alignment Analysis**
   - Cross-reference the repository's purpose against the existing `meta` ecosystem by examining `.meta.yaml`.
   - Identify which existing "tab" or "hub" the repository naturally belongs to (e.g., `ai`, `tools`, `hub`, `docs`).
   - Determine the dependency graph: Is it a standalone tool? A plugin? A layer on top of an existing hub (e.g., `harness_hub`)?

3. **Placement & Organization Strategy**
   - **Tagging:** Propose appropriate tags for `.meta.yaml` (e.g., `[hub, harness]`, `[ai, forked]`).
   - **Location:** Determine if the repo should be tracked as a root-level meta peer, or nested inside a specific hub.
   - **Integration:** Describe how `meta` will interact with this repo (e.g., as an MCP server, a CLI plugin, or an execution harness).

4. **Output Format**
   Present your findings in a structured format:
   - **Executive Summary:** A 1-2 sentence description of what the repo is.
   - **Architecture Fit:** Where it sits in the L1/L2/L3 abstraction stack and its relation to context repos.
   - **Organization Recommendation:** Specific `.meta.yaml` entry and tagging strategy.
   - **Usage Guide:** A brief explanation of how to use it within the `meta` workspace.
