# BCP-0004 — Upstream Component Versions

Number: BCP-0004  
Title: Upstream Component Versions  
Status: Accepted  
Date: 2026-10-04  
Supersedes: none  
Superseded-by: none  
Related: BCP-0001, BCP-0003, kane-orchestrator BCP-0003

## Practice

Only Civicmin releases are pinned by this repository.

Upstream Webmin and Usermin are installed from their current stable upstream package channel and are not pinned to a particular upstream release or repository commit.

The current Usermin compatibility floor remains:

```text
Usermin >= 2.550
```

A compatibility floor is not a pin. It protects a Civicmin contract that has already been validated while still allowing current stable upstream releases to expose incompatibilities during development.

Ubuntu 24.04 LTS remains the supported portable-node operating-system baseline until a later accepted record changes that platform baseline.

## Reason

Tracking current stable upstream Webmin/Usermin releases keeps Civicmin exposed to upstream changes while those changes are still cheap to diagnose and adapt to.

Pinning upstream versions would add maintenance and could hide compatibility problems that independent Owner Operators will otherwise encounter.

## Revisiting

An upstream component may be pinned later by a new BCP when a concrete compatibility defect, security requirement, or release-candidate reproducibility requirement justifies it.

Until then, Civicmin must not silently introduce an upstream version pin.
