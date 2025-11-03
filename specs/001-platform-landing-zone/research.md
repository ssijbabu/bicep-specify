# Research: Platform Landing Zone — Azure Firewall Hub & Spoke (NZ North)

**Feature**: Platform Landing Zone — Azure Firewall Hub & Spoke (NZ North)
**Spec**: specs/001-platform-landing-zone/spec.md
**Created**: 2025-11-03

## Purpose

Resolve outstanding operational and design questions before Phase 1 (module development). Produce decisions, rationale, and follow-up tasks.

## Decisions

### Decision 1: Azure Firewall SKU
- Decision: Start with Azure Firewall **Standard** and provide a documented upgrade/migration path to **Premium** for workloads that require IDPS/TLS inspection.
- Rationale: Minimizes initial cost and complexity, enables faster delivery. Premium features can be enabled later when a clear business/compliance need exists.
- Alternatives considered: Deploy Premium now (higher cost and operational complexity); defer firewall to application teams (breaks centralised security model).
- Follow-up: Create FR-008 (upgrade/migration plan) and SC-005 (upgrade validation test) in spec (done).

### Decision 2: Observability baseline
- Decision: Use Azure Monitor + Log Analytics workspace per environment (non-prod/prod) with default retention of 90 days; configurable via module parameter.
- Rationale: Azure Monitor is native and integrates with Azure Firewall diagnostics; 90 days balances cost and operational needs for incident investigation.
- Follow-up: Define required metrics and alerts in Phase 1 (e.g., firewall denied/allowed flows, throughput, DNAT hit counts).

### Decision 3: Module distribution
- Decision: Publish internal modules as Git tags and provide examples; prefer Azure Verified modules when they meet policy and security checks.
- Rationale: Git tag distribution is simple, integrates with CI, and supports semantic versioning. Azure Verified modules provide provenance where applicable.
- Follow-up: Create module publishing workflow in CI (packaging and tagging) in Phase 1.

### Decision 4: Quota & capacity validation
- Decision: Implement automated pre-deployment checks in the pipeline to validate subscription quotas (vCPUs, firewall SKUs) and fail with remediation guidance.
- Rationale: Quota failures are common friction points; early detection reduces failed deployments and human troubleshooting.
- Follow-up: Research quota API calls and implement validation tasks in pipeline.

## Research Tasks (Phase 0)

- T-R1: Identify exact ARM resource limits and quota endpoints for Azure Firewall and required SKUs in New Zealand North.
- T-R2: Catalog Azure Monitor diagnostic settings required for Azure Firewall and determine cost estimates for retention options.
- T-R3: Produce a naming/tagging sample that aligns with corporate standard (if provided) or propose a default naming scheme for this project.
- T-R4: Verify availability of Azure Verified Bicep modules for firewall/hub patterns and evaluate suitability.

## Summary

All critical clarifications for initial delivery have been resolved (Firewall SKU choice). The Phase 0 research tasks above will be executed in parallel with Phase 1 work where possible; results will feed into module design, CI pipeline, and runbooks.
