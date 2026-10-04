# RFC-0001 — Civicmin Scope and Thin-Client Boundary

Number: RFC-0001  
Title: Civicmin Scope and Thin-Client Boundary  
Status: Accepted  
Date: 2026-10-04  
Supersedes: none  
Superseded-by: none  
Related: BCP-0001, git64bit/kane-capabilities

## Decision

Civicmin is a thin participant-facing Usermin/Webmin client.

It may present bounded Civic actions, collect bounded Participant input, submit bounded local Civic requests, and render returned status or evidence.

Civicmin does not own Civic authority.

The durable boundary is:

```text
Participant
    |
    v
Usermin / Civicmin
    |
    | bounded local request
    v
trusted local Civic boundary
    |
    v
Civic Orchestrator
    |
    v
bounded Civic services
```

## Authority boundary

Civicmin must not become the authority for:

- Participant identity;
- command entitlement;
- semantic operation selection;
- backend routing;
- workflow state;
- service credentials;
- signing authority;
- publication authority;
- IPFS/Kubo administration;
- federation or cross-operator trust.

The local trusted Civic boundary must independently establish identity and authorization.

A command appearing in Civicmin is not authorization to execute it.

## Transport boundary

Civicmin must not embed a permanent dependency on the remote transport used behind the local Civic boundary.

HTTP, AF_UNIX, RabbitMQ, NATS, or any later message transport may evolve without changing Civicmin's participant-facing authority model.

Civicmin therefore communicates with the local admitted Civic interface, not directly with arbitrary remote services.

## Upstream boundary

Civicmin should use the supported Webmin/Usermin module system and UI libraries.

Patching the upstream Webmin/Usermin source tree is not the default design. Any future requirement to modify upstream code requires a separate accepted RFC.

## Portability

Civicmin is intended for independent Owner Operators.

Kane-specific hostnames, account names, network addresses, credentials, and service topology must not become source-code assumptions.

The Kane deployment is a reference and acceptance environment only.

## Relationship to frozen Civic work

The frozen `git64bit/kane-capabilities` repository remains authoritative for the existing Civic identity, broker, command, operation, workflow, and security boundaries.

Civicmin may adapt those contracts for presentation but must not silently redefine them.

## Consequence

The Civicmin repository can evolve its UI rapidly while the Civic authority plane remains stable.

The eventual enterprise federation/message layer can be introduced independently because Civicmin does not own that layer.
