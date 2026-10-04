# BCP-0003 — Portable Portal Installation Contract

Number: BCP-0003  
Title: Portable Portal Installation Contract  
Status: Accepted  
Date: 2026-10-04  
Supersedes: none  
Superseded-by: none  
Related: RFC-0001, RFC-0002, BCP-0001, kane-orchestrator RFC-0002

## Purpose

Define the narrow installation boundary between the portable Civic Infrastructure node installer and `kane-civicmin`.

## Contract

The `kane-orchestrator` node installer may clone a pinned `kane-civicmin` release into the Portal container and invoke:

```text
INSTALL/install.sh
```

The entry point is run:

- as root;
- with no arguments;
- from the pinned Civicmin checkout;
- after the `civic-participants` group exists;
- after `/run/civic-orchestrator/custom-command.sock` is active with group `civic-participants` and mode `0660`.

The Civicmin installer owns only the Portal presentation stack: Webmin, Usermin, and the Civicmin Usermin module. The node installer remains responsible for Ubuntu/LXD topology, containers, Participant onboarding, the broker, the Orchestrator, networking, and enrollment.

## Supported baseline

The portable-node baseline is Ubuntu 24.04 LTS.

Civicmin requires Usermin 2.550 or newer. When Webmin/Usermin are absent, the installer configures the official stable Webmin/Usermin package channel and installs them. Civicmin is then installed through Usermin's supported module installation mechanism rather than by patching upstream files.

The installer is idempotent: running it again refreshes the Civicmin module from the same checkout without changing Civic authority state.

## Mail independence

Installation does not configure, require, test, or consume email functionality.

Usermin mail may be enabled, disabled, local, forwarded, externally hosted, or otherwise configured by the Owner Operator. This preserves RFC-0002.

## Authority boundary

Installation does not grant Civic command access, create Participant identities, select Civic operations, or install service credentials.

The presence of the Civicmin module is presentation only. The local broker independently resolves Participant identity and command authorization.

## Consequence

`kane-orchestrator` can install a pinned Civicmin release without knowing Webmin/Usermin implementation details, while `kane-civicmin` remains independently installable and testable.
