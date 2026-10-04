# BCP-0001 — Release and Repository Practice

Number: BCP-0001  
Title: Release and Repository Practice  
Status: Accepted  
Date: 2026-10-04  
Supersedes: none  
Superseded-by: none  
Related: RFC-0001

## Purpose

Keep Civicmin development simple, inspectable, and useful to independent Owner Operators.

There is one active implementation repository and one current operating document.

## Repository practice

`README.md` is the single current operating document.

It should contain the current project state, supported baseline, active milestone, release path, and enough information for a new Owner Operator to understand the project.

Do not create separate living architecture, deployment, compatibility, or roadmap documents merely to duplicate current state.

Long-lived decisions belong in:

```text
rfcs/
bcps/
```

RFCs record architecture and contract decisions.

BCPs record accepted implementation and operating practices.

## RFC and BCP lifecycle

Documents use these states:

```text
Draft
Accepted
Superseded
Withdrawn
```

An Accepted RFC or BCP should not be silently rewritten to reverse its accepted decision.

If a decision materially changes, create a new RFC or BCP and mark the earlier document as superseded.

Minor editorial corrections that do not change meaning are allowed.

## Versioning

Civicmin uses Semantic Versioning:

```text
vMAJOR.MINOR.PATCH
```

Before `v1.0.0`, minor versions are acceptance milestones.

Release candidates use:

```text
vX.Y.Z-rc.N
```

Tags are created only for repository states that have passed their milestone acceptance gate.

Ordinary development commits are not tagged.

Patch releases correct defects without intentionally widening the supported Civic surface.

Minor releases may add bounded compatible capability or participant-facing surface.

## Current release path

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

This is gate-driven, not calendar-driven.

Milestones may split or merge when implementation evidence justifies it. The README must be updated when the active path changes.

## Release notes

A tagged release should state at minimum:

- supported Usermin baseline;
- required Civic contract baseline;
- meaningful participant-facing changes;
- configuration or migration requirements;
- known limitations.

## Scope discipline

The official Webmin/Usermin repositories are the authority for supported host-extension behavior.

The frozen `git64bit/kane-capabilities` repository is the authority for the existing Civic boundary.

Research should be limited to what is needed for the active milestone.

Implementation should not widen scope merely because upstream or Civic infrastructure exposes additional capabilities.
