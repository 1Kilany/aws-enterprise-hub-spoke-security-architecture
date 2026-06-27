# Spoke Workload VPC Design

---

# Overview

The Spoke Workload VPC hosts the application infrastructure while remaining isolated from direct Internet access.

This separation of concerns ensures that workloads remain private and can only be accessed through the centralized networking and security services hosted in the Hub VPC.

The Spoke VPC communicates with the Hub VPC through AWS Transit Gateway.

---

# Purpose

The Spoke VPC is responsible for:

- Hosting application workloads
- Internal Layer 4 load balancing
- Automatic scaling
- High availability
- Private networking

Unlike the Hub VPC, it does **not** contain Internet-facing resources.

---

# Spoke VPC CIDR

Example:

```
10.1.0.0/16
```

---

# Spoke VPC Components

| Resource | Purpose |
|----------|---------|
| Internal Network Load Balancer | Private TCP load balancing |
| Auto Scaling Group | Automatic instance management |
| Launch Template | Standard EC2 configuration |
| EC2 Web Servers | Apache application hosting |
| Private Workload Subnets | Isolated application network |
| Transit Gateway Attachment | Connectivity to Hub VPC |

---

# Spoke VPC Layout

```
              Spoke Workload VPC
                 10.1.0.0/16

+------------------------------------------------+

 Workload Subnet AZ1

      │

      ▼

Internal Network Load Balancer

      │

      ▼

NLB Target Group
(Instance)

      │

      ▼

Auto Scaling Group

      │

      ▼

EC2 Web Server

-------------------------------------------------

 Workload Subnet AZ2

      │

      ▼

EC2 Web Server

+------------------------------------------------+
```

---

# Private Workload Subnets

The workload subnets host the application servers.

Characteristics:

- Private
- No Internet Gateway
- No Public IP addresses
- Reachable only through Transit Gateway
- Multi-AZ deployment

---

# Internal Network Load Balancer

The Internal NLB distributes TCP traffic across EC2 instances.

Configuration:

- Internal
- TCP Listener
- Multi-AZ
- High Performance

Unlike the Application Load Balancer, the NLB is **not** exposed to the Internet.

---

# Why an Internal NLB?

The Internal Network Load Balancer provides:

- Low latency
- High throughput
- Static private IP addresses
- Native Auto Scaling integration

It serves as the private entry point for workloads inside the Spoke VPC.

---

# NLB Target Group

The Network Load Balancer uses an **Instance Target Group**.

Target Type:

```
Instance
```

Targets:

```
EC2 Instance 1

EC2 Instance 2

...
```

The Auto Scaling Group automatically manages the registration and deregistration of instances.

---

# Auto Scaling Group

The Auto Scaling Group maintains the required application capacity.

Responsibilities:

- Launch new EC2 instances
- Replace unhealthy instances
- Register instances with the NLB Target Group
- Distribute instances across multiple Availability Zones

Example Configuration:

| Parameter | Value |
|-----------|-------|
| Minimum Capacity | 2 |
| Desired Capacity | 2 |
| Maximum Capacity | 4 |

---

# Launch Template

The Launch Template standardizes EC2 deployments.

Typical configuration includes:

- Amazon Linux AMI
- Instance Type
- Security Group
- IAM Role
- User Data
- Key Pair

Example User Data:

```bash
#!/bin/bash

yum update -y
yum install httpd -y

systemctl enable httpd
systemctl start httpd

echo "Server $(hostname)" > /var/www/html/index.html
```

---

# EC2 Web Servers

The application layer is hosted on Amazon EC2 instances.

Responsibilities:

- Serve HTTP requests
- Process application traffic
- Return responses through the NLB

Each instance is automatically registered with the Target Group.

---

# Traffic Flow

Inbound traffic:

```
Application Load Balancer

↓

Transit Gateway

↓

Internal NLB

↓

Instance Target Group

↓

EC2 Instance
```

Outbound traffic:

```
EC2 Instance

↓

Transit Gateway

↓

AWS Network Firewall

↓

NAT Gateway

↓

Internet
```

---

# Security

The Spoke VPC is intentionally isolated.

Security controls include:

- Private subnets
- Security Groups
- Transit Gateway routing
- Internal NLB
- No Internet Gateway
- No public EC2 instances

---

# High Availability

The Spoke VPC uses Multi-AZ deployment.

Resources distributed across Availability Zones include:

- Internal NLB
- Auto Scaling Group
- EC2 Instances
- Workload Subnets

This allows the application to continue operating if one Availability Zone becomes unavailable.

---

# Scalability

Scaling is fully automated.

When traffic increases:

1. Auto Scaling launches new EC2 instances.
2. Instances register with the NLB Target Group.
3. The NLB begins forwarding traffic immediately.
4. The ALB continues forwarding requests without configuration changes.

---

# Design Decisions

| Decision | Reason |
|----------|--------|
| Private VPC | Improved security |
| Internal NLB | Private load balancing |
| Instance Target Group | Auto Scaling integration |
| Auto Scaling | Automatic capacity management |
| Multi-AZ | High availability |
| Transit Gateway | Centralized routing |

---

# Benefits

The Spoke Workload VPC provides:

- Secure private workloads
- Automatic scaling
- High availability
- Network isolation
- Simplified operations
- Centralized security
- Enterprise-ready application hosting

---

# Screenshot Placeholders

## Figure 1 – Spoke VPC Overview

> Insert Spoke VPC screenshot.

---

## Figure 2 – Internal Network Load Balancer

> Insert NLB configuration screenshot.

---

## Figure 3 – NLB Target Group

> Insert Target Group screenshot.

---

## Figure 4 – Auto Scaling Group

> Insert ASG screenshot.

---

## Figure 5 – Launch Template

> Insert Launch Template screenshot.

---

## Figure 6 – EC2 Instances

> Insert EC2 Instances screenshot.

---

## Figure 7 – Route Table

> Insert Spoke Route Table screenshot.

---

# Summary

The Spoke Workload VPC hosts the application infrastructure while remaining isolated from direct Internet access. Combined with the Hub VPC, Transit Gateway, and centralized security controls, this design provides a scalable, secure, and highly available platform suitable for enterprise workloads.

---

# Next Document

➡️ **07-Transit-Gateway.md**