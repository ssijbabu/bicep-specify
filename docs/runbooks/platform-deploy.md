# Runbook: Platform Deploy

This runbook outlines steps to deploy the Platform Landing Zone and rollback procedures.

## Pre-deploy
- Ensure parameter file (examples/nonprod/parameters.json) is updated with correct tags and hub prefix.
- Ensure service principal used by pipeline has required permissions (management group / subscription).

## Deploy
1. Trigger `pipelines/landing-zone/validate.yaml` and confirm all validations pass.
2. Trigger `pipelines/landing-zone/deploy.yaml` for non-prod with manual approval.
3. Run `pipelines/scripts/post-deploy-verify.sh` to perform verification checks.

## Rollback
- If deployment fails, record error and revert parameter changes.
- Use Azure portal or `az group deployment operation` to inspect failed resources and delete partial resources as needed.

