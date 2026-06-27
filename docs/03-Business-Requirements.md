# Business Requirements

---

# Purpose

This document defines the business and technical requirements that led to the implementation of the AWS Hub-and-Spoke architecture. It outlines the functional and non-functional requirements, project scope, assumptions, constraints, and success criteria that guided the solution design.

The architecture is intended to demonstrate an enterprise-inspired AWS networking solution that emphasizes centralized security, scalability, high availability, and operational simplicity.

---

# Business Objectives

The solution was designed to achieve the following business objectives:

- Provide a secure and centralized Internet entry point for web applications.
- Separate networking and security infrastructure from application workloads.
- Improve scalability through automated resource provisioning.
- Ensure high availability by distributing workloads across multiple Availability Zones.
- Simplify network management using centralized routing.
- Demonstrate an enterprise-ready AWS architecture suitable for production environments.
- Reduce operational overhead by leveraging managed AWS services.
- Provide a reusable architecture that can support additional application VPCs in the future.

---

# Existing Challenges

Traditional VPC deployments often expose several operational challenges:

- Each application requires its own Internet-facing infrastructure.
- Security policies are duplicated across environments.
- Traffic inspection is inconsistent.
- Network routing becomes difficult as additional VPCs are added.
- Operational costs increase due to duplicated infrastructure.
- Scaling multiple independent environments becomes difficult.

These challenges become more significant as organizations grow and deploy additional applications.

---

# Proposed Solution

The proposed solution centralizes networking and security services inside a dedicated Hub VPC while hosting applications inside isolated Spoke VPCs.

This architecture introduces:

- Centralized ingress through an Internet-facing Application Load Balancer.
- Centralized web protection using AWS WAF.
- Centralized network inspection using AWS Network Firewall.
- Centralized routing through AWS Transit Gateway.
- Private application workloads protected from direct Internet access.
- Automated scaling using Auto Scaling Groups.

---

# Functional Requirements

The architecture must satisfy the following functional requirements.

## Internet Access

The application must be reachable from the public Internet.

Traffic must enter through:

- Amazon Route53
- AWS WAF
- Application Load Balancer

Direct access to EC2 instances is prohibited.

---

## DNS Resolution

The solution shall provide DNS resolution using Amazon Route53.

Requirements include:

- Public hosted zone
- Friendly domain name
- ALB Alias Record

---

## Web Application Protection

The solution shall inspect incoming HTTP requests before reaching the application.

Protection mechanisms include:

- Geo Match Rules
- Rate-Based Rules
- Custom Block Responses

AWS WAF must be associated with the Application Load Balancer.

---

## Load Balancing

The architecture shall provide two levels of load balancing.

### Layer 7

Application Load Balancer

Responsibilities:

- HTTP Routing
- Internet Entry Point
- WAF Integration

---

### Layer 4

Internal Network Load Balancer

Responsibilities:

- TCP Distribution
- High Performance
- Auto Scaling Integration

---

## High Availability

The application shall continue operating if:

- One EC2 instance fails.
- One Availability Zone becomes unavailable.
- One Load Balancer node becomes unavailable.

---

## Automatic Scaling

The application shall automatically adjust compute capacity according to demand.

Requirements include:

- Launch Template
- Auto Scaling Group
- Automatic Target Registration

---

## Centralized Routing

The solution shall use AWS Transit Gateway to provide routing between VPCs.

No VPC Peering shall be used.

---

## Network Inspection

Outbound traffic shall pass through AWS Network Firewall before leaving AWS.

Inspection policies may include:

- ICMP filtering
- Domain filtering
- Protocol filtering
- Stateful inspection

---

# Non-Functional Requirements

## Availability

The solution shall provide high availability through Multi-AZ deployment.

---

## Scalability

The solution shall support horizontal scaling without redesigning the network.

---

## Security

The architecture shall implement defense-in-depth security.

Security controls include:

- AWS WAF
- AWS Network Firewall
- Security Groups
- Private Subnets
- Transit Gateway

---

## Reliability

Managed AWS services shall be used wherever possible to reduce operational complexity.

---

## Maintainability

Networking and workloads shall be separated into independent VPCs.

Configuration should be modular and easy to expand.

---

## Performance

The architecture shall minimize latency while supporting automatic scaling.

---

# Assumptions

The following assumptions apply:

- AWS Region supports all required services.
- Route53 hosted zone is configured.
- Internet connectivity is available.
- EC2 instances run Amazon Linux.
- Apache HTTP Server is installed using User Data.
- Auto Scaling health checks are enabled.
- Transit Gateway attachments are operational.
- Required IAM permissions exist.

---

# Constraints

The following constraints apply:

- Single AWS Region deployment.
- One Hub VPC.
- One Spoke Workload VPC.
- HTTP traffic only.
- IPv4 networking.
- Public Internet access through Hub VPC only.

---

# Success Criteria

The project is considered successful when:

- Route53 resolves the application successfully.
- AWS WAF inspects inbound requests.
- The ALB forwards traffic to the Internal NLB.
- The NLB distributes traffic across EC2 instances.
- Auto Scaling automatically registers new instances.
- Transit Gateway provides connectivity between Hub and Spoke VPCs.
- AWS Network Firewall inspects outbound traffic.
- Application remains available during EC2 instance failure.

---

# Out of Scope

The following items are intentionally excluded from this project:

- Multi-Region deployment
- IPv6 networking
- Hybrid connectivity (VPN / Direct Connect)
- Kubernetes (EKS)
- ECS
- AWS Global Accelerator
- AWS Shield Advanced
- CI/CD Pipeline
- Infrastructure as Code (Terraform and CloudFormation)

These can be considered future enhancements.

---

# Risks

Potential risks include:

| Risk | Mitigation |
|------|------------|
| Incorrect routing | Validate all route tables |
| Failed health checks | Verify Target Group configuration |
| Security misconfiguration | Apply least-privilege principles |
| Firewall rule conflicts | Test all Suricata rules |
| Scaling delays | Configure Auto Scaling health checks |

---

# Screenshot Placeholders

## Figure 1 – Overall Architecture

> Insert architecture diagram.

---

## Figure 2 – AWS Service Overview

> Insert AWS Console overview.

---

## Figure 3 – Business Flow

> Insert traffic flow diagram.

---

# Key Deliverables

The project delivers:

- Hub-and-Spoke architecture
- Centralized routing
- Centralized security
- Application Load Balancer
- Internal Network Load Balancer
- AWS WAF
- AWS Network Firewall
- Transit Gateway
- Auto Scaling Group
- Route53 integration
- Enterprise-inspired AWS networking design

---
