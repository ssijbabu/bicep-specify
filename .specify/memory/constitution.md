<!--
Sync Impact Report

- Version change: UNVERSIONED/placeholder -> 1.0.0
- Modified principles: (added/defined) Modularity & Composition; Reusability & Packaging (includes Azure Verified guidance); Security & Least Privilege; Compliance & Policy-as-Code; Operational Excellence (Observability, Day-2, Testing)
- Added sections: Platform Constraints & Requirements; Development Workflow & Quality Gates
- Removed sections: none
- Templates requiring review/update:
	- .specify/templates/plan-template.md — ✅ Constitution Check present; review to ensure the gate points to this constitution and lists new mandatory checks (⚠ pending manual update)
	- .specify/templates/spec-template.md — ⚠ may require explicit sections for 'Platform Constraints' and 'Compliance' (pending)
	- .specify/templates/tasks-template.md — ⚠ consider adding Day-2/operational tasks categories (pending)
	- .specify/templates/checklist-template.md — ⚠ review for agent/tool-specific language and update references (pending)
	- .specify/templates/agent-file-template.md — ⚠ review for agent-specific references if present (pending)

- Follow-up TODOs:
	- TODO(RATIFICATION_DATE): Confirm and record the original ratification date.
	- Manual review required for templates listed above to add explicit cross-references and automated checks.
-->

# Bicep Specify Landing Zone Constitution

## Core Principles

### 1. Modularity & Composition
Every platform capability MUST be designed as a composable module with a clear, single responsibility. Modules MUST be small, parameterized, and publish stable inputs/outputs. Modules MUST be versioned independently and avoid hidden side-effects (no implicit resource creation outside the module contract).

Rationale: Modular building blocks enable safe composition across subscriptions, accelerate reuse, and reduce blast radius when changing infrastructure.

### 2. Reusability & Packaging
All reusable infrastructure constructs MUST be authored as Bicep modules, packaged with clear metadata (semantic version, changelog, inputs/outputs, examples). Modules MUST include a calling example and a preview of required permissions. Shared modules SHOULD be published to an internal module registry or Git tags and SHOULD follow semantic versioning (MAJOR.MINOR.PATCH).

Where an officially supported or community module exists, prefer Azure Verified modules when they meet requirements: Azure Verified modules (or vendor-provided verified artifacts) SHOULD be preferred for common patterns because they carry provenance and support guarantees; however, using a verified module DOES NOT replace security and compliance review. The team MUST validate module inputs, required permissions, and any managed identity behavior before adoption.

Rationale: Packaging enables consistent adoption, easier reviews, and predictable upgrades across environments while Azure Verified modules accelerate delivery and provide additional assurance of quality.

### 3. Security & Least Privilege
Security is non-negotiable. All deployments MUST follow least-privilege principles: identities, managed identities, and service principals MUST be scoped to the minimal required RBAC roles. Secrets MUST NOT be hard-coded; secrets and certificates MUST be referenced via Azure Key Vault and consumed through secure references. Network boundaries, NSGs, and private endpoints MUST be used where appropriate to reduce exposure.

Rationale: Preventing privilege creep and centralizing secrets reduces attack surface and simplifies audits.

### 4. Compliance & Policy-as-Code
Platform governance MUST be codified. Organizational policies (Azure Policy / Initiative definitions, Management Group layout, subscription boundaries) MUST be represented as code and enforced pre- and post-deployment. All landing zone designs MUST include compliance mapping (e.g., CIS, ISO, NIST if required) and automated policy evaluation in CI.

Rationale: Policy-as-code ensures consistent enforcement, enables automated checks, and documents the compliance posture for audits.

### 5. Operational Excellence (Observability, Day‑2, Testing)
The platform MUST be instrumented for Day‑2 operations. Deployments MUST include logging, metrics, and health probes appropriate to the resource type. Bicep modules MUST include deployment validation and safeguard tests (what will be deployed, idempotency checks). Runbooks and owners MUST be documented for each critical resource. Upgrade and rollback procedures MUST be defined for each module (including migration paths for MAJOR version changes).

Rationale: Landing zones are long-lived. Preparing for Day‑2 — monitoring, patching, and incident response — reduces operational risk and mean time to recovery.

## Platform Constraints & Requirements

- Platform design MUST align to the Microsoft Cloud Adoption Framework (CAF) design principles: enterprise-scale, security-first, identity and access management, networking topology, management groups, and subscription design.
- Infrastructure-as-Code language: Bicep (targeted). All new infrastructure constructs MUST be authored in Bicep and compiled/validated in CI. Reuse of stable community modules is ALLOWED only after security and compliance review.
- Naming, tagging, and resource organization MUST follow the corporate naming and tagging policy; each resource MUST include standard tags: owner, environment, cost-center, compliance. Tagging MUST be enforced via policy where possible.
- Subscription topology: management groups and subscription boundaries MUST be documented; resource group scope policies and RBAC MUST reflect least-privilege and separation of duties.
- Policy & guardrails: Azure Policy initiatives that enforce security, cost, and compliance constraints MUST be applied and tested in non-prod before prod rollout.

## Development Workflow & Quality Gates

- Source control: All infra code MUST be stored in Git with branch protection. Pull Requests MUST include: a changelog entry, deployment plan (what changes), and template/plan diffs produced by `bicep build` + `what-if` outputs where applicable.
- CI checks (pre-merge):
	- Linting (bicep linter rules) MUST pass.
	- Module contract tests (unit) SHOULD run for parametrized modules.
	- Static security scans (e.g., for insecure configurations) MUST run and block merges on severe findings.
	- Policy-as-code evaluation (arm/policy tests) SHOULD run and flag violations.
- PR review: At least one platform owner or module maintainer MUST approve infrastructure changes that affect shared modules, policies, or management groups.
- Deployment: All env changes MUST be applied via automated pipelines; manual approvals are required for production scope changes. Deployment pipelines MUST run an infra 'plan' (what-if) and require explicit approval for destructive or MAJOR version changes.
- Testing: Integration/acceptance tests for real resources SHOULD be run in isolated subscriptions or short-lived environments; tests MUST be idempotent and tear down after completion.

## Governance

Amendments: Amendments to this constitution MUST be proposed as a documented change (PR) against `.specify/memory/constitution.md`. Amendments require at least one platform owner review and a majority approval from approvers defined in the repositoryOWNERS file (or equivalent). Major governance changes that alter eligibility, remove, or rename core principles are a MAJOR version bump and MUST include a migration plan.

Versioning policy:
- MAJOR: Backward-incompatible governance changes (remove/rename principles, change enforcement model).
- MINOR: Add new principle, new mandatory section, or material expansion of guidance.
- PATCH: Clarifications, typo fixes, wording or non-semantic refinements.

Compliance review expectations:
- Significant releases (policy changes, new management group layout, subscription structure changes) MUST be reviewed by security/compliance stakeholders and validated in a non-production staging environment before production rollout.

**Version**: 1.0.0 | **Ratified**: TODO(RATIFICATION_DATE): provide original adoption date | **Last Amended**: 2025-11-03
