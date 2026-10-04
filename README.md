# Kane Civicmin

Kane Civicmin is a thin Usermin/Webmin client for Civic Infrastructure.

It gives a Participant a native Usermin interface for bounded Civic actions while keeping Civic identity, authority, workflow, backend routing, service credentials, and federation outside the UI.

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
    v
Civic Orchestrator
    |
    v
bounded Civic services
```

Civicmin is intended for independent Owner Operators. The Kane deployment is the first reference deployment, not the product boundary.

## Current state

**Status:** `v0.5.0` accepted — release pending

`v0.2.0` established the native Usermin shell, `v0.3.0` established the access-resolved read-only catalog/help path, and `v0.4.0` established the bounded `water-ants` / Publish File local-stub form. `v0.5.0` makes that accepted client installable as part of a portable Owner Operator node.

The Usermin compatibility floor remains 2.550. Portable installation uses the official Webmin/Usermin stable package channel and rejects an installed Usermin older than that floor.

Civicmin development builds have been validated on the Kane reference environment; no stable production deployment is declared.

## Scope

Civicmin owns the participant-facing presentation layer:

- command discovery and grouping;
- bounded forms and uploads;
- help and consequence presentation;
- status, workflow, receipt, and result rendering;
- Usermin-native navigation and theme integration.

Civicmin does **not** own:

- Civic Participant identity;
- command authorization;
- Orchestrator workflow authority;
- backend operation selection;
- service credentials;
- IPFS/Kubo control;
- signing authority;
- enterprise message routing;
- federation or cross-operator trust.

The browser interface is not an authority boundary.

## External authorities

Civicmin development is deliberately constrained by two existing sources.

### Webmin / Usermin

The official upstream repositories define the supported module, authentication, ACL, UI, packaging, and privilege model:

- https://github.com/webmin/webmin
- https://github.com/webmin/usermin

Civicmin should extend Usermin through its supported module system rather than patch upstream code unless an accepted RFC explicitly changes that rule.

### Kane Capabilities

The frozen Civic capability and deployment baseline is:

- https://github.com/git64bit/kane-capabilities

That repository remains authoritative for the accepted Participant identity model, broker boundary, Custom Command registry, semantic bindings, Orchestrator operations, workflow evidence, and prohibited generic execution behaviors.

Civicmin must consume those boundaries, not re-create them.

## Stock Custom Commands

Stock Usermin Custom Commands remains an important reference during development.

Upstream currently supports both:

- `display_mode=0` — expanded commands and parameters on the main page;
- `display_mode=1` — a list of commands that opens a dedicated command form.

The Kane `water-ants` / **Publish File** work already established a useful local broker and identity path. Civicmin development will preserve that accepted boundary while evaluating whether a dedicated Usermin module gives the command family a better long-term participant interface.

## Documentation model

This repository intentionally keeps documentation small.

**`README.md` is the single current operating document.** It changes as the code and current release state change.

Long-lived decisions are recorded separately:

- `rfcs/` — authoritative architecture and contract decisions;
- `bcps/` — authoritative implementation and operating practices.

Accepted RFCs and BCPs are not silently rewritten when a later decision changes them. A later document supersedes the earlier one so the design history remains inspectable.

## Current authoritative records

- [RFC-0001 — Civicmin Scope and Thin-Client Boundary](rfcs/RFC-0001-civicmin-scope-and-thin-client-boundary.md)
- [RFC-0002 — Mail Independence](rfcs/RFC-0002-mail-independence.md)
- [BCP-0001 — Release and Repository Practice](bcps/BCP-0001-release-and-repository-practice.md)
- [BCP-0002 — Explicit Participant Confirmation and Voluntary Evidence](bcps/BCP-0002-explicit-participant-confirmation.md)
- [BCP-0003 — Portable Portal Installation Contract](bcps/BCP-0003-portable-portal-installation-contract.md)
- [BCP-0004 — Upstream Component Versions](bcps/BCP-0004-upstream-component-versions.md)

## Release path

Civicmin uses gate-driven Semantic Versioning rather than calendar releases.

```text
v0.1.0  boundary and upstream baseline
v0.2.0  native Usermin Civicmin shell
v0.3.0  Civic command catalog
v0.4.0  representative local-stub forms
v0.5.0  portable Owner Operator packaging
v0.6.0  Kane reference deployment validation
v0.7.0  authenticated Orchestrator validation
v0.8.0  broader command-family coverage
v0.9.0  independent Owner Operator release candidate
v1.0.0  stable thin-client boundary
```

Milestones may be split or merged when implementation evidence requires it. Tags represent accepted states, not planned dates.

## Portable installation

The cross-repository install entry point is:

```text
INSTALL/install.sh
```

It is run as root, with no arguments, from a pinned `kane-civicmin` release checkout inside the Portal container. The node installer must create the `civic-participants` group and activate `/run/civic-orchestrator/custom-command.sock` before calling it.

The Civicmin installer:

- supports Ubuntu 24.04 LTS for the portable-node baseline;
- installs Webmin and Usermin from the official current stable package channel when needed, without pinning their versions;
- requires Usermin 2.550 or newer as a compatibility floor, not a version pin;
- installs the `civicmin` directory through Usermin's supported module installer;
- is safe to run again to refresh the module from the same checkout;
- does not configure, require, or consume email functionality.

Mail remains entirely an Owner Operator choice under RFC-0002.

## Capability triage

Implementation does not widen scope merely because upstream Usermin/Webmin or Civic Infrastructure exposes additional capabilities.

Useful discoveries outside the active milestone may be noted briefly here with a priority of **triage** or **deferred**. They do not become implementation work until promoted into the active milestone.

Current triage:

- **high triage:** dedicated top-level Usermin category `Civicmin`. Live `v0.3.0` use now shows real crowding under Tools and a growing semantic overlap between native Usermin account information and Civicmin participant context. Upstream Usermin supports operator-defined categories through its normal category-assignment mechanism, so this does not require an upstream patch. Keep Civicmin under Tools while functionality remains the active priority, but revisit this before the participant surface expands beyond the current catalog/help work;
- **triage:** evaluate stock Custom Commands `display_mode=1` as a reference/fallback surface during later command-catalog work;
- **deferred:** Webmin-side Civicmin administration beyond what is required to install and configure the Usermin module;
- **deferred:** enterprise message-broker/federation integration, which belongs below the stable local Civic boundary.

## Immediate work

`v0.5.0` passed its portable-installation acceptance gate on the reference node. A clean one-command node install, Participant onboarding, Usermin login, Civicmin catalog/help, and the complete `water-ants` local-stub Publish File UI path all passed without changing Civic authority state. Webmin 2.670 and Usermin 2.570 were installed from upstream stable; the broker socket and access records remained intact; no mail transport was installed. The installer is deliberately limited to Webmin/Usermin/Civicmin installation and validation; it does not own LXD, Participant onboarding, network enrollment, certificates, mail configuration, or the Orchestrator.

`v0.4.0` passed its acceptance gate with one bounded end-to-end local-stub form for `water-ants` / Publish File. The positive live path passed. The explicit-confirmation, missing-file, and oversized-payload negative paths also passed after UI hardening: Civicmin rejects them locally with participant-safe errors and no local source-path disclosure. The exact 262,144-byte ceiling also passed, while 262,145 bytes was rejected. For the 262,144-byte all-zero test artifact, the broker-returned SHA-256 matched the independently expected digest, confirming byte-for-byte payload fidelity through the Civicmin upload path. A participant-controlled filename containing HTML markup was rendered literally, confirming filename escaping in the result view. A selected zero-byte file also passed as a valid byte payload and was not confused with a missing upload. It does not expose a generic invocation endpoint.

```text
Usermin login
  -> Civicmin
  -> AF_UNIX Custom Command broker
  -> SO_PEERCRED Participant resolution
  -> curated discovery policy
  -> read-only catalog

remote_dispatch=false
side_effects=false
```

`v0.3.0` is released. In accepted `v0.4.0`, only `water-ants` can be submitted. The positive live path has passed on Usermin 2.550: the result rendered `status=stub`, fixed operation `publication.publish`, artifact SHA-256 and byte size, `remote_dispatch=Disabled`, and `External side effects=None`. The handler hard-codes the command identity and accepted semantic binding, enforces the existing 262,144-byte payload ceiling, requires explicit participant acknowledgement, and rejects any response that reports remote dispatch or external side effects.

## Future federation

The wider Civic Infrastructure is expected to gain an enterprise-scale message fabric so independently Owner Operated components can connect and federate.

Civicmin must not depend directly on a specific message-broker product. Its durable responsibility ends at the trusted local Civic boundary:

```text
participant intent
  -> bounded local Civic message
  -> trusted local authority boundary
```

RabbitMQ, NATS, or another later transport belongs beneath that stable contract.

## License

BSD 3-Clause License. See [LICENSE](LICENSE).
