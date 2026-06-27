# Cost Optimization

---

# Overview

Cost optimization is one of the six pillars of the AWS Well-Architected Framework. The objective is to deliver the required business capabilities while minimizing unnecessary infrastructure costs.

This document reviews the cost characteristics of the AWS Enterprise Hub-and-Spoke Security Architecture and provides recommendations for both lab and production environments.

---

# Objectives

The cost optimization strategy aims to:

- Minimize unnecessary AWS charges
- Maximize resource utilization
- Avoid idle resources
- Reduce operational overhead
- Maintain security without excessive cost
- Scale infrastructure based on demand

---

# Architecture Cost Overview

The primary cost contributors are:

| Service | Cost Driver |
|----------|-------------|
| Amazon EC2 | Running hours |
| Application Load Balancer | Running hours + LCU usage |
| Network Load Balancer | Running hours + LCU usage |
| AWS Transit Gateway | Attachment hours + Data Processing |
| AWS Network Firewall | Firewall endpoint hours + Data Processed |
| NAT Gateway | Running hours + Data Processing |
| Route53 | Hosted Zone + DNS Queries |
| AWS WAF | Web ACL + Rules + Requests |
| CloudWatch | Metrics + Logs |
| EBS Volumes | Provisioned Storage |

---

# Lab vs Production

| Component | Lab | Production |
|-----------|-----|------------|
| ALB | 1 | Multi-AZ |
| NLB | 1 | Multi-AZ |
| EC2 | t2.micro | Right-sized instances |
| NAT Gateway | Single NAT | NAT per AZ |
| Network Firewall | Minimal rules | Full policy |
| WAF | Custom Rules | Managed + Custom Rules |

---

# Amazon EC2

## Cost Drivers

- Instance Type
- Running Time
- EBS Volumes

## Recommendations

- Use t2.micro or t3.micro for labs.
- Stop instances when not in use.
- Delete unused instances.
- Use Auto Scaling to match demand.
- Right-size production workloads.

---

# Auto Scaling

Auto Scaling helps reduce costs by launching resources only when required.

Benefits:

- Scale out during peak traffic
- Scale in during low demand
- Reduce idle compute costs

Example:

```
CPU > 70%

↓

Launch EC2

-----------------------

CPU < 30%

↓

Terminate EC2
```

---

# Application Load Balancer

ALB pricing depends on:

- Running Hours
- Load Balancer Capacity Units (LCUs)

Recommendations:

- Use one centralized ALB.
- Remove unused listeners.
- Remove unused Target Groups.
- Monitor LCU consumption.

---

# Network Load Balancer

Pricing depends on:

- Running Hours
- Processed Traffic

Recommendations:

- Keep only one Internal NLB per application.
- Delete unused NLBs.
- Monitor throughput.

---

# AWS Transit Gateway

Pricing includes:

- Attachment Hours
- Data Processing

Recommendations:

- Use Transit Gateway only when multiple VPCs require centralized connectivity.
- Remove unused attachments.
- Review routing periodically.

---

# AWS Network Firewall

Pricing is based on:

- Firewall Endpoint Hours
- Traffic Processed

Recommendations:

- Keep rule groups optimized.
- Remove unused policies.
- Avoid unnecessary traffic through the firewall.

For lab environments, delete the firewall after testing to avoid ongoing charges.

---

# NAT Gateway

The NAT Gateway is one of the most significant cost contributors.

Pricing includes:

- Running Hours
- Data Processed

Recommendations:

- Use a single NAT Gateway in a lab.
- Delete unused NAT Gateways.
- Minimize unnecessary outbound traffic.
- Consider alternatives such as VPC Endpoints for AWS service access.

---

# Route53

Typical costs include:

- Hosted Zone
- DNS Queries
- Health Checks

Recommendations:

- Remove unused hosted zones.
- Delete unused DNS records.
- Use health checks only when required.

---

# AWS WAF

Pricing is based on:

- Web ACL
- Rules
- Requests

Recommendations:

- Remove unused rules.
- Consolidate rule groups.
- Use managed rule groups only when required.

---

# Amazon CloudWatch

Costs include:

- Metrics
- Logs
- Dashboards
- Alarms

Recommendations:

- Configure log retention periods.
- Delete unnecessary log groups.
- Archive logs to Amazon S3 if needed.
- Remove unused dashboards.

---

# Amazon EBS

Charges apply for:

- Provisioned Storage
- Snapshots

Recommendations:

- Delete unattached EBS volumes.
- Remove unused snapshots.
- Select appropriate volume types.

---

# Resource Cleanup

After completing the lab:

Delete:

- EC2 Instances
- Auto Scaling Group
- Launch Template
- Target Groups
- Application Load Balancer
- Network Load Balancer
- Transit Gateway
- Transit Gateway Attachments
- AWS Network Firewall
- Firewall Policies
- Rule Groups
- NAT Gateway
- Elastic IP
- Route53 Hosted Zone (if no longer needed)
- CloudWatch Log Groups
- Unused Security Groups
- Unused Route Tables

This prevents unnecessary charges.

---

# Resource Tagging

Use consistent tags to identify cost ownership.

Example:

| Key | Value |
|------|-------|
| Project | Hub-Spoke |
| Environment | Lab |
| Owner | Mohamed Ayman |
| CostCenter | Training |

Tags improve cost allocation and reporting.

---

# Monitoring Costs

Recommended AWS services:

- AWS Cost Explorer
- AWS Budgets
- AWS Cost and Usage Reports (CUR)
- AWS Trusted Advisor

Monitor:

- Monthly spend
- Service-level costs
- Forecasted usage
- Budget alerts

---

# Cost Optimization Checklist

| Recommendation | Status |
|---------------|--------|
| Use Auto Scaling | ✅ |
| Right-size EC2 | ✅ |
| Centralized ALB | ✅ |
| Internal NLB | ✅ |
| Remove Idle Resources | ✅ |
| Delete Unused EBS | ✅ |
| Delete Idle NAT Gateways | ✅ |
| Monitor Costs | ✅ |
| Use Resource Tags | ✅ |

---

# Estimated Cost Considerations

## Lab Environment

The architecture is intended for learning and demonstration purposes.

To minimize costs:

- Use free-tier eligible resources where possible.
- Shut down or delete resources immediately after testing.
- Avoid unnecessary data transfer.
- Keep CloudWatch logging limited to testing requirements.

## Production Environment

Production deployments should prioritize:

- High availability
- Security
- Reliability
- Scalability

These priorities may justify higher costs to meet business requirements.

---

# Best Practices

- Review AWS Cost Explorer regularly.
- Enable AWS Budgets with alerts.
- Use Auto Scaling to avoid over-provisioning.
- Right-size EC2 instances based on utilization.
- Remove unused infrastructure.
- Use consistent resource tagging.
- Review Network Firewall and NAT Gateway usage periodically.

---

# Screenshot Placeholders

## Figure 1 – AWS Cost Explorer

> Insert Cost Explorer screenshot.

---

## Figure 2 – AWS Budgets

> Insert Budget dashboard.

---

## Figure 3 – Resource Tags

> Insert tagging example.

---

## Figure 4 – Cost Breakdown

> Insert service cost graph.

---

# Summary

Cost optimization is an ongoing process rather than a one-time activity. By using managed services appropriately, implementing Auto Scaling, cleaning up unused resources, and continuously monitoring spending with AWS Cost Explorer and AWS Budgets, this Hub-and-Spoke architecture can remain both cost-efficient for lab environments and scalable for production workloads.

---

# References

- AWS Cost Optimization Pillar
- AWS Cost Explorer User Guide
- AWS Budgets Documentation
- AWS Pricing Calculator
- AWS Trusted Advisor

---

# Next Document

➡️ **20-Well-Architected-Review.md**