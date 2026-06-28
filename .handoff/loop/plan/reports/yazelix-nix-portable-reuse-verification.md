# Verification: Yazelix portable bridge plan reuses current repos/components

- Date: 2026-06-28
- Target: `yazelix-nix-portable-bridge`
- Scope: verify the KB task/plan does not design a scratch system and correctly relates `meta`, `envctl`, `yazelix`, Nix, `DavHau/nix-portable`, and `nix-community/nix-bundle`.
- Verdict: **QUALIFIED PASS with one corrective constraint** — the architecture is right, but implementation must reuse envctl's existing `nix-portable` component before introducing any new provider payload layout.

## Evidence inventory

| Claim | Verdict | Evidence |
|---|---|---|
| `meta` already tracks `envctl` and `yazelix` as independent child repos, not monorepo modules. | CONFIRMED | `.meta.yaml:91-94`, `.meta.yaml:508-514` |
| `envctl` already has a `nix-portable` component. | CONFIRMED | `envctl/manifest/components.d/epic-h-toolchains.toml:680-748`; `envctl/manifest/envctl.lock:370-373` |
| Existing envctl `nix-portable` component uses upstream `DavHau/nix-portable`, not a local rewrite. | CONFIRMED | `envctl/manifest/components.d/epic-h-toolchains.toml:680-692`, `714-718` |
| Existing envctl `nix-portable` component is additive and does not touch host `/nix`. | CONFIRMED | `envctl/manifest/components.d/epic-h-toolchains.toml:686-688`, `692` |
| Existing live routing has a `nix-portable` frontdoor, but it is currently a symlink and often resolves via real-home `.local/bin` first. | CONFIRMED-DRIFT | `type -a nix-portable` live evidence 2026-06-28; `usr/bin/nix-portable -> $META_ROOT/.toolchains/nix-portable/bin/nix-portable` |
| Current Yazelix runtime is still `store/package runtime` through system Nix/default profile. | CONFIRMED | `yzx doctor --verbose` live evidence 2026-06-28 |
| Current Yazelix has a stale shell function/alias shadowing the profile command. | CONFIRMED | `yzx doctor --verbose` live evidence 2026-06-28; upstream troubleshooting documents this exact class |
| Current plan uses `nix-portable` as the portability bridge, not a scratch Nix implementation. | CONFIRMED | `.handoff/loop/plan/reports/yazelix-nix-portable-containment-solution.md:116-160` |
| Current plan should be tightened to say “reuse existing envctl `nix-portable` component first.” | GAP | Original plan proposed a provider payload root under `.local/share/envctl/providers`; envctl already has `.toolchains/nix-portable` component and lock entry. |
| `nix-bundle` should remain an artifact lane, not the runtime bridge. | CONFIRMED | Nix manual says `nix bundle` packs closures into Linux self-extracting executables; nix-bundle README lists slow startup, large files, Linux-only, and user-namespace constraints. |

## Relation and flow: current state

Source: `.meta.yaml`; `envctl/manifest/nix-yazelix.toml`; `envctl/manifest/components.d/epic-h-toolchains.toml`; Yazelix runtime contracts and live `yzx doctor`.

```text
meta workspace
┌───────────────────────────────────────────────────────────────┐
│ .meta.yaml                                                     │
│  ├─ envctl -> git@github.com:FlexNetOS/envctl.git              │
│  └─ yazelix -> git@github.com:FlexNetOS/yazelix.git            │
└───────────────┬───────────────────────────────────────────────┘
                │ envctl owns install graph / path authority
                ▼
┌───────────────────────────────────────────────────────────────┐
│ envctl current manifest state                                  │
│  ├─ nix component: copies system /nix nix into .toolchains      │
│  ├─ nix-yazelix-cache: mutates /etc/nix [OWNER-WALL]            │
│  ├─ yazelix: nix profile add github:FlexNetOS/yazelix#yazelix   │
│  ├─ yazelix-shell: sources /nix profile + yzx enter             │
│  └─ nix-portable: existing additive DavHau/nix-portable binary  │
└───────────────┬───────────────────────────────────────────────┘
                │ current active Yazelix lane
                ▼
┌───────────────────────────────────────────────────────────────┐
│ system-nix / default-profile runtime                           │
│  ├─ /nix/store/...-yazelix/bin/yzx                              │
│  ├─ /home/drdave/.nix-profile/bin/yzx                           │
│  ├─ /nix/store/...-yazelix/toolbin visible in PATH ⚠             │
│  └─ yzx doctor: store/package runtime + stale shell shadow ⚠    │
└───────────────────────────────────────────────────────────────┘
```

## Relation and flow: corrected target

```text
meta/envctl target provider model
┌───────────────────────────────────────────────────────────────┐
│ envctl path authority                                          │
│  ├─ reuses existing component: nix-portable                    │
│  │   envctl/manifest/components.d/epic-h-toolchains.toml       │
│  ├─ keeps system-nix lane as OWNER-WALL                        │
│  ├─ adds provider classifier + wrapper logic                   │
│  └─ does NOT create a new Nix replacement from scratch          │
└───────────────┬───────────────────────────────────────────────┘
                ▼
┌───────────────────────────────────────────────────────────────┐
│ $META_ROOT/usr/bin/yzx provider wrapper                        │
│  ├─ provider=system-nix -> current Nix/default profile lane     │
│  ├─ provider=nix-portable -> existing envctl nix-portable lane  │
│  └─ provider=bundle -> measured immutable artifact lane only    │
└───────────────┬───────────────────────────────────────────────┘
                ▼
┌───────────────────────────────────────────────────────────────┐
│ Yazelix explicit roots                                         │
│  ├─ YAZELIX_RUNTIME_DIR = provider runtime/package root         │
│  ├─ YAZELIX_CONFIG_DIR  = $META_ROOT/.config/yazelix            │
│  ├─ YAZELIX_STATE_DIR   = $META_ROOT/.local/share/yazelix       │
│  └─ toolbin only inside yzx env|enter|run                       │
└───────────────────────────────────────────────────────────────┘
```

## Architecture framework reasoning

### 1. Ownership layers

- **Meta** owns the workspace graph and repo relationship. It says `envctl` and `yazelix` are peer repos.
- **envctl** owns install location, frontdoors, doctor/verification, and host-boundary labels.
- **Yazelix** owns runtime semantics: runtime root, config root, state root, distribution tier, doctor/update-owner contracts.
- **Nix/system Nix** owns immutable `/nix/store` and daemon/system config only in the `system-nix` lane.
- **DavHau/nix-portable** owns the portable Nix virtualization primitive; envctl should package/wrap it rather than implement a rootless Nix clone.
- **nix-bundle/AppImage/bundle-dir** own artifact packaging experiments; they do not own mutable profile or config/state lifecycle.

### 2. Boundary conflicts

1. **Existing component vs proposed payload root**
   - Conflict: plan suggested `$META_ROOT/.local/share/envctl/providers/nix-portable`, while envctl already ships `$META_ROOT/.toolchains/nix-portable` and `$META_ROOT/usr/bin/nix-portable`.
   - Resolution: implementation must reuse the existing component first. Moving from `.toolchains` to `.local/share` or `$META_ROOT/opt` is a later strict-upgrade migration with parity proof.

2. **Symlink frontdoor vs regular wrapper policy**
   - Conflict: envctl docs prefer `$META_ROOT/usr/bin` frontdoors; earlier audit wanted regular wrappers, but live `usr/bin/nix-portable` is a symlink.
   - Resolution: wrapper normalization is a general envctl frontdoor convergence task, not a reason to rebuild nix-portable.

3. **Host `/nix` active lane vs portable lane**
   - Conflict: current active Yazelix path is store/package runtime through system Nix and default profile.
   - Resolution: keep this lane as `system-nix OWNER-WALL` until the `nix-portable` lane passes a clean-container proof.

4. **Base PATH leak vs Yazelix activation contract**
   - Conflict: live `yzx doctor` shows `/nix/store/...-yazelix/toolbin` in PATH and a stale shadowing shell path.
   - Resolution: provider wrapper must keep base PATH clean and only expose Yazelix toolbin through `yzx env|enter|run`.

5. **Bundle lane temptation**
   - Conflict: `nix-bundle` sounds like “run anywhere,” but has Linux/userns/startup/size constraints and cannot manage mutable profiles.
   - Resolution: keep bundle lane as measured titan artifact only; never use it as the runtime/update owner.

## Implementation correction to the plan

The Feature Forge handoff should be read as:

1. **Reuse** `envctl/manifest/components.d/epic-h-toolchains.toml` `[[component]] id = "nix-portable"`.
2. **Add detector/classifier** that recognizes this existing component as the `nix-portable` provider.
3. **Add/normalize wrapper** for `yzx`, not a new Nix runtime implementation.
4. **Add clean proof** that invokes existing `nix-portable` with `NP_LOCATION` / HOME / XDG redirected under `$META_ROOT`.
5. **Only after proof**, decide whether to migrate the nix-portable payload root from `.toolchains` to `.local/share/envctl/providers` or `$META_ROOT/opt/nix-portable`.

## Verification result

- **The plan does leverage current repos**: `FlexNetOS/yazelix`, `FlexNetOS/envctl`, `DavHau/nix-portable`, and `nix-community/nix-bundle` are all used as existing upstream/current repo surfaces.
- **The plan does not require a scratch implementation** if the corrective constraint above is followed.
- **The most important gap** is not “write nix-portable support”; envctl already has it. The gap is **wire existing nix-portable into Yazelix provider selection and prove the write/path boundary**.
