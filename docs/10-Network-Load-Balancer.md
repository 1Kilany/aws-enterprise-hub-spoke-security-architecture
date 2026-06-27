# Internal Network Load Balancer (NLB)

---

# Overview

The Internal Network Load Balancer (NLB) is deployed within the Spoke Workload VPC and serves as the private entry point for application traffic.

Unlike the Internet-facing Application Load Balancer located in the Hub VPC, the Internal NLB is not directly accessible from the Internet.

Its primary responsibility is to distribute incoming traffic across healthy EC2 instances managed by the Auto Scaling Group.

---

# Purpose

The Internal Network Load Balancer provides:

- Private Layer 4 load balancing
- High-performance TCP forwarding
- Automatic distribution of application traffic
- Native Auto Scaling integration
- High availability across multiple Availability Zones

---

# Deployment Location

The Internal NLB is deployed inside the **Spoke Workload VPC**.

```
               Spoke Workload VPC

        +-------------------------------+

             Internal Network Load Balancer

                      │

             Instance Target Group

                      │

             Auto Scaling Group

                 │             │

                 ▼             ▼

             EC2 AZ1      EC2 AZ2

        +-------------------------------+
```

---

# Why Internal?

The application servers should never be exposed directly to the Internet.

Only the Hub VPC provides Internet access.

Advantages include:

- Private workloads
- Reduced attack surface
- Centralized ingress
- Improved security
- Enterprise network segmentation

---

# NLB Configuration

| Property | Value |
|----------|-------|
| Type | Network Load Balancer |
| Scheme | Internal |
| Listener | TCP |
| Target Type | Instance |
| Availability | Multi-AZ |

---

# Why Network Load Balancer?

The architecture requires:

- High throughput
- Low latency
- Static private IP addresses
- Layer 4 forwarding
- Native Auto Scaling support

These requirements make the Network Load Balancer the appropriate choice.

---

# Listener Configuration

The NLB listens on:

```
TCP

Port 80
```

When traffic arrives from the Application Load Balancer, the NLB forwards it to healthy EC2 instances.

---

# Instance Target Group

Unlike the Application Load Balancer, the NLB uses an **Instance Target Group**.

```
Target Type

Instance
```

Registered Targets:

```
EC2 Instance

EC2 Instance

EC2 Instance
```

Instances are registered automatically by the Auto Scaling Group.

---

# Auto Scaling Integration

The NLB Target Group is attached directly to the Auto Scaling Group.

When the Auto Scaling Group launches a new EC2 instance:

1. Instance starts.
2. User Data installs Apache.
3. Health checks pass.
4. Instance registers automatically with the NLB Target Group.
5. NLB begins forwarding traffic.

When an instance terminates:

1. Instance is deregistered.
2. Active connections complete.
3. Traffic is redirected to healthy instances.

No manual intervention is required.

---

# Health Checks

The NLB continuously monitors target health.

Example configuration:

| Parameter | Value |
|-----------|-------|
| Protocol | TCP |
| Port | Traffic Port |
| Healthy Threshold | 3 |
| Unhealthy Threshold | 3 |
| Interval | 30 Seconds |

Only healthy EC2 instances receive traffic.

---

# Traffic Flow

Application traffic follows this sequence:

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

Internal Network Load Balancer

↓

Instance Target Group

↓

EC2
```

The NLB never receives traffic directly from the Internet.

---

# Availability Zones

The Internal NLB spans multiple Availability Zones.

Example:

```
Availability Zone A

↓

NLB Node

↓

EC2 Instance

-----------------------

Availability Zone B

↓

NLB Node

↓

EC2 Instance
```

This ensures continued service if an Availability Zone becomes unavailable.

---

# Security

The NLB resides in private subnets.

Security is provided through:

- Private networking
- Transit Gateway
- Security Groups
- AWS WAF (upstream)
- AWS Network Firewall (egress inspection)

The NLB itself does not enforce Layer 7 security policies.

---

# Design Decisions

| Decision | Reason |
|----------|--------|
| Internal Scheme | Keep workloads private |
| TCP Listener | High-performance forwarding |
| Instance Target Group | Auto Scaling integration |
| Multi-AZ | High availability |
| Private Subnets | Security |

---

# Advantages

Using an Internal NLB provides:

- High throughput
- Low latency
- Private application access
- Native EC2 integration
- Automatic scaling
- Enterprise-ready architecture

---

# Failure Scenario

### EC2 Failure

If an EC2 instance becomes unhealthy:

1. Health checks fail.
2. NLB marks the instance unhealthy.
3. Traffic is redirected to healthy instances.
4. Auto Scaling replaces the failed instance.
5. New instance registers automatically.

The application remains available.

---

# Monitoring

Recommended CloudWatch metrics:

- HealthyHostCount
- UnHealthyHostCount
- ActiveFlowCount
- NewFlowCount
- ProcessedBytes
- TCPClientResetCount
- TCPTargetResetCount

These metrics help monitor application health and performance.

---

# Best Practices

- Deploy the NLB across multiple Availability Zones.
- Use private subnets only.
- Enable cross-zone load balancing if required.
- Monitor target health regularly.
- Attach the Target Group directly to the Auto Scaling Group.
- Do not expose the NLB to the Internet.
- Keep listener configuration simple and consistent.

---

# Screenshot Placeholders

## Figure 1 – Internal Network Load Balancer

> Insert NLB Overview screenshot.

---

## Figure 2 – Listener Configuration

> Insert Listener screenshot.

---

## Figure 3 – Target Group

> Insert Target Group screenshot.

---

## Figure 4 – Registered Targets

> Insert Registered Targets screenshot.

---

## Figure 5 – Target Health

> Insert Target Health screenshot.

---

## Figure 6 – Auto Scaling Group Attachment

> Insert ASG Attachment screenshot.

---

# Summary

The Internal Network Load Balancer provides private, high-performance traffic distribution within the Spoke Workload VPC. By using an Instance Target Group integrated with the Auto Scaling Group, it ensures automatic scaling, fault tolerance, and high availability while keeping application servers isolated from direct Internet access. Combined with the Application Load Balancer in the Hub VPC, this design delivers a secure and enterprise-grade application delivery architecture.

---

# Next Document

➡️ **11-AWS-WAF.md**