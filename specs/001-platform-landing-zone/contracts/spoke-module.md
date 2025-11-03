# Contract: Spoke Module

**Module**: infra/modules/spoke

## Purpose

Create a spoke virtual network that peers to the hub, allocates subnets for application workloads, and configures route tables to direct egress through the hub firewall.

## Inputs

- spokeName (string)
- spokePrefix (string) — e.g., 10.10.10.0/24
- hubId (string) — hub VNet resource id or peering target
- region (string)
- tags (object)

## Outputs

- spokeVnetId (string)
- peeringId (string)

## Contracts & Constraints

- Spoke prefix MUST be a /24 inside the hub /16 pool and MUST NOT overlap with other spokes.
- Spoke creation MUST be possible without modifying hub module code.
