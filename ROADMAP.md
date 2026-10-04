# Kane Civicmin Roadmap

## Purpose

Kane Civicmin is a thin Usermin/Webmin client for Civic Infrastructure.

It presents bounded participant actions, help, forms, status, and result evidence. It does not own Civic identity, workflow authority, backend routing, federation authority, or service credentials.

The durable boundary is:

```text
Participant
    |
    v
Usermin / Civicmin
    |
    | bounded local request
    v
local Civic adapter / broker
    |
    | trusted participant identity and command policy
    v
Civic Orchestrator
    |
    v
bounded Civic services
```

The transport beyond the local Civic boundary is intentionally replaceable. Civicmin must remain compatible with the later enterprise message/federation layer without embedding a specific remote transport.

## Authorities and scope controls

Civicmin development is constrained by two external authorities:

1. **Official Webmin/Usermin source** — authority for module integration, UI helpers, authentication/session behavior, module packaging, ACL behavior, and supported extension mechanisms.
2. **git64bit/kane-capabilities** — frozen Civic contract/deployment baseline for participant identity, Custom Command identity, access policy, broker behavior, Orchestrator operations, workflow semantics, and prohibited generic escape hatches.

Civicmin must not silently redefine either authority.

The Kane reference deployment is a test deployment, not the product boundary. Other Owner Operators must be able to install Civicmin without Kane private infrastructure.

## Upstream baseline

Initial development targets the Usermin generation currently used by the Kane reference deployment:

```text
Usermin 2.550 compatibility floor
```

Current upstream Usermin is newer and will be monitored as a compatibility target, not treated as an excuse to depend on features unavailable in the deployed baseline.

The upstream source already establishes several useful facts:

- Usermin modules are first-class installable modules identified by `module.info` and `usermin=1`.
- Webmin's Usermin Configuration module can install, remove, clone, export, and configure Usermin modules.
- Usermin ACL and `usermin.mods` restrictions remain part of the host access model.
- the normal Webmin UI helper library provides forms, tables, tabs, selectors, uploads, buttons, and other theme-integrated controls.
- stock Custom Commands supports two main-page modes:
  - `display_mode=0`: all commands and parameters rendered on the main page;
  - `display_mode=1`: a command list whose entries open a dedicated one-command form.
- stock Custom Commands therefore remains a useful compatibility/reference surface during Civicmin development.

No upstream Webmin/Usermin source is to be patched as the default Civicmin development strategy.

## Release model

Civicmin uses Semantic Versioning:

```text
vMAJOR.MINOR.PATCH
```

Pre-1.0 releases are acceptance milestones, not calendar releases.

Rules:

- tags are created only for repository states that pass the milestone acceptance gate;
- ordinary development commits are not tagged;
- release candidates use `vX.Y.Z-rc.N`;
- patch releases fix defects without intentionally widening the supported Civic surface;
- minor releases add bounded compatible capability or UI surface;
- `v1.0.0` requires a portable Owner Operator installation and a stable transport-independent Civic client boundary;
- release notes must state the supported Usermin versions, required Civic contract baseline, migration notes, and known limitations.

The roadmap is gate-driven. There is no fixed date schedule.

## Milestones

### v0.1.0 — Upstream and contract baseline

Goal: establish the development boundary before implementation.

Deliverables:

- repository purpose and non-goals;
- official Webmin/Usermin source baseline;
- Usermin module anatomy and packaging notes;
- Kane Capabilities compatibility baseline;
- initial compatibility matrix;
- stock Custom Commands comparison, including both display modes;
- no production changes.

Acceptance:

- another Owner Operator can understand what Civicmin is and is not;
- no Civic authority has been moved into the UI;
- no upstream source modification is required.

### v0.2.0 — Native Civicmin shell

Goal: prove that Civicmin can exist as an independent Usermin module.

Deliverables:

- installable Usermin module skeleton;
- native Usermin navigation/menu presence;
- Authentic Theme-compatible page shell;
- privilege behavior documented and tested;
- no remote Civic dispatch;
- no external side effect.

Acceptance:

```text
Usermin login
  -> Civicmin module
  -> authenticated participant context
  -> static/read-only Civicmin page

side_effects=false
```

### v0.3.0 — Civic command catalog

Goal: make the frozen Civic command inventory visible without duplicating authority.

Deliverables:

- read-only command catalog sourced through the accepted local Civic boundary;
- per-Participant discovery filtering;
- command family grouping;
- lifecycle state and help display;
- no browser-side entitlement decisions;
- stock Custom Commands remains available as a reference/fallback during evaluation.

Acceptance:

- Civicmin displays only commands authorized by the trusted local policy path;
- disabling or withholding a command at the Civic boundary removes it from Civicmin without editing Civicmin code;
- no invocation yet required.

### v0.4.0 — Representative local-stub forms

Goal: prove the UI architecture across the known command-input families before remote integration.

Representative commands should cover at least:

- upload bytes — `water-ants` / Publish File;
- no-input query — `navy-roots` / My Publications;
- typed fields — `next-penny` / Bind Logical File Name;
- known-object selection — `stone-wren` / Unbind Logical File Name;
- mixed structured input plus bytes — `plain-fox` / Register Attestation Record;
- dependent selections / high consequence — `rust-moon` / Request Authorized Edge Update.

All remain local validation/stub operations.

Acceptance:

```text
real Usermin Participant
  -> Civicmin
  -> local Civic broker
  -> stable Participant identity
  -> curated command authorization
  -> fixed semantic binding
  -> local stub/result

remote_dispatch=false
side_effects=false
```

Desktop and narrow-window rendering are acceptance criteria, not cosmetic follow-up work.

### v0.5.0 — Packaging and Owner Operator install

Goal: make Civicmin independently installable and maintainable.

Deliverables:

- standard Usermin module package;
- install, upgrade, rollback, and uninstall procedure;
- no edits to upstream Usermin module files;
- configuration separated from code;
- ACL behavior documented;
- version/compatibility checks;
- reproducible package artifact and checksums.

Acceptance:

- a clean supported Usermin installation can install Civicmin using normal Usermin/Webmin module administration;
- removal restores the host without leaving modified upstream files;
- Kane-specific deployment values are configuration, not source assumptions.

### v0.6.0 — Kane validation deployment

Goal: validate the packaged module against the Kane reference Portal while preserving the frozen Civic boundary.

Deliverables:

- real Participant-session acceptance;
- catalog and representative forms exercised;
- comparison with stock Custom Commands;
- failure and upload cleanup behavior verified;
- deployment facts documented outside generic product assumptions.

Acceptance:

- existing accepted participant identity and broker semantics are preserved;
- no regression to Usermin Mail, File Manager, Terminal, or existing access controls;
- `side_effects=false`.

### v0.7.0 — Authenticated Orchestrator validation

Goal: complete the remaining validation-only integration without making Civicmin transport-specific.

Deliverables:

- Civicmin continues to speak only to the local trusted Civic boundary;
- the existing authenticated Orchestrator path is exercised through trusted server-side code;
- workflow, audit, receipt, and failure evidence can be presented;
- backend publication side effects remain disabled.

Acceptance target:

```text
real Usermin Participant
  -> Civicmin
  -> local Civic boundary
  -> stable Participant identity
  -> fixed command binding
  -> authenticated Orchestrator transport
  -> validation-only backend

remote dispatch may occur
Kubo/IPFS disabled
side_effects=false
```

### v0.8.0 — Broader command-family coverage

Goal: prove that the UI and handler model scales beyond the first six representatives.

Deliverables:

- additional read-only query/result views;
- publication/catalog operations;
- namespace operations;
- attestation and continuity operations;
- edge/signing/firmware presentation patterns where their Civic contracts are accepted;
- consistent error, workflow, receipt, and help presentation.

No command advances merely because a UI exists. Each remains constrained by its authoritative Civic lifecycle and binding.

### v0.9.0 — Owner Operator release candidate

Goal: test portability outside the Kane reference deployment.

Deliverables:

- installation by at least one independent Owner Operator or equivalent clean-room deployment;
- documented configuration surface;
- supported-version matrix;
- upgrade path;
- operator-facing troubleshooting;
- no Kane-only hostname, account, network, or service assumptions in the module;
- release candidate tags may be used during this gate.

Acceptance:

- independent installation does not require source edits;
- Civicmin remains thin;
- local authority and Orchestrator boundaries remain replaceable and operator-owned.

### v1.0.0 — Stable thin-client boundary

Goal: freeze the first stable Civicmin public contract.

Required characteristics:

- independent Usermin module packaging;
- stable participant-facing command/catalog model;
- stable local Civic message boundary;
- transport independence beyond the local authority boundary;
- compatibility with owner-operated Civic Orchestrators;
- migration and rollback documentation;
- no dependency on a Kane-specific topology;
- no generic remote dispatcher or privileged backend selector.

The wider Civic Infrastructure enterprise message/federation plane may be introduced independently. Civicmin v1 must not prevent that integration or require a particular broker product.

## Deferred integration

A later RabbitMQ-, NATS-, or equivalent enterprise message layer may federate independently owner-operated Civic Infrastructure components.

Civicmin does not select that technology and must not connect directly to it merely because it exists. The durable Civicmin responsibility remains:

```text
participant intent
  -> bounded local Civic message
  -> trusted local authority boundary
```

Federation, remote routing, and cross-operator trust remain Orchestrator/infrastructure concerns.

## Explicit non-goals

Civicmin does not become:

- a second Civic Orchestrator;
- a generic shell or remote command runner;
- a generic HTTP client or proxy;
- a direct Kubo/IPFS client;
- a RabbitMQ/NATS administration client;
- a holder of backend service credentials;
- a replacement for Usermin Mail, File Manager, Terminal, or Unix account management;
- a replacement for Hubzilla or Kane Fabric;
- an owner of Civic participant identity;
- an alternate entitlement database.

## Roadmap maintenance

This file is intentionally loose.

Milestones may split or merge when upstream research or acceptance evidence justifies it. Version numbers describe accepted product states, not promised dates.

When a milestone changes, update this roadmap before implementation drifts beyond it.
