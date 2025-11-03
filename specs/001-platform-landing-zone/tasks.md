---
description: "Task list for Platform Landing Zone: Azure Firewall Hub & Spoke (NZ North)"
---

# Tasks: Platform Landing Zone — Azure Firewall Hub & Spoke (NZ North)

**Input**: Design documents from `/specs/001-platform-landing-zone/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

## Phase 1: Setup (Shared Infrastructure)

- [ ] T001 Initialize repository structure for infra and pipelines - create `infra/modules/`, `infra/examples/`, `pipelines/landing-zone/` and add README (infra/README.md)
- [ ] T002 [P] Create initial `infra/modules/hub/main.bicep` scaffold with parameter placeholders and outputs (infra/modules/hub/main.bicep)
- [ ] T003 [P] Create initial `infra/modules/firewall/main.bicep` scaffold with parameters (sku, diagnostics) and outputs (infra/modules/firewall/main.bicep)
- [ ] T004 [P] Create initial `infra/modules/spoke/main.bicep` scaffold with parameters and peering logic (infra/modules/spoke/main.bicep)
- [ ] T005 Create example parameter files for non-prod and prod (examples/nonprod/parameters.json, examples/prod/parameters.json)
- [ ] T006 [P] Add `pipelines/landing-zone/validate.yaml` and `pipelines/landing-zone/deploy.yaml` skeletons (pipelines/landing-zone/validate.yaml)
- [ ] T007 [P] Add basic `README.md` and quickstart pointers in `specs/001-platform-landing-zone/quickstart.md` (specs/001-platform-landing-zone/quickstart.md)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infra that MUST be complete before US work (spoke on-boarding) can begin.

- [ ] T008 Validate Bicep modules compile: run `bicep build` for hub, firewall, spoke and fix syntax errors (infra/modules/hub/main.bicep)
- [ ] T009 [P] Implement module contract enforcement: add README and examples per module including inputs/outputs and required permissions (infra/modules/*/README.md)
- [ ] T010 Implement policy-as-code skeleton (policy/initiative definitions) and store in `infra/policy/` (infra/policy/initiative.json)
 - [ ] T010 Implement policy-as-code skeleton (policy/initiative definitions) and store in `infra/policy/` (infra/policy/initiative.json)
 - [ ] T010b Add policy-as-code evaluation step to validate pipeline (pipelines/landing-zone/validate.yaml)
- [ ] T011 Implement Key Vault integration pattern in a secure module (infra/modules/secrets/main.bicep)
- [ ] T012 Implement quota & capacity pre-check script in `pipelines/scripts/check-quotas.sh` and integrate into validate pipeline (pipelines/scripts/check-quotas.sh)
- [ ] T013 [P] Create Log Analytics workspace module and diagnostic settings for Azure Firewall (infra/modules/monitoring/main.bicep)
- [ ] T014 [P] Create role assignment module to scope minimal RBAC for platform components (infra/modules/roles/main.bicep)
 - [ ] T015 Define naming & tagging defaults in `infra/standards/naming.md` and add a policy sample to enforce tags (infra/standards/naming.md)

**Checkpoint**: Foundational tasks complete — hub & firewall modules are validated, policy skeleton in place, observability configured.

---

## Phase 3: User Story 1 - Deploy platform foundation (Priority: P1) 🎯 MVP

**Goal**: Deliver a repeatable pipeline that provisions the Hub VNet, Azure Firewall (Standard), baseline policies, and basic observability.

**Independent Test**: Run the `deploy` pipeline in a non-prod subscription and verify hub VNet, firewall, and policy assignments exist; test VM in sample spoke shows traffic egress through firewall.

### Tasks

- [ ] T016 [US1] Implement `infra/modules/hub/main.bicep` full implementation (subnets, route tables) (infra/modules/hub/main.bicep)
- [ ] T017 [US1] Implement `infra/modules/firewall/main.bicep` full implementation and connect to hub (infra/modules/firewall/main.bicep)
- [ ] T018 [US1] Implement `infra/modules/monitoring/main.bicep` to wire firewall diagnostics to Log Analytics (infra/modules/monitoring/main.bicep)
- [ ] T019 [US1] Create `pipelines/landing-zone/deploy.yaml` production-ready stage with manual approval (pipelines/landing-zone/deploy.yaml)
- [ ] T020 [US1] Add `examples/nonprod/parameters.json` with hub address space example (examples/nonprod/parameters.json)
- [ ] T021 [US1] Create an automated post-deploy verification script `pipelines/scripts/post-deploy-verify.sh` that checks: hub VNet exists, firewall exists, route table entries exist, sample VM connectivity (pipelines/scripts/post-deploy-verify.sh)
- [ ] T022 [US1] Document runbook for initial deployment and rollback steps (docs/runbooks/platform-deploy.md)
- [ ] T023 [US1] Add FR-008 upgrade/migration plan doc: `docs/firewall-upgrade.md` with validation steps to enable Premium (docs/firewall-upgrade.md)
- [ ] T024 [US1] Create integration test that provisions hub+firewall in isolated subscription and runs `post-deploy-verify` (tests/integration/test_hub_firewall.sh)
 - [ ] T024 [US1] Create integration test that provisions hub+firewall in isolated subscription and runs `post-deploy-verify` (tests/integration/test_hub_firewall.sh)
 - [ ] T024b [US1] Integration idempotency test: run deploy twice (or what-if twice) and assert no-delta on second run (tests/integration/idempotency_test.sh)

**Checkpoint**: Platform baseline deployable and verifiable via pipeline.

---

## Phase 4: User Story 2 - Enable predictable networking and extensibility (Priority: P2)

**Goal**: Deliver reusable spoke module and validation to allow Application Landing Zones to be created without hub changes.

**Independent Test**: Instantiate a sample spoke using `infra/modules/spoke` with a /24 inside hub /16 and verify peering, routing to firewall, and non-overlap validation.

### Tasks

- [ ] T025 [US2] Implement `infra/modules/spoke/main.bicep` full implementation (peering, route tables, NSG defaults) (infra/modules/spoke/main.bicep)
- [ ] T026 [US2] Add validation logic in spoke module to prevent overlapping prefixes (infra/modules/spoke/validate.ps1 or .sh)
- [ ] T027 [US2] Create example `examples/nonprod/spoke-parameters.json` for spoke instantiation (examples/nonprod/spoke-parameters.json)
- [ ] T028 [US2] Create a contract test that asserts spoke outputs and peering can be created without editing hub (tests/contract/test_spoke_contract.sh)
- [ ] T029 [US2] Document spoke onboarding quickstart in `specs/001-platform-landing-zone/quickstart.md` (specs/001-platform-landing-zone/quickstart.md)
- [ ] T030 [US2] Add route propagation and NSG baseline rules as reusable ARM templates or Bicep fragments (infra/modules/network/rules.bicep)

**Checkpoint**: Application teams can instantiate Application Landing Zones (spokes) using the provided module with no hub code changes.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Improvements affecting multiple user stories and hardening before handover.

- [ ] T031 [P] Add automated static security scans (e.g., checkov or similar) into `pipelines/landing-zone/validate.yaml` (pipelines/landing-zone/validate.yaml)
- [ ] T032 [P] Add policy-as-code tests into CI to validate policies in infra/policy/ (infra/policy/tests/)
- [ ] T033 [ ] Configure alerting/monitoring rules and runbook links in `infra/modules/monitoring` (infra/modules/monitoring/alerts.md)
- [ ] T034 [ ] Add cost estimation job in pipeline to estimate expected monthly cost for selected SKUs (pipelines/scripts/estimate-cost.sh)
- [ ] T035 [ ] Finalize documentation: quickstart, runbooks, architecture decision records (ADR) in `docs/` (docs/architecture/adr-*.md)
- [ ] T036 [ ] Create a handover checklist for platform owners and run a knowledge transfer session (docs/handover.md)

---

## Dependencies & Execution Order

- **Foundational (Phase 2)** must complete before **User Story 1 (Phase 3)** begins.
- **User Story 2 (Phase 4)** depends on Phase 3 completion for hub outputs (hubId, routeTables).
- Tasks marked `[P]` can run in parallel where staff capacity allows.

## Parallel execution examples

- While T016..T019 (hub+firewall implementation) run, the following can run in parallel: T009 (module README/examples), T012 (quota check script), T013 (monitoring module), T014 (roles module).

## Implementation Strategy

### MVP First
1. Complete Setup (Phase 1)
2. Complete Foundational (Phase 2)
3. Complete User Story 1 (Phase 3) — validate end-to-end in non-prod
4. STOP and VALIDATE: Run integration tests and post-deploy verification
5. Proceed to User Story 2 (Phase 4) once MVP validated

### Incremental Delivery
- Deliver hub+firewall as the first increment (MVP).
- Deliver spoke module and onboarding as the second increment.

---

## Task Counts & Summary

- Total tasks: 36
- Tasks per story/phase:
  - Setup (Phase 1): 7
  - Foundational (Phase 2): 8
  - User Story 1 (Phase 3): 9
  - User Story 2 (Phase 4): 6
  - Polish (Phase 5): 6

## Validation

- Format validation: All tasks use the checklist format `- [ ] T### [optional P] [USn] Description (path)`.
- Each user story contains an independent test and a set of implementation tasks to satisfy it.


