# Feature Specification: Platform Landing Zone — Azure Firewall Hub & Spoke (NZ North)

**Feature Branch**: `001-platform-landing-zone`
**Created**: 2025-11-03
**Status**: Draft
**Input**: User description: "Build an Azure Platform Landing Zone that will be deployed with Azure Bicep and Azure DevOps pipelines. The Landing Zone will use an Azure Firewall, with Hub and Spoke networking (/16 for the entire region) and will be deployed to the New Zealand North Azure region. Although not in the scope of the build, we need to make sure that the Platform Landing Zone will easily allow the addition of Application Landing Zones in the future."

## Clarifications

### Session 2025-11-03

- Q: Azure Firewall SKU selection (impact: cost, features) → A: Start with Standard and enable Premium for specific workloads later

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Deploy platform foundation (Priority: P1)

As a cloud platform engineer, I want an automated, repeatable landing zone deployment so that I can provision a secure, compliant platform foundation in the New Zealand North region and on-board application teams later.

**Why this priority**: Platform foundation is required before any application landing zone can be deployed.

**Independent Test**: Execute the pipeline against an isolated subscription and verify that management groups, platform subscription(s), hub VNet, spoke VNet skeletons, Azure Firewall, and policy assignments are deployed and validated.

**Acceptance Scenarios**:

1. **Given** an empty subscription and management-group connectivity, **When** the pipeline runs, **Then** the hub VNet and an Azure Firewall instance are created and a test VM or traceroute confirms traffic egress path through the firewall.
2. **Given** the pipeline run, **When** it completes, **Then** policy assignments for required tags and allowed resource types are in effect and report no blocking violations in the test environment.
3. **Given** the deployed artifacts, **When** a new spoke VNet module is invoked, **Then** it attaches to the hub (peer or vnet-to-vnet) and routes traffic via the hub firewall without modifying hub code.

---

### User Story 2 - Enable predictable networking and extensibility (Priority: P2)

As a networking engineer, I want the hub and spoke address plan and connectivity patterns documented and enforced so that application teams can create application landing zones that interoperate with the platform.

**Independent Test**: Validate that new spoke modules can be instantiated with sample parameters and that routing and NSG defaults route traffic to the hub firewall and maintain address space constraints.

**Acceptance Scenarios**:

1. **Given** the hub address space assigned (/16 for the region), **When** a spoke request is created with /24 allocation within the hub /16, **Then** it is accepted and routable to the hub.
2. **Given** an attempt to create a spoke with an overlapping address range, **When** validation runs, **Then** the deployment is rejected with a clear error describing the overlap.

---

## Edge Cases

- What happens if the subscription already contains resources with conflicting names or address spaces? The pipeline MUST detect and fail with an informative message.
- How does the system behave if Azure Firewall SKU quotas prevent provisioning? The pipeline MUST detect quota failures and surface remediation steps.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST provision a Hub VNet in the New Zealand North region with the specified /16 address space and at least one subnet reserved for Azure Firewall and platform services.
- **FR-002**: The system MUST provision an Azure Firewall instance (configurable SKU) in the Hub and configure routing so that spoke-to-internet and spoke-to-spoke traffic traverse the firewall as the default path.
- **FR-003**: The solution MUST be authored as reusable Bicep modules for core platform components (management groups, subscriptions scaffolding, hub, spokes, firewall, policies) and include module examples and inputs/outputs documentation.
- **FR-004**: The solution MUST provide an Azure DevOps pipeline (YAML) that performs validation (bicep build), static linting, policy-as-code checks, and a non-destructive `what-if`/plan stage; production deployments MUST require manual approval.
- **FR-005**: The solution MUST include Azure Policy/Initiative definitions or assignments that enforce tagging, allowed SKUs/types, and required platform guardrails; policy definitions MUST be applied in a test non-production subscription first.
- **FR-006**: The solution MUST include tests/validation gates that verify module idempotency and that a spoke module can be attached without hub code changes.
- **FR-007**: The solution MUST provide documentation (quickstart) showing how to instantiate a new Application Landing Zone that connects to the platform hub.
- **FR-008**: The solution MUST include a documented upgrade/migration plan and validation tests for moving from Azure Firewall Standard to Premium (covering IDPS/TLS inspection impacts) so teams can adopt Premium features when required.

*Reasonable defaults and constraints are listed in Assumptions below.*

### Key Entities *(include if feature involves data)*

- **Management Group**: Organizational grouping for policy and subscription hierarchy.
- **Platform Subscription**: Subscription holding platform services (firewall, bastion, monitoring).
- **Hub VNet**: Central virtual network hosting Azure Firewall and shared services.
- **Spoke VNet**: Per-application or per-team virtual network that peers to hub.
- **Azure Firewall**: Centralized network virtual appliance for east-west and north-south traffic.
- **Bicep Modules**: Reusable infrastructure modules implementing the above constructs.
- **Azure DevOps Pipeline**: CI/CD pipeline that validates and deploys the Bicep modules.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Platform baseline deploy (hub, firewall, baseline policies) can be provisioned end-to-end in under 45 minutes in an isolated subscription when executed by the pipeline.
- **SC-002**: 100% of policy-as-code checks pass in non-production before production rollout (no blocking violations allowed in the gating environment).
- **SC-003**: Creating a new spoke via the provided spoke module succeeds with zero manual changes to hub code in 95% of test runs.
- **SC-004**: Post-deployment verification tests (connectivity, routing to firewall, required tags present) pass automatically in CI for at least 90% of automated test runs.

- **SC-005**: An upgrade validation test (simulated or actual non-production upgrade) verifies that Premium-only features (IDPS, TLS inspection) can be enabled without loss of core connectivity in at least 90% of runs.

## Assumptions

- The organization approves New Zealand North (nznorth) as the target region and has capacity/quota for required resources.
- Management group and subscription structure exist or will be created by platform owners; the spec focuses on the platform subscription and networking layout.
- Default Azure Firewall SKU: **Standard** unless otherwise specified. (See Q1 below for SKU decision.)
- Default Azure Firewall SKU: **Standard** unless otherwise specified. The platform will include an upgrade/migration path to Premium; migration steps, validation tests, and potential downtime/impact notes will be documented as part of deliverables.
- Naming and tagging conventions are available or will be provided; the implementation will follow corporate standards.
- Roadmap: Application Landing Zones will be implemented later and must be able to be instantiated using the provided spoke module contract.

## Constraints

- Address space for the whole region is specified as a single /16 for the hub/spoke pool.
- Deployments will target the New Zealand North region only for this work; multi-region support is out-of-scope for the initial delivery.

## Questions & Clarifications (NEEDS CLARIFICATION)

### Q1: Azure Firewall SKU selection (impact: cost, features)

**Context**: Azure Firewall is required. SKU choice (Standard vs Premium) affects features (IDPS, TLS inspection) and cost.

**What we need to know**: Which Azure Firewall SKU should the initial platform deploy use?

**Suggested Answers**:

| Option | Answer | Implications |
|--------|--------|--------------|
| A | Standard | Lower cost; provides basic Stateful firewall features. No TLS inspection or IDPS. Suitable for many common scenarios. |
| B | Premium | Includes IDPS, TLS inspection, and more advanced features. Higher cost and may require additional design considerations. |
| C | Start with Standard and enable Premium for specific workloads later | Allows delivery to proceed quickly with an upgrade path; Premium adoption would require planning for traffic inspection and potential downtime during migration. |
| Custom | Provide an organizational decision | We will adopt the chosen SKU and document upgrade/migration steps. |

**Your choice**: _[Please pick one option or provide a custom decision]_

---

## Deliverables

- Bicep modules: management-groups, subscription-scaffold, hub-network, spoke-network, firewall, policy-definitions, role assignments.
- Azure DevOps pipeline YAML files for validation (lint, bicep build), pre-flight `what-if`, and deployment; production pipeline stage requires manual approval.
- Quickstart and README with example parameters and a sample spoke instantiation to demonstrate Application Landing Zone onboarding.
- Automated tests for idempotency and basic connectivity checks.

## Timeline (high level)

1. Phase 0 — Design & address plan: 1 week
2. Phase 1 — Module development & CI: 2-3 weeks
3. Phase 2 — Policy definitions & test deployments: 1-2 weeks
4. Phase 3 — Documentation, runbooks, handover: 1 week



