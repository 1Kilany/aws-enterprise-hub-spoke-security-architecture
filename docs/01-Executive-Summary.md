# Executive Summary

---

## Project Overview

This project demonstrates the design and implementation of an enterprise-grade AWS Hub-and-Spoke network architecture that centralizes networking, security, and application ingress while maintaining highly available workloads in isolated application VPCs.

The architecture is designed following AWS networking best practices and incorporates multiple managed services to provide secure, scalable, and resilient application delivery.

The solution separates infrastructure responsibilities by introducing a **Hub VPC**, responsible for centralized networking and security services, and a **Spoke Workload VPC**, responsible for hosting business applications.

The Hub VPC provides a single entry point for incoming client traffic, centralized routing through AWS Transit Gateway, and centralized security inspection using AWS WAF and AWS Network Firewall.

The Spoke Workload VPC hosts the application layer using an Internal Network Load Balancer (NLB), Auto Scaling Group, and EC2 web servers distributed across multiple Availability Zones.

---

# Project Objectives

The primary objectives of this project are:

- Build a scalable enterprise AWS network architecture.
- Implement a Hub-and-Spoke topology.
- Separate networking from workloads.
- Centralize ingress traffic.
- Centralize security inspection.
- Deploy highly available workloads.
- Demonstrate AWS networking best practices.
- Showcase production-inspired cloud architecture.
- Improve security through multiple protection layers.
- Provide a reusable architecture for enterprise deployments.

---

# Business Problem

Organizations often operate multiple applications that require:

- Secure internet access
- High availability
- Centralized security controls
- Simplified routing
- Scalable workloads
- Isolation between networking and applications

Managing these requirements independently for every VPC increases operational complexity and introduces inconsistent security policies.

This architecture addresses these challenges by introducing a centralized Hub VPC that provides networking and security services to one or more application VPCs.

---

# Proposed Solution

The proposed solution implements a centralized Hub-and-Spoke architecture consisting of two Amazon VPCs connected using AWS Transit Gateway.

The Hub VPC hosts all shared networking and security services, while the Spoke VPC hosts the application workloads.

Incoming traffic follows the path below:

```
Internet
        │
        ▼
Amazon Route53
        │
        ▼
AWS WAF
        │
        ▼
Application Load Balancer
(Hub VPC)
        │
        ▼
ALB Target Group (IP Targets)
        │
        ▼
Transit Gateway
        │
        ▼
Internal Network Load Balancer
(Spoke VPC)
        │
        ▼
NLB Target Group (Instance Targets)
        │
        ▼
Auto Scaling Group
        │
        ▼
EC2 Web Servers
```

Outbound traffic follows a centralized inspection path:

```
EC2 Instances
      │
      ▼
Transit Gateway
      │
      ▼
AWS Network Firewall
      │
      ▼
NAT Gateway
      │
      ▼
Internet Gateway
      │
      ▼
Internet
```

---

# Architecture Components

The solution consists of the following AWS services:

| Service | Purpose |
|----------|---------|
| Amazon VPC | Network isolation |
| Transit Gateway | Centralized inter-VPC routing |
| AWS WAF | Layer 7 web protection |
| AWS Network Firewall | Stateful traffic inspection |
| Application Load Balancer | Public application entry point |
| Network Load Balancer | Private Layer 4 load balancing |
| Auto Scaling Group | Automatic workload scaling |
| Amazon EC2 | Web application hosting |
| Amazon Route53 | DNS resolution |
| NAT Gateway | Secure outbound Internet access |
| Internet Gateway | Public Internet connectivity |
| Security Groups | Instance-level security |
| Route Tables | Traffic routing |

---

# High Availability

The architecture is designed to eliminate single points of failure by distributing resources across multiple Availability Zones.

High availability is achieved using:

- Multi-AZ Application Load Balancer
- Multi-AZ Internal Network Load Balancer
- Auto Scaling Group
- Multiple EC2 Instances
- AWS Transit Gateway
- Managed AWS networking services

---

# Security Overview

The solution follows a defense-in-depth approach by implementing multiple security layers.

## Layer 1 – DNS Resolution

Amazon Route53 provides highly available DNS resolution.

---

## Layer 2 – Web Protection

AWS WAF protects the Application Load Balancer from common web attacks using:

- Geo Match Rules
- Rate-Based Rules
- Custom HTTP Responses

---

## Layer 3 – Network Routing

AWS Transit Gateway centralizes routing between Hub and Spoke VPCs.

---

## Layer 4 – Network Inspection

AWS Network Firewall performs stateful packet inspection for outbound traffic.

Example policies include:

- ICMP blocking
- Protocol filtering
- Domain filtering
- Stateful inspection

---

## Layer 5 – Instance Security

Security Groups provide workload-level access control.

---

# Design Principles

This architecture follows AWS Well-Architected Framework principles:

- Operational Excellence
- Security
- Reliability
- Performance Efficiency
- Cost Optimization
- Sustainability

---

# Benefits

The architecture provides:

- Centralized security
- Simplified network management
- Highly available workloads
- Automatic scaling
- Secure application delivery
- Enterprise-ready network segmentation
- Production-inspired AWS design
- Reusable deployment model

---

# Scope

The project demonstrates:

- Hub-and-Spoke networking
- Centralized ingress
- AWS Transit Gateway
- AWS WAF
- AWS Network Firewall
- Application Load Balancer
- Internal Network Load Balancer
- Auto Scaling
- Route53
- Multi-AZ deployment

---

# Screenshot Placeholders

## Figure 1 – High-Level Architecture

> Insert: `architecture/architecture-diagram.png`

---

## Figure 2 – Hub VPC

> Insert Hub VPC screenshot

---

## Figure 3 – Spoke VPC

> Insert Spoke VPC screenshot

---

## Figure 4 – AWS Transit Gateway

> Insert Transit Gateway screenshot

---

## Figure 5 – AWS Network Firewall

> Insert Network Firewall screenshot

---

## Figure 6 – Application Load Balancer

> Insert ALB screenshot

---

## Figure 7 – Internal Network Load Balancer

> Insert NLB screenshot

---

## Figure 8 – Auto Scaling Group

> Insert ASG screenshot

---
