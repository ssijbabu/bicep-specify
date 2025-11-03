# Data Model: Platform Landing Zone

**Feature**: Platform Landing Zone — Azure Firewall Hub & Spoke (NZ North)
**Created**: 2025-11-03

## Entities

- ManagementGroup
  - id (string)
  - displayName (string)
  - policies (list)

- Subscription
  - id (string)
  - displayName (string)
  - environment (enum: dev, test, prod)
  - assignedManagementGroup (string)

- VirtualNetwork (Hub / Spoke)
  - id (string)
  - name (string)
  - addressSpace (CIDR, e.g., 10.0.0.0/16)
  - subnets (list of Subnet)
  - region (string)

- Subnet
  - name (string)
  - prefix (CIDR)
  - purpose (enum: firewall, platform, app)

- AzureFirewall
  - id (string)
  - name (string)
  - sku (enum: Standard, Premium)
  - publicIP (string)
  - diagnosticSettings (object)

- BicepModule
  - name (string)
  - version (semver)
  - inputs (map)
  - outputs (map)
  - owner (string)

## Relationships

- ManagementGroup -> Subscription (1..n)
- Subscription -> VirtualNetwork (1..n)
- VirtualNetwork(hub) -> AzureFirewall (0..1)
- VirtualNetwork(spoke) -> Peer -> Hub VirtualNetwork

## Validation rules

- Hub addressSpace MUST be a /16 in the New Zealand North deployment for this feature.
- Spoke subnets MUST not overlap with other spokes; default spoke allocation is /24.
- AzureFirewall SKU default: Standard; upgrade path to Premium must be documented.

