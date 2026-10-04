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

**Status:** `v0.3.0` development

`v0.2.0` was released as the first native Usermin shell after a complete install/render/remove/reinstall/remove acceptance cycle on Usermin 2.550. Development has advanced to `v0.3.0`: a read-only, access-resolved Civic command catalog using the existing local Custom Command broker boundary. No command invocation is added.

The current Kane reference deployment uses Usermin 2.550 as the initial compatibility floor. Current upstream Usermin is also examined for forward compatibility.

No production Civicmin module has been installed yet.

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
- [BCP-0001 — Release and Repository Practice](bcps/BCP-0001-release-and-repository-practice.md)

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

## Capability triage

Implementation does not widen scope merely because upstream Usermin/Webmin or Civic Infrastructure exposes additional capabilities.

Useful discoveries outside the active milestone may be noted briefly here with a priority of **triage** or **deferred**. They do not become implementation work until promoted into the active milestone.

Current triage:

- **triage:** dedicated Civicmin top-level Usermin category and future separation of participant-facing and administrative surfaces. Keep Civicmin under Tools while functionality is the active priority;
- **triage:** evaluate stock Custom Commands `display_mode=1` as a reference/fallback surface during later command-catalog work;
- **deferred:** Webmin-side Civicmin administration beyond what is required to install and configure the Usermin module;
- **deferred:** enterprise message-broker/federation integration, which belongs below the stable local Civic boundary.

## Immediate work

The active `v0.3.0` milestone is deliberately limited to command discovery. Civicmin asks the existing local Custom Command broker for the commands discoverable to the current Participant and renders only the broker-returned catalog.

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

There is no command invocation, form submission, upload, Orchestrator call, or external side effect in this milestone.

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
