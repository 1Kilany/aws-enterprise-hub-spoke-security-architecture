# AWS Network Firewall

---

# Overview

AWS Network Firewall provides centralized Layer 3 through Layer 7 network security for the Hub-and-Spoke architecture.

Unlike AWS WAF, which protects HTTP and HTTPS traffic, AWS Network Firewall inspects all supported IP traffic passing through the Hub VPC.

The firewall is deployed inside dedicated Firewall Subnets and is responsible for inspecting outbound traffic from the Spoke Workload VPC before it reaches the Internet.

This centralized inspection model allows all connected VPCs to share the same security policies.

---

# Architecture

```
                 Internet

                     ▲

             Internet Gateway

                     ▲

              NAT Gateway

                     ▲

         AWS Network Firewall

                     ▲

             Transit Gateway

                     ▲

              Spoke VPC

                     ▲

             EC2 Instances
```

---

# Purpose

AWS Network Firewall is responsible for:

- Stateful packet inspection
- Protocol filtering
- Domain filtering
- Traffic inspection
- Threat prevention
- Centralized security policy enforcement

---

# Deployment

The firewall is deployed inside the Hub VPC.

Resources include:

- Firewall
- Firewall Policy
- Stateful Rule Groups
- Stateless Rule Groups
- Firewall Endpoints

Traffic reaches the firewall through route table associations.

---

# Firewall Components

## Firewall

The Firewall is the inspection engine.

It attaches to one or more dedicated Firewall Subnets.

Responsibilities:

- Receive routed traffic
- Apply firewall policies
- Forward allowed traffic
- Drop denied traffic

---

## Firewall Policy

The Firewall Policy defines how packets are evaluated.

The policy references:

- Stateless Rule Groups
- Stateful Rule Groups

Every packet entering the firewall is evaluated according to this policy.

---

## Firewall Endpoints

When AWS Network Firewall is deployed, AWS automatically creates Firewall Endpoints.

Each endpoint is placed inside a Firewall Subnet.

Example

```
Firewall Subnet AZ1

↓

Firewall Endpoint

----------------------

Firewall Subnet AZ2

↓

Firewall Endpoint
```

Route tables forward traffic to these endpoints.

---

# Traffic Flow

Outbound traffic follows this sequence.

```
EC2 Instance

↓

Spoke Route Table

↓

Transit Gateway

↓

Firewall Route Table

↓

Firewall Endpoint

↓

Firewall Policy

↓

Allowed?

↓

YES

↓

NAT Gateway

↓

Internet Gateway

↓

Internet
```

If traffic is denied:

```
Firewall

↓

Drop Packet
```

---

# Stateful Rule Groups

Stateful Rule Groups inspect complete network sessions.

AWS Network Firewall uses the Suricata engine.

Examples include:

- Protocol filtering
- Domain filtering
- ICMP filtering
- Custom enterprise rules

---

# Stateless Rule Groups

Stateless Rule Groups evaluate packets individually.

Typical use cases:

- Allow
- Drop
- Forward
- Fast packet filtering

Stateless rules execute before Stateful inspection.

---

# Suricata

AWS Network Firewall uses the Suricata rule engine.

Benefits include:

- Mature IDS/IPS syntax
- Flexible rule creation
- Enterprise security
- Stateful inspection

---

# Example Rule

The following example blocks ICMP traffic.

```suricata
drop icmp any any -> any any (
msg:"Block ICMP";
sid:1000001;
rev:1;
)
```

This rule prevents ICMP Echo Requests from passing through the firewall.

---

# Rule Evaluation

Traffic enters the firewall.

↓

Stateless Rules

↓

Stateful Rules

↓

Allow or Drop

↓

Forward Traffic

Only permitted traffic reaches the NAT Gateway.

---

# Centralized Inspection

One major advantage of this architecture is centralized security.

Instead of deploying firewalls inside every application VPC, all traffic is inspected within the Hub VPC.

Benefits include:

- Consistent policies
- Easier management
- Lower operational overhead
- Simplified auditing
- Enterprise scalability

---

# Route Table Integration

AWS Network Firewall does not inspect traffic automatically.

Traffic must be routed through the firewall.

Typical routing:

```
Spoke Route Table

↓

Transit Gateway

↓

Firewall Route Table

↓

Firewall Endpoint

↓

NAT Gateway

↓

Internet
```

Incorrect route table configuration prevents inspection.

---

# Security Policy

Example security policy:

| Rule | Action |
|------|--------|
| Allow Established Connections | Pass |
| Block ICMP | Drop |
| Allow HTTP | Pass |
| Allow HTTPS | Pass |
| Drop Unknown Traffic | Drop |

Policies should follow the principle of least privilege.

---

# Testing

## Test 1

Ping from one EC2 instance.

Expected Result

```
Dropped
```

---

## Test 2

HTTP request.

Expected Result

```
Allowed
```

---

## Test 3

HTTPS request.

Expected Result

```
Allowed
```

---

## Test 4

Custom blocked protocol.

Expected Result

```
Dropped
```

---

# Monitoring

Useful CloudWatch metrics:

- PacketsProcessed
- PacketsDropped
- BytesProcessed
- StatefulRuleMatches
- StatelessRuleMatches

Logging destinations:

- CloudWatch Logs
- Amazon S3
- Amazon Kinesis Data Firehose

---

# High Availability

AWS Network Firewall is deployed across multiple Availability Zones.

Benefits:

- Fault tolerance
- Automatic scaling
- Managed infrastructure
- No customer-managed appliances

Firewall Endpoints exist in each configured Availability Zone.

---

# Best Practices

- Deploy dedicated Firewall Subnets.
- Route all outbound traffic through the firewall.
- Use Stateful Rule Groups for application-aware filtering.
- Keep Stateless Rules lightweight.
- Monitor CloudWatch metrics.
- Review firewall logs regularly.
- Test rules before production deployment.
- Use descriptive rule names and SIDs.

---

# Common Misconfigurations

### Missing Firewall Route

Traffic bypasses inspection.

---

### Incorrect Firewall Policy

Expected traffic may be dropped.

---

### Missing Endpoint Association

Traffic cannot reach the firewall.

---

### Incorrect Transit Gateway Routes

Inspection path fails.

---

# Screenshot Placeholders

## Figure 1 – Firewall Overview

> Insert Firewall overview screenshot.

---

## Figure 2 – Firewall Policy

> Insert Firewall Policy screenshot.

---

## Figure 3 – Stateful Rule Group

> Insert Stateful Rule Group screenshot.

---

## Figure 4 – Stateless Rule Group

> Insert Stateless Rule Group screenshot.

---

## Figure 5 – Firewall Endpoints

> Insert Firewall Endpoint screenshot.

---

## Figure 6 – Route Tables

> Insert Firewall Route Table screenshot.

---

## Figure 7 – Suricata Rule

> Insert Suricata rule screenshot.

---

## Figure 8 – Testing

> Insert successful ICMP blocking test.

---

# Summary

AWS Network Firewall provides centralized network security for the Hub-and-Spoke architecture by inspecting traffic before it leaves the AWS environment. Combined with AWS Transit Gateway and dedicated firewall route tables, it enables consistent security enforcement across application workloads while maintaining a scalable and highly available design.

---

# References

- AWS Network Firewall Developer Guide
- Suricata Rule Syntax Documentation
- AWS Security Best Practices

---

# Next Document

➡️ **13-Auto-Scaling.md**