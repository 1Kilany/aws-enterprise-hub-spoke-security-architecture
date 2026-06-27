# Traffic Flow Analysis

---

# Overview

This document describes how network traffic traverses the AWS Enterprise Hub-and-Spoke Security Architecture.

Understanding packet flow is essential for validating routing, troubleshooting connectivity, and ensuring that traffic follows the intended security inspection path.

The architecture separates inbound and outbound traffic while centralizing routing and security services inside the Hub VPC.

---

# Traffic Types

The architecture processes two primary traffic flows:

- Inbound Application Traffic
- Outbound Internet Traffic

Each flow follows a different routing path.

---

# High-Level Traffic Flow

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
                     │
                     ▼
         ALB Target Group (IP Targets)
                     │
                     ▼
            AWS Transit Gateway
                     │
                     ▼
      Internal Network Load Balancer
                     │
                     ▼
      NLB Target Group (Instance)
                     │
                     ▼
          Auto Scaling Group
                     │
                     ▼
               EC2 Web Server
```

---

# Inbound Request Flow

A client accesses the application through its public domain name.

The following sequence occurs.

---

## Step 1 – DNS Resolution

The client sends a DNS query.

```
Client

↓

Amazon Route53
```

Route53 returns the DNS Alias record for the Internet-facing Application Load Balancer.

---

## Step 2 – HTTP Request

The browser sends the HTTP request.

```
Client

↓

Internet-facing ALB
```

---

## Step 3 – AWS WAF Inspection

Because AWS WAF is associated with the ALB, every request is evaluated before being forwarded.

The Web ACL evaluates:

- Geo Match Rules
- Rate-Based Rules
- Custom Rules

If blocked:

```
Client

↓

AWS WAF

↓

HTTP 503
```

If allowed:

Traffic proceeds to the ALB listener.

---

## Step 4 – Application Load Balancer

The ALB receives the request.

Responsibilities:

- Accept HTTP traffic
- Evaluate listener rules
- Forward traffic

The ALB forwards traffic to an IP Target Group.

---

## Step 5 – IP Target Group

Unlike a traditional architecture, the ALB does **not** target EC2 instances.

Instead, the Target Group contains the **private IP addresses assigned to the Internal Network Load Balancer** in the Spoke VPC.

This allows the Hub VPC to remain the centralized ingress point while keeping workloads private.

---

## Step 6 – Transit Gateway Routing

Traffic destined for the Spoke VPC is routed through AWS Transit Gateway.

Responsibilities:

- Route between VPCs
- Maintain Hub-and-Spoke connectivity
- Support future Spoke VPC expansion

Transit Gateway performs routing only.

It does **not** inspect traffic.

---

## Step 7 – Internal Network Load Balancer

The Internal Network Load Balancer receives the TCP connection.

Responsibilities:

- Select a healthy EC2 instance
- Distribute traffic
- Maintain high availability

---

## Step 8 – Instance Target Group

The Instance Target Group contains EC2 instances registered automatically by the Auto Scaling Group.

Only healthy instances receive traffic.

---

## Step 9 – EC2 Web Server

The selected EC2 instance processes the request.

Apache returns the application response.

```
EC2

↓

NLB

↓

ALB

↓

Client
```

---

# Outbound Traffic Flow

Outbound traffic follows a different path to ensure centralized inspection.

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

## Step 1 – EC2 Generates Traffic

The application initiates an outbound connection.

Examples:

- Software updates
- Package installation
- External API requests

---

## Step 2 – Spoke Route Table

The default route:

```
0.0.0.0/0
```

points to the Transit Gateway.

This ensures all outbound traffic reaches the Hub VPC.

---

## Step 3 – Transit Gateway

Transit Gateway forwards packets to the Hub VPC.

No packet inspection occurs here.

---

## Step 4 – AWS Network Firewall

Traffic reaches the Firewall Endpoint.

AWS Network Firewall evaluates:

- Stateless Rules
- Stateful Rules
- Suricata Rules

Example:

```suricata
drop icmp any any -> any any (
msg:"Block ICMP";
sid:1000001;
rev:1;
)
```

Packets matching a drop rule are discarded.

---

## Step 5 – NAT Gateway

Allowed traffic reaches the NAT Gateway.

The NAT Gateway:

- Translates private source IP addresses
- Provides outbound Internet access

The NAT Gateway does not allow unsolicited inbound connections.

---

## Step 6 – Internet Gateway

The Internet Gateway provides public Internet connectivity.

Traffic exits AWS.

---

# Return Traffic

Response traffic follows the reverse path.

```
Internet

↓

Internet Gateway

↓

NAT Gateway

↓

AWS Network Firewall

↓

Transit Gateway

↓

Spoke VPC

↓

EC2
```

Stateful inspection ensures return traffic for established sessions is permitted.

---

# Failure Scenarios

## EC2 Failure

```
Health Check Failed

↓

Target Marked Unhealthy

↓

NLB Stops Sending Traffic

↓

ASG Launches Replacement
```

---

## Availability Zone Failure

The NLB and ASG continue serving traffic using healthy resources in the remaining Availability Zone.

---

## WAF Block

Requests matching a WAF rule are blocked before reaching the ALB.

---

## Firewall Block

Packets matching a Suricata drop rule are discarded before reaching the NAT Gateway.

---

# Security Inspection Path

Inbound:

```
Client

↓

Route53

↓

AWS WAF

↓

ALB

↓

TGW

↓

NLB

↓

EC2
```

Outbound:

```
EC2

↓

TGW

↓

AWS Network Firewall

↓

NAT Gateway

↓

Internet
```

---

# Packet Inspection Responsibilities

| Component | Responsibility |
|------------|----------------|
| Route53 | DNS Resolution |
| AWS WAF | Layer 7 HTTP Inspection |
| ALB | HTTP Routing |
| Transit Gateway | Inter-VPC Routing |
| Internal NLB | TCP Load Balancing |
| Auto Scaling Group | Instance Lifecycle |
| AWS Network Firewall | Stateful Packet Inspection |
| NAT Gateway | Private-to-Public Translation |

---

# Best Practices

- Keep ingress centralized through the Hub VPC.
- Route all outbound traffic through the firewall.
- Avoid direct Internet access from the Spoke VPC.
- Monitor ALB, NLB, WAF, and Firewall metrics.
- Validate health checks regularly.
- Test routing after infrastructure changes.

---

# Screenshot Placeholders

## Figure 1 – Inbound Packet Flow

> Insert traffic flow diagram.

---

## Figure 2 – Outbound Packet Flow

> Insert outbound routing diagram.

---

## Figure 3 – ALB Target Group

> Insert ALB Target Group screenshot.

---

## Figure 4 – NLB Target Group

> Insert NLB Target Group screenshot.

---

## Figure 5 – Firewall Inspection

> Insert AWS Network Firewall screenshot.

---

## Figure 6 – Successful Browser Test

> Insert browser screenshot.

---

## Figure 7 – Blocked ICMP Test

> Insert Suricata ICMP blocking test.

---

# Summary

The Hub-and-Spoke architecture separates inbound application delivery from outbound Internet access while centralizing routing and security controls. Client requests enter through Route 53, AWS WAF, and the Internet-facing Application Load Balancer before being routed to the Internal Network Load Balancer and EC2 instances. Outbound traffic follows a dedicated inspection path through AWS Transit Gateway, AWS Network Firewall, and the NAT Gateway, ensuring that all Internet-bound traffic is evaluated against centralized security policies before leaving the AWS environment.

---

# References

- AWS Transit Gateway Documentation
- AWS Elastic Load Balancing Documentation
- AWS Network Firewall Documentation
- AWS WAF Developer Guide

---

# Next Document

➡️ **16-Testing.md**