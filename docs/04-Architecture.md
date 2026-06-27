# Architecture Design

---

# Overview

This document describes the logical and physical architecture of the AWS Enterprise Hub-and-Spoke Security Architecture.

The solution is designed using AWS networking best practices to provide centralized security, simplified routing, scalable application hosting, and high availability.

The architecture separates networking infrastructure from application workloads by introducing two dedicated Virtual Private Clouds (VPCs):

- Hub VPC
- Spoke Workload VPC

The Hub VPC acts as the centralized networking and security layer, while the Spoke VPC hosts the application infrastructure.

---

# Architecture Diagram

> **Figure 1 – High-Level Architecture**

Insert:

```
architecture/architecture-diagram.png
```

---

# Architecture Goals

The architecture was designed to achieve the following objectives:

- Centralized ingress
- Centralized security inspection
- Private application workloads
- High availability
- Automatic scaling
- Enterprise network segmentation
- Simplified routing
- Easy expansion for future spoke VPCs

---

# Logical Architecture

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
        Internet-facing Application Load Balancer
                    (Hub VPC)
                         │
                         ▼
         ALB Target Group (IP Target Type)
                         │
               Transit Gateway Routing
                         │
                         ▼
        Internal Network Load Balancer
                (Spoke VPC)
                         │
                         ▼
     NLB Target Group (Instance Target Type)
                         │
                         ▼
             Auto Scaling Group
                  │           │
                  ▼           ▼
             EC2-AZ1      EC2-AZ2
```

---

# Physical Architecture

## Hub VPC

Responsibilities:

- Internet entry point
- DNS endpoint
- Layer 7 inspection
- Network routing
- Firewall inspection
- Outbound Internet access

Resources:

- Internet Gateway
- NAT Gateway
- Application Load Balancer
- AWS WAF
- AWS Network Firewall
- Transit Gateway Attachment
- Public Subnets
- Firewall Subnets
- NAT Subnet
- Bastion Host

---

## Spoke Workload VPC

Responsibilities:

- Application hosting
- Internal load balancing
- Automatic scaling
- Private networking

Resources:

- Internal Network Load Balancer
- Auto Scaling Group
- Launch Template
- EC2 Instances
- Private Workload Subnets

---

# Component Responsibilities

## Amazon Route53

Provides DNS resolution for the application.

Responsibilities:

- Public Hosted Zone
- ALB Alias Record
- Highly available DNS

---

## AWS WAF

Provides Layer 7 protection.

Configured Rules:

- Geo Match
- Rate-Based
- Custom Responses

Purpose:

- Prevent malicious requests
- Block unwanted countries
- Mitigate excessive traffic

---

## Application Load Balancer

Located inside the Hub VPC.

Purpose:

- Internet-facing entry point
- HTTP routing
- WAF integration

Configuration:

- Internet Facing
- HTTP Listener
- IP Target Group

---

## Why IP Target Group?

The Application Load Balancer forwards traffic to the **private IP addresses of the Internal Network Load Balancer** located in the Spoke VPC.

This design allows:

- Centralized ingress
- Private workloads
- Hub-and-Spoke routing
- Simplified expansion

The ALB does **not** target EC2 instances directly.

---

## Transit Gateway

AWS Transit Gateway provides centralized routing between VPCs.

Advantages:

- No VPC peering mesh
- Centralized route management
- Easy addition of new spoke VPCs
- Simplified architecture

---

## Internal Network Load Balancer

Located inside the Spoke VPC.

Responsibilities:

- TCP load balancing
- High performance
- Automatic instance distribution

Configuration:

- Internal
- TCP Listener
- Instance Target Group

---

## Why Instance Target Group?

The NLB distributes traffic directly to the EC2 instances registered by the Auto Scaling Group.

Benefits:

- Native Auto Scaling integration
- Automatic registration
- Automatic deregistration
- Health monitoring

---

## Auto Scaling Group

The Auto Scaling Group manages application capacity.

Responsibilities:

- Launch EC2 instances
- Replace failed instances
- Register instances with the NLB
- Maintain desired capacity

Configuration:

Minimum Capacity:

```
2
```

Desired Capacity:

```
2
```

Maximum Capacity:

```
4
```

---

## EC2 Instances

Purpose:

Host the Apache web application.

Configuration:

- Amazon Linux
- Apache HTTP Server
- User Data installation
- Multi-AZ deployment

---

# Security Layers

The architecture implements multiple independent security layers.

## Layer 1

Amazon Route53

Provides resilient DNS.

---

## Layer 2

AWS WAF

Protects HTTP requests.

---

## Layer 3

Application Load Balancer

Centralized Internet ingress.

---

## Layer 4

Transit Gateway

Private inter-VPC routing.

---

## Layer 5

AWS Network Firewall

Outbound inspection.

---

## Layer 6

Security Groups

Instance-level firewall.

---

## Layer 7

Operating System

Amazon Linux.

---

## Layer 8

Application

Apache HTTP Server.

---

# Network Segmentation

The architecture separates responsibilities.

| Layer | Location |
|---------|----------|
| Internet Entry | Hub VPC |
| Routing | Hub VPC |
| Firewall | Hub VPC |
| DNS | Hub VPC |
| Application | Spoke VPC |
| Scaling | Spoke VPC |

---

# Request Lifecycle

A client request follows these stages.

### Stage 1

Client resolves DNS using Route53.

↓

### Stage 2

Request reaches AWS WAF.

↓

### Stage 3

WAF validates request.

↓

### Stage 4

ALB receives request.

↓

### Stage 5

ALB forwards request to IP Target Group.

↓

### Stage 6

Traffic traverses Transit Gateway.

↓

### Stage 7

Internal NLB receives TCP connection.

↓

### Stage 8

NLB selects healthy EC2 instance.

↓

### Stage 9

Application responds.

↓

### Stage 10

Response follows reverse path.

---

# High Availability

The architecture avoids single points of failure.

Implemented using:

- Multi-AZ ALB
- Multi-AZ NLB
- Auto Scaling Group
- Managed AWS networking services
- Multiple EC2 instances

---

# Scalability

The solution supports horizontal scaling.

Workflow:

1. Increased load detected.
2. Auto Scaling launches new EC2.
3. Instance joins Target Group.
4. NLB begins forwarding traffic.
5. ALB requires no changes.

---

# Design Decisions

| Decision | Reason |
|----------|--------|
| Hub-and-Spoke | Centralized networking |
| Transit Gateway | Simplified routing |
| ALB in Hub | Single Internet entry |
| NLB in Spoke | Private workload distribution |
| IP Target Group | Forward to NLB private IPs |
| Instance Target Group | Native ASG integration |
| AWS WAF | Layer 7 protection |
| AWS Network Firewall | Stateful inspection |

---

# Architecture Benefits

- Centralized management
- Enterprise-ready design
- Secure workloads
- Private applications
- High availability
- Automatic scaling
- Easy expansion
- Reduced operational complexity

---

# Screenshot Placeholders

## Figure 1 – Architecture Diagram

Insert:

```
architecture/architecture-diagram.png
```

---

## Figure 2 – Hub VPC

Insert AWS Console screenshot.

---

## Figure 3 – Spoke VPC

Insert AWS Console screenshot.

---

## Figure 4 – Transit Gateway

Insert AWS Console screenshot.

---

## Figure 5 – ALB Configuration

Insert AWS Console screenshot.

---

## Figure 6 – NLB Configuration

Insert AWS Console screenshot.

---

## Figure 7 – Auto Scaling Group

Insert AWS Console screenshot.

---

## Figure 8 – Route Tables

Insert AWS Console screenshot.

---

# Summary

This architecture demonstrates an enterprise-inspired AWS networking solution that centralizes ingress, routing, and security while hosting scalable workloads inside isolated VPCs.

The separation of concerns between the Hub VPC and the Spoke VPC provides a secure, highly available, and extensible foundation that can support future application environments with minimal architectural changes.

---
