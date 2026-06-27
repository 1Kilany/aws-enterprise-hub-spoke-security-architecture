# AWS Enterprise Hub-and-Spoke Security Architecture

## Overview

Enterprise AWS Hub-and-Spoke architecture implementing:

- Transit Gateway
- AWS Network Firewall
- AWS WAF
- Internet-facing Application Load Balancer
- Internal Network Load Balancer
- Auto Scaling Group
- Route53
- Centralized Security Inspection
- Multi-AZ Deployment

---

## Architecture

Internet

↓

Route53

↓

AWS WAF

↓

Application Load Balancer (Hub)

↓

ALB Target Group (IP)

↓

Transit Gateway

↓

Internal Network Load Balancer (Spoke)

↓

NLB Target Group (Instance)

↓

Auto Scaling Group

↓

EC2 Web Servers

---

## Documentation

See the **docs/** folder.

---

## Screenshots

See the **screenshots/** folder.

