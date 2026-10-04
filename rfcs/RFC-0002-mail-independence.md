# RFC-0002 — Mail Independence

Number: RFC-0002  
Title: Mail Independence  
Status: Accepted  
Date: 2026-10-04  
Supersedes: none  
Superseded-by: none  
Related: RFC-0001

## Decision

Civicmin and the portable Civic Infrastructure boundary must not depend on Usermin email functionality.

Mail configuration is an Owner Operator choice. Civicmin must not require a particular mail service or workflow for installation, identity, authorization, command execution, evidence, recovery, or normal operation.

The Kane deployment's current Usermin mail configuration is reference-site policy only and is not a product requirement.

Any future Civic feature that intentionally uses email requires a separate accepted contract.
