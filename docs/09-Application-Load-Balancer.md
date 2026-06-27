# Application Load Balancer (ALB)

---

# Overview

The Application Load Balancer (ALB) serves as the centralized Internet-facing entry point for all client requests.

Unlike traditional AWS web architectures where an ALB forwards requests directly to EC2 instances, this solution forwards requests to an Internal Network Load Balancer (NLB) located inside the Spoke Workload VPC.

This design keeps application workloads private while allowing the Hub VPC to centralize ingress, security inspection, and routing.

---

# Purpose

The ALB is responsible for:

- Internet-facing application access
- Layer 7 HTTP routing
- AWS WAF integration
- Health monitoring
- Forwarding requests toward the Spoke Workload VPC

---

# Deployment Location

The Application Load Balancer is deployed inside the **Hub VPC**.

The Hub VPC acts as the centralized networking layer for all application workloads.

Advantages include:

- Single Internet entry point
- Shared security controls
- Simplified DNS management
- Easier onboarding of additional Spoke VPCs

---

# Architecture

```
                 Internet

                      │

                 Amazon Route53

                      │

                   AWS WAF

                      │

             Internet-facing ALB

                      │

             HTTP Listener :80

                      │

             IP Target Group

                      │

       Private IP Addresses of NLB

                      │

              Transit Gateway

                      │

        Internal NLB (Spoke VPC)
```

---

# ALB Configuration

| Property | Value |
|----------|-------|
| Type | Application Load Balancer |
| Scheme | Internet-facing |
| Listener | HTTP :80 |
| Target Group | IP Target Type |
| Availability | Multi-AZ |

---

# Why Application Load Balancer?

Application Load Balancer operates at Layer 7 of the OSI model.

Benefits include:

- HTTP awareness
- URL routing
- Host-based routing
- AWS WAF integration
- Detailed access logs
- Native AWS managed service

---

# Why Internet-facing?

The application must be accessible by external clients.

The ALB provides:

- Public endpoint
- High availability
- Managed scaling
- DNS integration with Route53

No EC2 instance is directly exposed to the Internet.

---

# Listener Configuration

The ALB listens on:

```
HTTP

Port 80
```

Future improvements may include:

```
HTTPS

Port 443

AWS Certificate Manager

TLS Encryption
```

---

# Target Group

The Application Load Balancer uses:

```
Target Type

IP Address
```

---

# Why IP Target Type?

This architecture intentionally avoids targeting EC2 instances directly.

Instead, the ALB forwards requests to the **private IP addresses of the Internal Network Load Balancer (NLB)**.

This provides:

- Centralized ingress
- Private application workloads
- Better separation of responsibilities
- Enterprise Hub-and-Spoke design
- Support for future workload expansion

---

# Target Registration

The Target Group contains the private IP addresses assigned to the Internal NLB.

Example:

```
NLB ENI

Private IP

Availability Zone A

Availability Zone B
```

These IP addresses represent the entry points of the Internal NLB inside the Spoke VPC.

> **Note:** Replace the example above with your actual NLB private IP addresses if you choose to document them, or keep the documentation generic if you prefer not to expose internal addressing.

---

# Request Flow

A client request follows these steps:

1. Client resolves the application domain using Amazon Route53.
2. Route53 returns the ALB Alias record.
3. The request reaches AWS WAF.
4. AWS WAF evaluates the configured security rules.
5. Valid requests are forwarded to the Application Load Balancer.
6. The ALB forwards the request to its IP Target Group.
7. The request is routed through the Transit Gateway to the Internal NLB.
8. The Internal NLB distributes the request to a healthy EC2 instance.

---

# Health Checks

The Application Load Balancer continuously monitors the health of its configured targets.

Health checks ensure that traffic is forwarded only to reachable NLB endpoints.

Typical settings include:

| Parameter | Example |
|-----------|---------|
| Protocol | HTTP |
| Port | Traffic Port |
| Path | `/` |
| Healthy Threshold | 3 |
| Unhealthy Threshold | 3 |
| Timeout | 5 seconds |
| Interval | 30 seconds |

---

# Security

The ALB is protected by multiple layers:

- AWS WAF
- Security Groups
- Route53
- Transit Gateway
- Private workloads

Direct access to EC2 instances is not possible.

---

# Security Group

Example inbound rules:

| Protocol | Port | Source |
|----------|------|--------|
| HTTP | 80 | 0.0.0.0/0 |

Example outbound rules:

| Destination |
|-------------|
| Spoke Workload CIDR |

---

# High Availability

The Application Load Balancer is deployed across multiple Availability Zones.

Benefits include:

- Fault tolerance
- Automatic scaling
- Managed availability
- No single point of failure

---

# Design Decisions

| Decision | Reason |
|----------|--------|
| ALB in Hub VPC | Centralized ingress |
| Internet-facing | Public application access |
| IP Target Group | Forward to Internal NLB |
| WAF Integration | Layer 7 protection |
| Multi-AZ | High availability |

---

# Advantages

This design provides:

- Centralized application entry
- Private backend infrastructure
- Improved security
- Simplified management
- Enterprise scalability
- Future support for multiple Spoke VPCs

---

# Screenshot Placeholders

## Figure 1 – Application Load Balancer Overview

> Insert ALB Overview screenshot.

---

## Figure 2 – Listener Configuration

> Insert Listener screenshot.

---

## Figure 3 – Target Group

> Insert Target Group screenshot.

---

## Figure 4 – Target Health

> Insert Target Health screenshot.

---

## Figure 5 – Security Group

> Insert Security Group screenshot.

---

# Summary

The Application Load Balancer acts as the centralized Internet-facing entry point of the architecture. By forwarding traffic to an IP-based Target Group containing the private IP addresses of the Internal Network Load Balancer, the solution achieves centralized ingress while keeping application workloads private and scalable. This design aligns with enterprise networking principles and supports future expansion through additional Spoke VPCs.

---

# Next Document

➡️ **10-Network-Load-Balancer.md**