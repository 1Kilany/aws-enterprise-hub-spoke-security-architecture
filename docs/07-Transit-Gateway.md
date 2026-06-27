# AWS Transit Gateway

---

# Overview

AWS Transit Gateway (TGW) is the central networking component that connects the Hub VPC and the Spoke Workload VPC.

Instead of using multiple VPC Peering connections, Transit Gateway provides a scalable hub for interconnecting VPCs and centralizing route management.

In this architecture, Transit Gateway enables secure communication between the Hub VPC and the Spoke Workload VPC while allowing all application traffic to traverse centralized security services.

---

# Purpose

The Transit Gateway is responsible for:

- Connecting Hub and Spoke VPCs
- Centralized routing
- Eliminating VPC peering complexity
- Supporting future expansion
- Simplifying route management

---

# Why Transit Gateway?

As cloud environments grow, VPC Peering becomes increasingly difficult to manage.

Example:

```
VPC-A <------> VPC-B

VPC-A <------> VPC-C

VPC-B <------> VPC-C

VPC-C <------> VPC-D
```

The number of peering connections increases rapidly.

Transit Gateway solves this problem.

```
            Transit Gateway

          /        |        \

     Hub VPC   Spoke1   Spoke2

                     |

                 Spoke3
```

Each VPC connects only once.

---

# Architecture

```
                 Hub VPC

      ALB

        │

        ▼

Transit Gateway Attachment

        │

===============================

      AWS Transit Gateway

===============================

        │

Transit Gateway Attachment

        │

        ▼

Spoke Workload VPC

        │

 Internal NLB

        │

 Auto Scaling

        │

 EC2
```

---

# Components

The Transit Gateway consists of:

- Transit Gateway
- Transit Gateway Attachments
- Transit Gateway Route Tables
- Route Associations
- Route Propagation

---

# Transit Gateway Attachments

Two attachments are used.

## Hub Attachment

Connects:

```
Hub VPC
```

Purpose:

- Internet ingress
- Security services
- Firewall
- NAT

---

## Spoke Attachment

Connects:

```
Spoke Workload VPC
```

Purpose:

- Application workloads
- Internal NLB
- Auto Scaling
- EC2

---

# Transit Gateway Route Table

The Transit Gateway Route Table determines how traffic is forwarded between VPCs.

Example:

| Destination | Attachment |
|-------------|------------|
|10.0.0.0/16|Hub Attachment|
|10.1.0.0/16|Spoke Attachment|

When traffic arrives, Transit Gateway forwards packets to the appropriate VPC attachment.

---

# Route Associations

Each attachment is associated with a Transit Gateway Route Table.

Example:

```
Hub Attachment

↓

Hub TGW Route Table
```

```
Spoke Attachment

↓

Hub TGW Route Table
```

This allows communication between both VPCs.

---

# Route Propagation

Transit Gateway automatically advertises connected VPC CIDRs.

Example:

```
Hub VPC

10.0.0.0/16
```

↓

```
Transit Gateway
```

↓

```
Spoke VPC learns:

10.0.0.0/16
```

The reverse is also true.

---

# Packet Flow

## Inbound Request

```
Internet

↓

Route53

↓

AWS WAF

↓

Application Load Balancer

↓

Hub Route Table

↓

Transit Gateway

↓

Transit Gateway Attachment

↓

Spoke Route Table

↓

Internal NLB

↓

EC2
```

---

## Outbound Request

```
EC2

↓

Spoke Route Table

↓

Transit Gateway

↓

Hub Route Table

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

# Hub Route Table

The Hub VPC route table contains:

| Destination | Target |
|-------------|---------|
|0.0.0.0/0|Internet Gateway|
|10.1.0.0/16|Transit Gateway|

This allows the ALB to reach the Spoke VPC.

---

# Spoke Route Table

The Spoke VPC route table contains:

| Destination | Target |
|-------------|---------|
|10.0.0.0/16|Transit Gateway|
|0.0.0.0/0|Transit Gateway|

All outbound traffic is sent to the Hub VPC for centralized inspection.

---

# Advantages

Using Transit Gateway provides:

- Centralized routing
- Simplified management
- Easy expansion
- Reduced operational overhead
- Better scalability
- Enterprise architecture

---

# Why Not VPC Peering?

| VPC Peering | Transit Gateway |
|-------------|----------------|
|Mesh topology|Hub-and-Spoke|
|Many connections|Single attachment|
|No transitive routing|Transitive routing|
|Hard to scale|Highly scalable|
|Complex route management|Centralized routing|

For enterprise environments, Transit Gateway is generally preferred.

---

# High Availability

Transit Gateway is a managed AWS service.

Benefits include:

- Multi-AZ availability
- Managed scaling
- High throughput
- Automatic redundancy

No customer-managed appliances are required.

---

# Security Considerations

Transit Gateway itself does **not** inspect traffic.

Traffic inspection is performed by:

- AWS WAF
- AWS Network Firewall
- Security Groups

Transit Gateway only forwards traffic according to routing rules.

---

# Common Misconceptions

### Transit Gateway is not a firewall

It forwards traffic only.

---

### Transit Gateway is not a Load Balancer

Load balancing is handled by:

- Application Load Balancer
- Network Load Balancer

---

### Transit Gateway is not an Internet Gateway

Internet access is provided through:

- Internet Gateway
- NAT Gateway

---

# Best Practices

- Use separate route tables for segmentation.
- Keep routing centralized.
- Avoid unnecessary VPC peering.
- Use Transit Gateway for enterprise-scale environments.
- Inspect traffic before Internet egress.
- Document route propagation and associations.

---

# Screenshot Placeholders

## Figure 1 – Transit Gateway Overview

> Insert Transit Gateway overview.

---

## Figure 2 – Transit Gateway Attachments

> Insert Attachments screenshot.

---

## Figure 3 – Transit Gateway Route Table

> Insert Route Table screenshot.

---

## Figure 4 – Route Associations

> Insert Associations screenshot.

---

## Figure 5 – Route Propagation

> Insert Propagation screenshot.

---

# Summary

AWS Transit Gateway serves as the networking backbone of the Hub-and-Spoke architecture. By centralizing routing between the Hub and Spoke VPCs, it simplifies connectivity, reduces operational complexity, and provides a scalable foundation for future application VPCs without requiring complex VPC peering relationships.

---

# Next Document

➡️ **08-Route-Tables.md**