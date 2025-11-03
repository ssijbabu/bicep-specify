# Contract: Hub Module

**Module**: infra/modules/hub

## Purpose

Provide hub virtual network, subnets for Azure Firewall and platform services, and route table configuration to send traffic to firewall.

## Inputs

- hubName (string) — name prefix for resources
- addressSpace (string) — e.g., 10.10.0.0/16
- firewallSubnetPrefix (string) — e.g., 10.10.0.0/26
- platformSubnetPrefix (string) — e.g., 10.10.1.0/24
- region (string) — e.g., nznorth
- tags (object)

## Outputs

- hubVnetId (string)
- firewallIp (string)
- routeTableIds (object)

## Contracts & Constraints

- The module MUST NOT create application-specific resources.
- The addressSpace MUST be a /16 for initial deployment.
- The module MUST expose extension points for route propagation and peering from spoke modules.
