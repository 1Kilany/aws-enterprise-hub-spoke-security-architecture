# AWS Best Practices

---

# Overview

This document outlines the AWS architectural best practices implemented in the AWS Enterprise Hub-and-Spoke Security Architecture.

The recommendations are based on AWS documentation, AWS networking best practices, and the AWS Well-Architected Framework.

The objective is to build a secure, scalable, highly available, and operationally efficient cloud environment.

---

# Design Principles

The architecture follows several key AWS design principles:

- Centralize shared networking services
- Separate workloads from networking infrastructure
- Minimize the public attack surface
- Use managed AWS services whenever possible
- Design for failure
- Automate infrastructure
- Scale horizontally
- Apply least-privilege security

---

# Networking Best Practices

## Use Hub-and-Spoke Topology

Instead of connecting VPCs through multiple VPC Peering connections, the architecture uses AWS Transit Gateway.

Benefits:

- Simplified routing
- Easier management
- Future scalability
- Reduced operational complexity

---

## Centralize Internet Ingress

The Internet-facing Application Load Balancer is deployed only inside the Hub VPC.

Advantages:

- Single entry point
- Consistent security policies
- Easier monitoring
- Simplified DNS management

---

## Centralize Internet Egress

Outbound traffic from the Spoke VPC is routed through:

```
Transit Gateway

↓

AWS Network Firewall

↓

NAT Gateway

↓

Internet Gateway
```

Benefits:

- Centralized inspection
- Single security policy
- Easier auditing

---

## Keep Workloads Private

Application servers should never receive public IP addresses.

EC2 instances should remain inside private subnets.

Internet access should occur only through the Hub VPC.

---

# Load Balancer Best Practices

## Application Load Balancer

Use an Application Load Balancer for:

- HTTP
- HTTPS
- Host-based routing
- Path-based routing
- AWS WAF integration

---

## Network Load Balancer

Use an Internal Network Load Balancer for:

- Layer 4 traffic
- High throughput
- Static private IP addresses
- Auto Scaling integration

---

## Separate Responsibilities

In this architecture:

ALB

- Internet-facing
- Layer 7
- WAF integration

NLB

- Private
- Layer 4
- EC2 distribution

---

# Auto Scaling Best Practices

- Deploy across multiple Availability Zones.
- Maintain at least two running instances.
- Attach the Auto Scaling Group directly to the NLB Target Group.
- Use Launch Templates instead of Launch Configurations.
- Enable ELB health checks.
- Monitor scaling events.

---

# Transit Gateway Best Practices

- Use Transit Gateway instead of VPC Peering for enterprise environments.
- Document route propagation.
- Separate route tables when segmentation is required.
- Avoid unnecessary route advertisements.
- Review attachments regularly.

---

# Route Table Best Practices

- Separate public and private route tables.
- Keep firewall routes isolated.
- Document every route.
- Verify return paths.
- Test routing after every change.

---

# Security Best Practices

## Defense in Depth

Security is implemented at multiple layers.

```
Route53

↓

AWS WAF

↓

Application Load Balancer

↓

Transit Gateway

↓

AWS Network Firewall

↓

Security Groups

↓

EC2
```

No single security control is relied upon exclusively.

---

## Least Privilege

Grant only the permissions required.

Applies to:

- IAM Roles
- Security Groups
- Network ACLs
- Firewall Policies

---

## Security Groups

Recommended practices:

- Allow only required ports.
- Restrict source CIDRs.
- Use Security Group references where possible.
- Remove unused rules.

---

## AWS WAF

Recommended practices:

- Enable Rate-Based Rules.
- Enable Geo Match Rules where applicable.
- Use AWS Managed Rule Groups.
- Monitor blocked requests.

---

## AWS Network Firewall

Recommended practices:

- Use Stateful Rule Groups.
- Organize Suricata rules logically.
- Monitor Firewall logs.
- Test every policy before production.

---

# High Availability Best Practices

Deploy the following resources across multiple Availability Zones:

- Application Load Balancer
- Internal Network Load Balancer
- Auto Scaling Group
- EC2 Instances
- Firewall Endpoints

Avoid single points of failure.

---

# Monitoring Best Practices

Monitor:

- Auto Scaling
- ALB
- NLB
- Transit Gateway
- AWS WAF
- AWS Network Firewall
- EC2
- Route53

Recommended services:

- Amazon CloudWatch
- AWS CloudTrail
- VPC Flow Logs
- Route53 Health Checks

---

# Logging Best Practices

Enable logging for:

- AWS WAF
- AWS Network Firewall
- Application Load Balancer Access Logs
- VPC Flow Logs
- CloudTrail

Store logs centrally for analysis and auditing.

---

# Performance Best Practices

- Keep EC2 instances in multiple Availability Zones.
- Monitor application latency.
- Use Auto Scaling for demand changes.
- Configure efficient health checks.
- Avoid unnecessary network hops.

---

# Cost Optimization Best Practices

- Use Auto Scaling to match capacity with demand.
- Stop unused resources in lab environments.
- Monitor NAT Gateway usage.
- Delete unused Elastic IP addresses.
- Remove unattached EBS volumes.
- Clean up unused Target Groups and Load Balancers after testing.

---

# Operational Best Practices

- Document architecture changes.
- Review route tables before deployment.
- Validate firewall rules after updates.
- Test health checks regularly.
- Review CloudWatch alarms.
- Use tagging consistently.

Example tags:

| Key | Value |
|------|-------|
| Project | Hub-Spoke |
| Environment | Lab |
| Owner | Mohamed Ayman |
| ManagedBy | AWS |

---

# Common Mistakes to Avoid

- Exposing EC2 instances directly to the Internet.
- Using public IPs on workload servers.
- Bypassing AWS Network Firewall.
- Incorrect Transit Gateway routes.
- Forgetting return routes.
- Overly permissive Security Groups.
- Missing health checks.
- Ignoring CloudWatch alarms.

---

# Architecture Review Checklist

| Item | Status |
|------|--------|
| Multi-AZ Deployment | ✅ |
| Centralized Ingress | ✅ |
| Centralized Egress | ✅ |
| Transit Gateway | ✅ |
| AWS WAF | ✅ |
| AWS Network Firewall | ✅ |
| Auto Scaling | ✅ |
| Internal Workloads | ✅ |
| Route53 | ✅ |
| Health Checks | ✅ |

---

# Screenshot Placeholders

## Figure 1 – Architecture Overview

> Insert architecture diagram.

---

## Figure 2 – Security Layers

> Insert security architecture diagram.

---

## Figure 3 – CloudWatch Dashboard

> Insert monitoring dashboard.

---

## Figure 4 – Resource Tags

> Insert tagging example.

---

# Summary

Following AWS best practices ensures that the Hub-and-Spoke architecture remains secure, scalable, resilient, and operationally efficient. By centralizing networking, isolating workloads, automating scaling, and implementing layered security controls, the solution aligns with enterprise cloud design principles and provides a strong foundation for future expansion.

---

# References

- AWS Well-Architected Framework
- AWS Security Best Practices
- AWS Transit Gateway Best Practices
- AWS Network Firewall Documentation
- AWS WAF Developer Guide
- Elastic Load Balancing Best Practices

---

# Next Document

➡️ **19-Cost-Optimization.md**