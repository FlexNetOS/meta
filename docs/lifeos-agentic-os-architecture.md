# LifeOS Agentic OS Architecture

## Purpose

This document explains the target architecture for the LifeOS portable Agentic
OS release. It expands the roadmap into ownership boundaries and runtime flows.

## Architecture map

    meta
      plans release graph
      exposes command and MCP surfaces
      records evidence requirements
        |
        v
    flexnetos_runner
      executes Ubuntu 26.04 x86_64 build/proof phases
      writes logs, ledgers, manifests, artifacts
        |
        v
    lifeos-agentic-os prefix
      contains LifeOS app, runtime manager, meta, Yazelix tools, manifests
      installs into a user-owned prefix
        |
        v
    host Linux
      owns kernel, drivers, init, GPU, network, system services

## Boundary rules

| Boundary | Owned by release | Owned by host |
|---|---|---|
| Kernel and drivers | No | Yes |
| System services | Opt-in adapter only | Yes |
| Release binaries | Yes, inside prefix | No |
| Mutable app state | Yes, under var/ | No |
| User config defaults | Yes, under etc/ or home/default/ | No |
| Secrets | Templates only | User or host secret store |
| Hardware/GPU access | Policy and probes only | Yes |

## Control-plane flow

1. meta reads the release manifest and computes a repo graph.
2. meta emits a release plan with target, input revisions, phases, and gates.
3. flexnetos_runner executes the plan on the selected runner label set.
4. Each phase appends to manifests/build-ledger.jsonl and writes logs.
5. The package phase assembles lifeos-agentic-os/.
6. The proof phase runs install dry-run, version checks, smoke tests, checksum
   verification, SBOM/provenance generation, and no-secret scans.
7. meta reads the evidence and reports status through CLI and MCP.

## Release graph

| Project | Provides | Depends on | Notes |
|---|---|---|---|
| meta | meta-control-plane, meta-mcp | flexnetos_runner for proof execution | Planner and agent visibility |
| flexnetos_runner | self-hosted-runner, release-proof | meta release plan | Executes build/proof phases |
| yazelix | runtime-bedrock | pinned Nix inputs | Supplies terminal/runtime foundation |
| lifeos | lifeos-app | meta, yazelix, runtime manager | Target app and final prefix owner |

## Runtime manager

The runtime manager belongs in LifeOS because it controls the app prefix after
installation.

| Component | Responsibility | Required proof |
|---|---|---|
| lifeos-supervisor | Launches LifeOS, shell services, and internal daemons inside the prefix | doctor --json and var/run lifecycle proof |
| lifeos-update-manager | Verifies, stages, swaps, and rolls back release versions | checksum/provenance verification proof |
| lifeos-adopt-tool | Builds and promotes new tools under policy | build-before-adopt evidence |

## MCP model

meta should expose release information with read-first tools:

- meta_release_plan
- meta_release_graph
- meta_release_status
- meta_release_artifacts
- meta_release_provenance
- meta_release_open_questions

Mutation tools remain blocked by default or require explicit confirmation.

## Evidence classes

| Class | Meaning |
|---|---|
| FACT | Verified in the current checkout, remote source, or command output |
| TARGET | Desired design state not yet implemented |
| QUESTION | Decision or evidence still missing |
| BLOCKER | Requirement that prevents claiming release completion |

The roadmap PR may define TARGETS. Implementation PRs must convert TARGETS into
FACTS through command output, manifests, and runtime proof.
