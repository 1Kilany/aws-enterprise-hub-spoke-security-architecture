# Troubleshooting Guide

---

# Overview

This document provides troubleshooting procedures for common issues that may occur within the AWS Enterprise Hub-and-Spoke Security Architecture.

The objective is to quickly identify the affected component, determine the root cause, and restore normal operation.

The troubleshooting process follows the end-to-end request path, beginning with DNS resolution and ending with the backend EC2 instances.

---

# Troubleshooting Methodology

Always troubleshoot from the client toward the backend.

```
Client

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

Auto Scaling Group

↓

EC2 Instance
```

Never begin troubleshooting from the EC2 instance unless infrastructure components have already been verified.

---

# Issue 1 – DNS Resolution Failure

## Symptoms

- Browser cannot resolve the application domain.
- "DNS_PROBE_FINISHED_NXDOMAIN"
- nslookup fails.

---

## Verification

```bash
nslookup example.com
```

or

```bash
dig example.com
```

---

## Possible Causes

- Hosted Zone missing
- Alias Record deleted
- Incorrect Name Servers
- Domain not delegated

---

## Resolution

- Verify Hosted Zone.
- Verify Alias Record.
- Verify domain delegation.
- Confirm Route53 configuration.

---

# Issue 2 – AWS WAF Blocking Requests

## Symptoms

- HTTP 403
- HTTP 503
- Application unreachable

---

## Verification

Review:

```
AWS WAF

↓

Web ACL

↓

Rule Matches
```

---

## Possible Causes

- Geo Match Rule
- Rate-Based Rule
- Custom Rule
- Managed Rule

---

## Resolution

- Review matched rule.
- Test in Count mode.
- Modify thresholds.
- Validate rule priority.

---

# Issue 3 – Application Load Balancer Unhealthy

## Symptoms

ALB Target Group

```
Unhealthy
```

---

## Verification

Navigate to

```
EC2

↓

Target Groups

↓

Target Health
```

---

## Possible Causes

- Incorrect Target IP
- Listener configuration
- Health Check path
- Route Table
- Security Group

---

## Resolution

- Verify IP Target Group.
- Verify NLB private IPs.
- Verify ALB Listener.
- Verify Security Groups.

---

# Issue 4 – Transit Gateway Connectivity Failure

## Symptoms

Hub cannot reach Spoke.

---

## Verification

Check:

- TGW Attachments
- TGW Route Tables
- Associations
- Propagation

---

## Possible Causes

- Missing Attachment
- Missing Route
- Incorrect Association
- Route Propagation Disabled

---

## Resolution

- Verify TGW Attachments.
- Verify propagated routes.
- Review Hub Route Table.
- Review Spoke Route Table.

---

# Issue 5 – Internal NLB Unhealthy

## Symptoms

```
No Healthy Targets
```

---

## Verification

Navigate to

```
Target Group

↓

Health
```

---

## Possible Causes

- Apache stopped
- Security Group
- Health Check failure
- Wrong Target Group

---

## Resolution

```bash
systemctl status httpd
```

Restart Apache

```bash
sudo systemctl restart httpd
```

---

# Issue 6 – Auto Scaling Does Not Register Instances

## Symptoms

New EC2 launches but receives no traffic.

---

## Verification

Review

```
Auto Scaling Group

↓

Target Group
```

---

## Possible Causes

- Wrong Target Group
- Health Check failure
- Launch Template error
- User Data failure

---

## Resolution

- Verify ASG Target Group attachment.
- Verify Launch Template.
- Verify User Data.
- Review Activity History.

---

# Issue 7 – AWS Network Firewall Blocks Traffic

## Symptoms

Internet access fails.

---

## Verification

Review

```
Firewall Policy

↓

Stateful Rule Groups
```

---

## Possible Causes

- Suricata Rule
- Route Table
- Firewall Policy
- Firewall Endpoint

---

## Resolution

Review rule

```suricata
drop icmp any any -> any any
```

Confirm expected protocols are permitted.

---

# Issue 8 – NAT Gateway Failure

## Symptoms

Private instances cannot access Internet.

---

## Verification

Review

```
Route Tables

↓

NAT Gateway
```

---

## Possible Causes

- Missing Route
- NAT deleted
- Elastic IP issue

---

## Resolution

Verify:

```
0.0.0.0/0

↓

NAT Gateway
```

---

# Issue 9 – Security Group Misconfiguration

## Symptoms

Connection timeout.

---

## Verification

Review

- ALB Security Group
- EC2 Security Group

---

## Common Mistakes

- Missing HTTP
- Missing Health Check Port
- Wrong Source CIDR

---

## Resolution

Confirm:

Inbound

```
HTTP

80

ALB Security Group
```

Outbound

```
Allow Application Traffic
```

---

# Issue 10 – Apache Not Running

## Symptoms

Health checks fail.

---

## Verification

```bash
systemctl status httpd
```

---

## Resolution

```bash
sudo systemctl restart httpd
```

Enable service

```bash
sudo systemctl enable httpd
```

---

# Issue 11 – Route Table Errors

## Symptoms

Traffic stops between Hub and Spoke.

---

## Verification

Review

- Hub Route Table
- Spoke Route Table
- TGW Route Table
- Firewall Route Table

---

## Resolution

Confirm all expected CIDRs exist.

---

# Issue 12 – User Data Failure

## Symptoms

EC2 launches without Apache.

---

## Verification

```bash
cat /var/log/cloud-init-output.log
```

---

## Resolution

Correct User Data.

Relaunch instance.

---

# Troubleshooting Flowchart

```
DNS

↓

WAF

↓

ALB

↓

Transit Gateway

↓

NLB

↓

Auto Scaling

↓

EC2

↓

Apache
```

---

# Useful AWS Services

| Service | Purpose |
|----------|----------|
| CloudWatch | Monitoring |
| VPC Reachability Analyzer | Connectivity |
| VPC Flow Logs | Network Traffic |
| CloudTrail | API Activity |
| Route53 | DNS |
| WAF Logs | Web Requests |
| Network Firewall Logs | Packet Inspection |

---

# Useful Linux Commands

Check Apache

```bash
systemctl status httpd
```

Restart Apache

```bash
sudo systemctl restart httpd
```

View User Data Log

```bash
cat /var/log/cloud-init-output.log
```

Test HTTP

```bash
curl localhost
```

Show IP

```bash
ip addr
```

Show Routes

```bash
ip route
```

---

# Best Practices

- Troubleshoot layer by layer.
- Verify DNS first.
- Confirm health checks.
- Review route tables before modifying security.
- Monitor CloudWatch metrics.
- Enable logging for WAF and Network Firewall.
- Test after every infrastructure change.

---

# Screenshot Placeholders

## Figure 1 – ALB Target Health

> Insert screenshot.

---

## Figure 2 – TGW Attachments

> Insert screenshot.

---

## Figure 3 – Firewall Policy

> Insert screenshot.

---

## Figure 4 – Route Tables

> Insert screenshot.

---

## Figure 5 – Auto Scaling Activity

> Insert screenshot.

---

## Figure 6 – CloudWatch Metrics

> Insert screenshot.

---

# Summary

Effective troubleshooting requires understanding the complete request path through the Hub-and-Spoke architecture. By validating each component in sequence—Route53, AWS WAF, Application Load Balancer, Transit Gateway, Internal Network Load Balancer, Auto Scaling Group, and EC2 instances—issues can be isolated quickly and resolved with minimal downtime.

---

# References

- AWS Transit Gateway Documentation
- AWS WAF Documentation
- AWS Network Firewall Documentation
- AWS VPC Reachability Analyzer
- Amazon CloudWatch Documentation

---

# Next Document

➡️ **18-Best-Practices.md**