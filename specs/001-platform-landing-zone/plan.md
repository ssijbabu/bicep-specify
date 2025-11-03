# Implementation Plan: Platform Landing Zone — Azure Firewall Hub & Spoke (NZ North)

**Branch**: `001-platform-landing-zone` | **Date**: 2025-11-03 | **Spec**: `specs/001-platform-landing-zone/spec.md`
**Input**: Feature specification from `specs/001-platform-landing-zone/spec.md`

## Summary

Provide a reusable, CAF-aligned Azure Platform Landing Zone for the New Zealand North region
implemented with Bicep and deployed via Azure DevOps pipelines. Core capabilities: management
group & subscription scaffolding, a hub VNet with a centralized Azure Firewall (Default: Standard,
upgradeable to Premium), spoke module contract for Application Landing Zones, and policy-as-code
guardrails. Deliverables include Bicep modules, CI pipeline YAML, policy definitions, and
runbooks for Day‑2 operations.

## Technical Context

**Language/Version**: Bicep (latest stable compiler at time of CI run; pin Bicep CLI via pipeline)  
**Primary Dependencies**: Azure Resource Manager (ARM) APIs, Azure DevOps (pipelines), Azure Policy,
Azure Monitor / Log Analytics (for observability).  
**Storage**: N/A for core infra (Log Analytics workspace for telemetry)  
**Testing**: bicep build/validate, bicep linter rules (static), policy-as-code evaluation, `what-if` plan stage,
and idempotency integration tests executed in isolated subscriptions.  
**Target Platform**: Microsoft Azure — New Zealand North (nznorth) region.  
**Project Type**: Infrastructure-as-Code / Platform automation  
**Performance Goals**: Not applicable for platform provisioning; aim: pipeline full validation & non-prod deploy within 45 minutes.  
**Constraints**: Single-region (/16 address pool for hub+spokes), Azure Firewall initially Standard; subscription quotas and SKUs must be validated during deployment.  
**Scale/Scope**: Enterprise-scale landing zone for one region; supports many spokes (per-app / per-team) with /24 subnets by default.

## Constitution Check

Gates derived from `.specify/memory/constitution.md` (v1.0.0). All gates must pass or have documented justification.

- Gate: Infrastructure language MUST be Bicep — PASS (all planned modules authored in Bicep).
- Gate: Policy-as-code MUST be present and enforced pre/post-deploy — PASS (policy definitions and assignments included in plan).
- Gate: Modules MUST be composable, versioned, and documented — PASS (plan includes modular design and versioning guidelines).
- Gate: Prefer Azure Verified modules where appropriate — PASS with note (team will prefer verified modules for common patterns and perform review before adoption).
- Gate: Security & least privilege enforced (Key Vault for secrets, RBAC scoping) — PASS (RBAC and Key Vault included in module contracts; to be validated in Phase 1).
- Gate: Day‑2 operational requirements (observability, runbooks, upgrade plans) — PASS with follow-up (observability defaults and runbooks will be further specified in Phase 1).

Notes: All gates currently satisfied at design level; follow-up items (observability retention, quota handling, naming/tagging canonical list) are tracked as Phase 0 research tasks and Phase 1 deliverables. No gate failures block Phase 0 research.

## Project Structure (selected)

Repository will hold modules and pipeline definitions under `infra/` and `pipelines/` in repo root. The `specs/001-platform-landing-zone/` folder will contain plan, research, and artifacts for handover.

### Documentation (this feature)

```text
specs/001-platform-landing-zone/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── hub-module.md
│   └── spoke-module.md
└── tasks.md (created during speckit.tasks)
```

**Structure Decision**: Infrastructure modules published under `infra/modules/*` with examples in `infra/examples/*`. CI pipeline YAML stored under `pipelines/landing-zone/*.yaml`.

## Complexity Tracking

No Constitution gate violations requiring justification. Complexity items tracked: subscription quota handling and observability/retention policy (research tasks defined below).
