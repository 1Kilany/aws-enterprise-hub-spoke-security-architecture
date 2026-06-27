# Hub VPC Design

---

# Overview

The Hub VPC is the centralized networking and security layer of the architecture.

Instead of exposing every application VPC directly to the Internet, all ingress and centralized security services are deployed inside the Hub VPC.

The Hub VPC acts as the primary entry point for client requests while providing centralized routing, security inspection, and outbound Internet connectivity for connected Spoke VPCs.

---

# Purpose

The Hub VPC is responsible for:

- Centralized Internet ingress
- DNS entry point
- Layer 7 application protection
- Centralized routing
- Stateful network inspection
- Outbound Internet access
- Shared networking services

The Hub VPC **does not host application workloads**.

Application servers are deployed inside the Spoke Workload VPC.

---

# Hub VPC CIDR

Example:

```
10.0.0.0/16
```

The CIDR block provides sufficient address space for networking, security, and future expansion.

---

# Hub VPC Components

The Hub VPC contains the following resources.

| Resource | Purpose |
|----------|---------|
| Internet Gateway | Public Internet connectivity |
| Public Subnets | Host the Application Load Balancer |
| Application Load Balancer | Internet-facing entry point |
| AWS WAF | Layer 7 protection |
| AWS Network Firewall | Stateful traffic inspection |
| NAT Gateway | Outbound Internet access |
| Transit Gateway Attachment | Connectivity to Spoke VPC |
| Route Tables | Centralized routing |
| Bastion Host *(optional)* | Administrative access |

---

# Hub VPC Layout

```
                     Hub VPC
                10.0.0.0/16

     +--------------------------------------+

      Internet Gateway

               │

               ▼

      Public Subnets (AZ1 / AZ2)

               │

               ▼

      Application Load Balancer

               │

               ▼

      Transit Gateway Attachment

               │

      Firewall Subnets

               │

               ▼

      AWS Network Firewall

               │

               ▼

          NAT Gateway

               │

               ▼

      Internet Gateway

     +--------------------------------------+
```

---

# Public Subnets

The public subnets host Internet-facing resources.

Resources include:

- Application Load Balancer
- NAT Gateway
- Bastion Host (optional)

Characteristics:

- Route to Internet Gateway
- Public IP support
- Multi-AZ deployment

---

# Application Load Balancer

The Application Load Balancer provides the public entry point for the application.

Configuration:

- Internet Facing
- HTTP Listener
- AWS WAF Integration
- Multi-AZ

The ALB forwards traffic to an **IP Target Group**.

---

# Why IP Target Group?

The ALB does **not** send traffic directly to EC2 instances.

Instead, it forwards requests to the private IP addresses of the Internal Network Load Balancer deployed in the Spoke VPC.

Benefits:

- Centralized ingress
- Private application workloads
- No direct Internet exposure
- Simplified architecture
- Easy expansion

---

# AWS WAF

AWS WAF is associated with the Application Load Balancer.

Purpose:

- Protect web applications
- Block malicious traffic
- Apply centralized HTTP filtering

Configured rules include:

- Geo Match Rule
- Rate-Based Rule
- Custom 503 responses

---

# Transit Gateway Attachment

The Hub VPC attaches to AWS Transit Gateway.

Responsibilities:

- Routing to Spoke VPCs
- Centralized connectivity
- Simplified network expansion

Benefits:

- No VPC peering mesh
- Centralized route management
- Easy addition of future VPCs

---

# AWS Network Firewall

The Hub VPC hosts AWS Network Firewall to inspect outbound traffic from the Spoke VPC.

Responsibilities:

- Stateful inspection
- Protocol filtering
- Domain filtering
- Suricata rule enforcement

Example Stateful Rule:

```suricata
drop icmp any any -> any any (
msg:"Block ICMP";
sid:1000001;
rev:1;
)
```

---

# NAT Gateway

The NAT Gateway provides outbound Internet access for private workloads.

Responsibilities:

- Secure outbound connectivity
- Software updates
- Package installation
- External API communication

No inbound Internet traffic is permitted through the NAT Gateway.

---

# Route Tables

The Hub VPC uses dedicated route tables for different subnet types.

Typical route tables include:

- Public Route Table
- Firewall Route Table
- Transit Gateway Route Table
- NAT Route Table

Each route table has a specific networking responsibility.

Detailed routing is documented in:

```
08-Route-Tables.md
```

---

# Traffic Flow

Inbound traffic:

```
Internet

↓

Route53

↓

AWS WAF

↓

Application Load Balancer

↓

Transit Gateway

↓

Spoke VPC
```

Outbound traffic:

```
Spoke VPC

↓

Transit Gateway

↓

AWS Network Firewall

↓

NAT Gateway

↓

Internet Gateway

↓

Internet
```

---

# High Availability

The Hub VPC is designed for high availability.

Resources deployed across multiple Availability Zones include:

- Public Subnets
- Application Load Balancer
- Firewall Endpoints
- Transit Gateway Attachment
- NAT Gateway *(recommended one per AZ for production)*

This minimizes single points of failure.

---

# Security Design

The Hub VPC follows a defense-in-depth approach.

Security controls include:

- AWS WAF
- AWS Network Firewall
- Security Groups
- Route Table Segmentation
- Transit Gateway Isolation

The Hub VPC acts as the centralized security boundary for the environment.

---

# Benefits

The Hub VPC provides:

- Centralized security
- Simplified routing
- Secure Internet ingress
- Secure outbound connectivity
- Shared networking services
- Reduced operational overhead
- Easier expansion to multiple Spoke VPCs

---

# Screenshot Placeholders

## Figure 1 – Hub VPC Overview

> Insert Hub VPC architecture screenshot.

---

## Figure 2 – Public Subnets

> Insert Public Subnets screenshot.

---

## Figure 3 – Application Load Balancer

> Insert ALB configuration screenshot.

---

## Figure 4 – AWS WAF

> Insert Web ACL screenshot.

---

## Figure 5 – AWS Network Firewall

> Insert Firewall overview screenshot.

---

## Figure 6 – Transit Gateway Attachment

> Insert TGW attachment screenshot.

---

## Figure 7 – Route Tables

> Insert Hub route tables screenshot.

---

# Summary

The Hub VPC centralizes networking, security, and routing for the environment. By isolating shared infrastructure from application workloads, the architecture achieves improved security, simplified management, and a scalable foundation capable of supporting additional Spoke VPCs without redesigning the core network.

---

# Next Document

➡️ **06-Spoke-VPC.md**