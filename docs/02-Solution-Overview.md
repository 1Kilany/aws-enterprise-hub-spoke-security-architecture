# Solution Overview

---

# Introduction

This project implements a production-inspired AWS Hub-and-Spoke architecture designed to centralize networking, security, and application ingress while hosting workloads in isolated application VPCs.

The architecture follows AWS networking best practices by separating shared infrastructure services from application workloads. Instead of exposing application servers directly to the Internet, all inbound and outbound traffic is controlled through a centralized Hub VPC.

The solution demonstrates how multiple AWS managed services can be combined to create a scalable, highly available, and secure application platform.

---

# Solution Goals

The solution was designed with the following objectives:

- Centralize Internet ingress.
- Separate security services from application workloads.
- Simplify routing between VPCs.
- Improve scalability.
- Increase availability.
- Reduce operational complexity.
- Provide a reusable enterprise network architecture.
- Demonstrate AWS networking best practices.

---

# Architecture Overview

The environment consists of two Virtual Private Clouds (VPCs):

| VPC | Purpose |
|-----|---------|
| Hub VPC | Networking and Security |
| Spoke Workload VPC | Application Hosting |

The VPCs are interconnected using AWS Transit Gateway.

The Hub VPC acts as the centralized networking layer, while the Spoke VPC hosts the web application.

---

# High-Level Architecture

```
                    Internet
                        │
                        ▼
                Amazon Route53
                        │
                        ▼
                  AWS WAF Web ACL
                        │
                        ▼
         Internet-facing Application Load Balancer
                     (Hub VPC)
                        │
                        ▼
        ALB Target Group (IP Target Type)
                        │
                        ▼
           Private IP Addresses of Internal NLB
                        │
             Transit Gateway Routing
                        │
                        ▼
       Internal Network Load Balancer (Spoke VPC)
                        │
                        ▼
      NLB Target Group (Instance Target Type)
                        │
                        ▼
             Auto Scaling Group (ASG)
                  │                │
                  ▼                ▼
             EC2 Instance      EC2 Instance
```

---

# Why a Hub-and-Spoke Architecture?

Many enterprise environments host multiple applications across different VPCs.

If every application managed its own:

- Internet Gateway
- NAT Gateway
- AWS WAF
- Firewall
- Internet-facing Load Balancer

the result would be:

- duplicated infrastructure
- inconsistent security policies
- increased cost
- difficult operations

A Hub-and-Spoke architecture centralizes these shared services inside the Hub VPC.

Benefits include:

- Consistent security policies
- Simplified management
- Reduced operational overhead
- Better scalability
- Easier future expansion

---

# Hub VPC Responsibilities

The Hub VPC contains shared infrastructure components that serve one or more application VPCs.

Responsibilities include:

- Internet ingress
- DNS entry point
- AWS WAF protection
- Application Load Balancer
- AWS Network Firewall
- Transit Gateway attachment
- NAT Gateway
- Centralized routing

The Hub VPC does **not** host application servers.

---

# Spoke Workload VPC Responsibilities

The Spoke VPC hosts the application infrastructure.

Resources include:

- Internal Network Load Balancer
- Auto Scaling Group
- EC2 Web Servers
- Private subnets

The Spoke VPC has no direct Internet-facing resources.

All communication passes through the Hub VPC.

---

# Application Request Flow

A client request follows these steps:

### Step 1

The client resolves the application domain using Amazon Route53.

---

### Step 2

The DNS record points to the Internet-facing Application Load Balancer.

---

### Step 3

AWS WAF inspects the HTTP request.

Configured protections include:

- Geo Match Rule
- Rate-Based Rule
- Custom Block Responses

Only allowed traffic reaches the ALB.

---

### Step 4

The Application Load Balancer forwards the request to an IP-based Target Group.

Unlike traditional ALB deployments, this Target Group contains the **private IP addresses of the Internal Network Load Balancer** located in the Spoke VPC.

This enables centralized ingress while keeping workloads private.

---

### Step 5

Routing between the Hub VPC and the Spoke VPC is provided by AWS Transit Gateway.

The Transit Gateway enables communication without VPC peering and allows future spoke VPCs to be added easily.

---

### Step 6

Traffic reaches the Internal Network Load Balancer.

The NLB distributes TCP traffic across the registered EC2 instances.

---

### Step 7

The NLB forwards requests to an Instance Target Group.

The Target Group is automatically maintained by the Auto Scaling Group.

Whenever new EC2 instances launch, they are automatically registered.

---

### Step 8

The EC2 instance processes the request and returns the response through the same path.

---

# Outbound Traffic Flow

Outbound Internet access follows a centralized security path.

```
EC2 Instance

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

This ensures all outbound traffic can be inspected before leaving AWS.

---

# High Availability

The architecture is designed to survive the failure of individual resources.

High availability is achieved through:

- Multi-AZ ALB
- Multi-AZ NLB
- Auto Scaling Group
- Multiple EC2 instances
- Managed AWS networking services

---

# Scalability

The solution supports horizontal scaling.

When application demand increases:

1. Auto Scaling launches additional EC2 instances.
2. New instances register with the NLB Target Group.
3. The NLB immediately begins distributing traffic.
4. The ALB continues forwarding requests without modification.

No manual intervention is required.

---

# Security Layers

The solution implements multiple security controls.

| Layer | Service |
|--------|----------|
| DNS | Amazon Route53 |
| Web Protection | AWS WAF |
| Load Balancing | Application Load Balancer |
| Routing | Transit Gateway |
| Network Inspection | AWS Network Firewall |
| Instance Security | Security Groups |
| Application Layer | Apache Web Server |

This layered approach reduces risk and limits attack surfaces.

---

# Advantages of This Design

The architecture provides:

- Centralized security
- Centralized routing
- Private workloads
- Internet isolation
- Automatic scaling
- High availability
- Enterprise network segmentation
- Production-ready design
- Easy expansion to additional Spoke VPCs

---

# Screenshot Placeholders

## Figure 1 – Overall Architecture

> Insert: `architecture/architecture-diagram.png`

---

## Figure 2 – Hub VPC Resources

> Insert AWS Console screenshot

---

## Figure 3 – Spoke VPC Resources

> Insert AWS Console screenshot

---

## Figure 4 – Transit Gateway Attachments

> Insert AWS Console screenshot

---

## Figure 5 – Request Flow Validation

> Insert browser / curl test

---

