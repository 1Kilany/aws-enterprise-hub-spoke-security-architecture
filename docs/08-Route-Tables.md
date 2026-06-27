# Route Table Design

---

# Overview

Route tables determine how network traffic flows between resources inside the AWS Hub-and-Spoke architecture.

This solution uses multiple route tables to separate responsibilities between Internet ingress, centralized inspection, application workloads, and inter-VPC communication.

Each subnet is associated with a dedicated route table that forwards traffic to the appropriate gateway or attachment.

---

# Routing Objectives

The routing design achieves the following goals:

- Centralized Internet ingress
- Centralized Internet egress
- Private application workloads
- Controlled inter-VPC communication
- Firewall inspection before Internet access
- Simplified expansion for future Spoke VPCs

---

# Route Table Architecture

```
                    Internet

                        │

                 Internet Gateway

                        │

               Public Route Table

                        │

                        ▼

               Application Load Balancer

                        │

                        ▼

              Transit Gateway Attachment

                        │

================ AWS Transit Gateway ================

                        │

                        ▼

              Spoke Route Table

                        │

                        ▼

              Internal Network Load Balancer

                        │

                        ▼

                Auto Scaling Group

                        │

                        ▼

                    EC2 Instances
```

---

# Hub Public Route Table

Associated Subnets

- Public Subnet AZ1
- Public Subnet AZ2

Purpose

Provides Internet connectivity for public resources.

Example Routes

| Destination | Target |
|-------------|---------|
| 10.0.0.0/16 | Local |
| 0.0.0.0/0 | Internet Gateway |
| 10.1.0.0/16 | Transit Gateway |

Explanation

- Local enables communication inside the Hub VPC.
- Internet Gateway provides public Internet connectivity.
- Transit Gateway forwards traffic to the Spoke VPC.

---

# Hub Firewall Route Table

Associated Subnets

- Firewall Subnets

Purpose

Routes inspected traffic toward the NAT Gateway and Transit Gateway.

Example Routes

| Destination | Target |
|-------------|---------|
| 10.0.0.0/16 | Local |
| 10.1.0.0/16 | Transit Gateway |
| 0.0.0.0/0 | NAT Gateway |

---

# Hub NAT Route Table

Associated Subnets

- NAT Gateway Subnet

Purpose

Provides outbound Internet access for private workloads.

Example Routes

| Destination | Target |
|-------------|---------|
| 10.0.0.0/16 | Local |
| 10.1.0.0/16 | Transit Gateway |
| 0.0.0.0/0 | Internet Gateway |

---

# Transit Gateway Attachment Route Table

Associated Resource

- Transit Gateway Attachment

Purpose

Provides routing between Hub and Spoke VPCs.

Example Routes

| Destination | Target |
|-------------|---------|
|10.0.0.0/16|Hub Attachment|
|10.1.0.0/16|Spoke Attachment|

---

# Spoke Workload Route Table

Associated Subnets

- Workload AZ1
- Workload AZ2

Purpose

Routes application traffic through the Hub VPC.

Example Routes

| Destination | Target |
|-------------|---------|
|10.1.0.0/16|Local|
|10.0.0.0/16|Transit Gateway|
|0.0.0.0/0|Transit Gateway|

The default route intentionally points to the Transit Gateway so that outbound traffic is inspected before reaching the Internet.

---

# Inbound Routing

Application requests follow this path.

```
Internet

↓

Internet Gateway

↓

Application Load Balancer

↓

Hub Route Table

↓

Transit Gateway

↓

Spoke Route Table

↓

Internal Network Load Balancer

↓

EC2
```

---

# Outbound Routing

Responses and Internet-bound traffic follow this path.

```
EC2

↓

Spoke Route Table

↓

Transit Gateway

↓

Firewall Route Table

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

# Why Default Route Uses Transit Gateway

A common design decision in centralized security architectures is to send all outbound traffic from the Spoke VPC to the Hub VPC.

Benefits

- Centralized inspection
- Single Internet exit point
- Consistent security policies
- Reduced management overhead

---

# Route Table Relationships

```
Hub Public Route Table

↓

Application Load Balancer

↓

Transit Gateway

↓

Spoke Route Table

↓

Internal NLB

↓

EC2

↓

Transit Gateway

↓

Firewall Route Table

↓

NAT Route Table

↓

Internet Gateway
```

---

# Common Routing Mistakes

## Missing TGW Route

Symptom

Application Load Balancer cannot reach the Internal NLB.

Cause

Missing route to the Spoke CIDR.

---

## Missing Return Route

Symptom

Requests reach the application but responses never return.

Cause

The Spoke route table lacks a route back to the Hub CIDR.

---

## Wrong Default Route

Symptom

Outbound traffic bypasses the firewall.

Cause

The default route points directly to a NAT Gateway instead of the Transit Gateway.

---

## Incorrect Route Table Association

Symptom

Resources become unreachable.

Cause

The subnet is associated with the wrong route table.

---

# Best Practices

- Separate public and private route tables.
- Use dedicated firewall route tables.
- Keep application workloads private.
- Centralize Internet egress.
- Avoid unnecessary route propagation.
- Document all route table associations.
- Validate routes after every architecture change.

---

# Validation

Verify:

- ALB can reach the Internal NLB.
- EC2 instances can access the Internet.
- Internet users cannot access EC2 directly.
- Firewall inspection occurs before Internet egress.
- Transit Gateway routes are propagated correctly.

---

# Screenshot Placeholders

## Figure 1 – Hub Public Route Table

> Insert AWS Console screenshot.

---

## Figure 2 – Spoke Route Table

> Insert AWS Console screenshot.

---

## Figure 3 – Transit Gateway Route Table

> Insert AWS Console screenshot.

---

## Figure 4 – Firewall Route Table

> Insert AWS Console screenshot.

---

## Figure 5 – NAT Route Table

> Insert AWS Console screenshot.

---

# Summary

The routing architecture is a key component of the Hub-and-Spoke design. By separating Internet ingress, centralized inspection, and application routing across dedicated route tables, the solution provides secure, scalable, and maintainable network connectivity while ensuring all workload traffic follows approved paths.

---

# Next Document

➡️ **09-Application-Load-Balancer.md**