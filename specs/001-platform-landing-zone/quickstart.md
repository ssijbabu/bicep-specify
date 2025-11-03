# Quickstart: Platform Landing Zone — Azure Firewall Hub & Spoke (NZ North)

**Purpose**: Quick instructions for developers/operators to validate and deploy the platform landing zone in a non-production subscription.

## Prerequisites

- Azure subscription with Owner or User Access Administrator role for initial deployment.
- Azure DevOps project with repository access (or pipeline runner configured).
- Service principal or managed identity with permissions to create management groups and subscriptions (or platform owner to perform initial onboarding).
- Bicep CLI installed locally for validation and `bicep build` checks (optional if relying on pipeline).

## Steps (non-prod validation)

1. Clone the repository and switch to the feature branch:

```bash
git checkout 001-platform-landing-zone
```

2. Validate Bicep modules locally:

```bash
bicep build infra/modules/hub/main.bicep
bicep build infra/modules/firewall/main.bicep
```

3. Run pipeline in validate mode (Azure DevOps):

- Trigger the `pipelines/landing-zone/validate.yaml` pipeline which runs linting, `bicep build`, policy-as-code checks and `what-if` preview.

4. Deploy to an isolated non-production subscription using the `deploy` pipeline stage (requires approval):

- Provide parameter file `examples/nonprod/parameters.json` with hub address space (e.g., 10.10.0.0/16) and environment tag.

5. Run post-deploy tests:

- Verify hub VNet and firewall are created.
- Deploy a temporary test VM in a spoke and confirm traffic egress through firewall.
- Verify policy assignments and tagging via Azure Portal or `az policy state` commands.

## How to onboard an Application Landing Zone (example)

- Use the `infra/modules/spoke` module with parameters: `spokeName`, `spokePrefix` (/24 within hub /16), `peerToHub`=true. The module will create the spoke VNet, peer to hub, and create route tables that direct traffic to the hub firewall.

