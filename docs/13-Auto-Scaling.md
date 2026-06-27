# Auto Scaling Group (ASG)

---

# Overview

The Auto Scaling Group (ASG) is responsible for maintaining application availability by automatically launching, terminating, and replacing Amazon EC2 instances based on the desired capacity and health status.

Within this Hub-and-Spoke architecture, the ASG is deployed in the Spoke Workload VPC and is integrated with the Internal Network Load Balancer (NLB). This ensures that application traffic is always distributed only to healthy EC2 instances.

---

# Architecture

```
             Internal NLB

                   │

                   ▼

        Instance Target Group

                   │

                   ▼

          Auto Scaling Group

           │             │

           ▼             ▼

       EC2 Instance   EC2 Instance

           │             │

           ▼             ▼

     Apache Web App  Apache Web App
```

---

# Purpose

The Auto Scaling Group provides:

- High availability
- Automatic recovery
- Automatic scaling
- EC2 lifecycle management
- Target Group registration
- Multi-AZ deployment

---

# Deployment

The Auto Scaling Group is deployed inside the **Spoke Workload VPC**.

Resources associated with the ASG include:

- Launch Template
- Instance Target Group
- Internal Network Load Balancer
- Private Subnets
- Security Groups

---

# Launch Template

The Launch Template defines the EC2 configuration used whenever the ASG launches a new instance.

Typical configuration:

| Parameter | Value |
|-----------|-------|
| AMI | Amazon Linux |
| Instance Type | t2.micro *(example)* |
| IAM Role | EC2 Instance Profile |
| Security Group | Web Security Group |
| Key Pair | Optional |
| User Data | Apache Installation |

---

# User Data

The following User Data installs Apache automatically.

```bash
#!/bin/bash

yum update -y

yum install httpd -y

systemctl enable httpd

systemctl start httpd

echo "<h1>$(hostname)</h1>" > /var/www/html/index.html
```

Every newly launched instance becomes immediately available after the health checks succeed.

---

# Auto Scaling Configuration

Example configuration:

| Setting | Value |
|----------|-------|
| Desired Capacity | 2 |
| Minimum Capacity | 2 |
| Maximum Capacity | 4 |

This ensures that at least two EC2 instances remain available across multiple Availability Zones.

---

# Availability Zones

The Auto Scaling Group spans multiple Availability Zones.

Example:

```
Availability Zone A

↓

EC2 Instance

-----------------------

Availability Zone B

↓

EC2 Instance
```

If one Availability Zone fails, the remaining instances continue serving traffic.

---

# Target Group Integration

The Auto Scaling Group is attached directly to the **Internal NLB Instance Target Group**.

Target Type:

```
Instance
```

Whenever the Auto Scaling Group launches an instance:

```
Launch Instance

↓

Health Check

↓

Register with Target Group

↓

Receive Traffic
```

No manual registration is required.

---

# Health Checks

The Auto Scaling Group monitors instance health using:

- EC2 Status Checks
- Elastic Load Balancing Health Checks

If an instance becomes unhealthy:

1. Health check fails.
2. Instance is marked unhealthy.
3. Auto Scaling terminates the instance.
4. A replacement instance is launched.
5. The new instance registers with the NLB Target Group.

---

# Scaling Process

When demand increases:

```
High CPU

↓

Scaling Policy Triggered

↓

Launch New EC2

↓

Run User Data

↓

Health Check Passes

↓

Register with NLB

↓

Receive Traffic
```

When demand decreases:

```
Low CPU

↓

Scaling Policy Triggered

↓

Deregister Instance

↓

Connection Draining

↓

Terminate EC2
```

---

# Scaling Policies

Common scaling metrics include:

- CPU Utilization
- Network In
- Network Out
- Request Count
- Custom CloudWatch Metrics

Example policy:

```
CPU > 70%

Scale Out

---------------------

CPU < 30%

Scale In
```

---

# Traffic Flow

```
Application Load Balancer

↓

Transit Gateway

↓

Internal NLB

↓

Instance Target Group

↓

Auto Scaling Group

↓

Healthy EC2 Instance
```

---

# Failure Recovery

Example scenario:

```
EC2 Failure

↓

Health Check Failed

↓

Instance Removed

↓

Launch Replacement

↓

Register New Instance

↓

Traffic Restored
```

This process occurs automatically without administrator intervention.

---

# Security

Instances launched by the Auto Scaling Group inherit:

- IAM Role
- Security Groups
- Launch Template
- User Data
- Private Subnet Placement

No public IP addresses are assigned.

---

# High Availability

The ASG contributes to high availability by:

- Deploying across multiple Availability Zones
- Replacing failed instances automatically
- Maintaining the desired capacity
- Integrating with the Internal NLB

---

# Monitoring

Useful CloudWatch metrics include:

- GroupDesiredCapacity
- GroupInServiceInstances
- GroupPendingInstances
- GroupTerminatingInstances
- GroupTotalInstances
- CPUUtilization

---

# Best Practices

- Deploy instances across multiple Availability Zones.
- Use Launch Templates instead of Launch Configurations.
- Enable Elastic Load Balancing health checks.
- Configure meaningful scaling thresholds.
- Keep User Data idempotent.
- Avoid assigning public IP addresses.
- Monitor scaling events using CloudWatch.

---

# Common Issues

### Instance Never Becomes Healthy

Possible causes:

- Apache not running
- Incorrect User Data
- Security Group blocking traffic
- Failed health checks

---

### Instance Not Registered

Possible causes:

- Target Group not attached
- Wrong Target Type
- Failed health checks

---

### Continuous Scaling

Possible causes:

- Aggressive scaling thresholds
- Incorrect CloudWatch alarms
- High application load

---

# Screenshot Placeholders

## Figure 1 – Auto Scaling Group

> Insert ASG overview screenshot.

---

## Figure 2 – Launch Template

> Insert Launch Template screenshot.

---

## Figure 3 – Scaling Policies

> Insert Scaling Policy screenshot.

---

## Figure 4 – Target Group Attachment

> Insert ASG Target Group screenshot.

---

## Figure 5 – Activity History

> Insert Activity History screenshot.

---

## Figure 6 – EC2 Instances

> Insert EC2 instances screenshot.

---

## Figure 7 – CloudWatch Metrics

> Insert monitoring screenshot.

---

# Summary

The Auto Scaling Group ensures that the application remains highly available and scalable by automatically managing EC2 instance lifecycle operations. Integrated with the Internal Network Load Balancer, it provides automatic registration, health monitoring, and recovery, allowing the architecture to respond dynamically to failures and changing workloads without manual intervention.

---

# References

- AWS Auto Scaling User Guide
- Amazon EC2 Auto Scaling Best Practices
- Elastic Load Balancing Documentation

---

# Next Document

➡️ **14-Route53.md**