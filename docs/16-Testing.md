# Testing and Validation

---

# Overview

This document describes the validation procedures performed to verify the functionality, availability, scalability, and security of the AWS Enterprise Hub-and-Spoke Security Architecture.

Each test validates a specific architectural component to ensure the environment behaves as expected under normal and failure scenarios.

---

# Testing Objectives

The testing phase verifies:

- DNS resolution
- End-to-end application connectivity
- AWS WAF protection
- Application Load Balancer functionality
- Transit Gateway routing
- Internal Network Load Balancer functionality
- Auto Scaling integration
- AWS Network Firewall inspection
- High availability
- Health checks

---

# Test Environment

| Component | Status |
|-----------|--------|
| Route53 | Configured |
| AWS WAF | Configured |
| Internet-facing ALB | Configured |
| Transit Gateway | Configured |
| Internal NLB | Configured |
| Auto Scaling Group | Configured |
| EC2 Instances | Running |
| AWS Network Firewall | Configured |

---

# Test 1 – DNS Resolution

## Objective

Verify that the application domain resolves successfully.

---

## Procedure

```bash
nslookup example.com
```

or

```bash
dig example.com
```

---

## Expected Result

```
Domain resolves successfully.

Alias points to the Internet-facing ALB.
```

---

## Validation

- Hosted Zone configured
- Alias Record configured
- DNS resolution successful

---

## Screenshot

> Insert Route53 Hosted Zone

---

# Test 2 – Browser Access

## Objective

Verify end-to-end application connectivity.

---

## Procedure

Open:

```
http://example.com
```

---

## Expected Result

Apache webpage loads successfully.

---

## Validation

Verified:

- Route53
- AWS WAF
- ALB
- Transit Gateway
- Internal NLB
- Auto Scaling
- EC2

---

## Screenshot

> Insert browser output

---

# Test 3 – ALB Health Checks

## Objective

Verify ALB Target Group health.

---

## Procedure

Navigate to:

```
EC2

↓

Target Groups

↓

Target Health
```

---

## Expected Result

```
Healthy
```

---

## Validation

Targets successfully pass health checks.

---

## Screenshot

> Insert ALB Target Health

---

# Test 4 – NLB Target Health

## Objective

Verify Internal NLB health.

---

## Procedure

Navigate to:

```
EC2

↓

Target Groups

↓

Instance Target Group
```

---

## Expected Result

```
Healthy
```

---

## Validation

EC2 instances are automatically registered.

---

## Screenshot

> Insert NLB Target Group

---

# Test 5 – Auto Scaling Registration

## Objective

Verify ASG integration.

---

## Procedure

Launch a new instance by increasing desired capacity.

```
Desired Capacity

2

↓

3
```

---

## Expected Result

```
Instance launches.

↓

Registers automatically.

↓

Health checks pass.

↓

Receives traffic.
```

---

## Validation

No manual registration required.

---

## Screenshot

> Insert ASG Activity History

---

# Test 6 – AWS WAF Geo Match

## Objective

Verify Geo Match Rule.

---

## Procedure

Generate a request from a blocked country.

---

## Expected Result

```
Blocked

HTTP 503
```

---

## Validation

Request never reaches ALB.

---

## Screenshot

> Insert WAF Rule Match

---

# Test 7 – AWS WAF Rate Limit

## Objective

Verify Rate-Based Rule.

---

## Procedure

Generate repeated HTTP requests.

Example:

```bash
for i in {1..200}
do
curl http://example.com
done
```

---

## Expected Result

```
Blocked
```

---

## Validation

AWS WAF blocks excessive requests.

---

## Screenshot

> Insert Rate Limit Rule

---

# Test 8 – AWS Network Firewall

## Objective

Verify centralized traffic inspection.

---

## Procedure

Ping a blocked destination.

Example:

```bash
ping <destination-ip>
```

---

## Expected Result

```
Request dropped
```

---

## Validation

Suricata rule successfully blocks ICMP.

---

## Screenshot

> Insert ICMP Test

---

# Test 9 – HTTP Traffic

## Objective

Verify HTTP traffic remains allowed.

---

## Procedure

```bash
curl http://example.com
```

---

## Expected Result

```
HTTP 200 OK
```

---

## Validation

Firewall policy permits HTTP.

---

## Screenshot

> Insert HTTP Test

---

# Test 10 – Transit Gateway Connectivity

## Objective

Verify routing between Hub and Spoke VPCs.

---

## Procedure

Review:

- VPC Route Tables
- Transit Gateway Route Tables
- Attachments
- Associations

---

## Expected Result

Traffic successfully traverses TGW.

---

## Validation

Hub communicates with Spoke.

---

## Screenshot

> Insert TGW Route Table

---

# Test 11 – High Availability

## Objective

Verify application remains available after instance failure.

---

## Procedure

Terminate one EC2 instance.

---

## Expected Result

```
ASG launches replacement.

↓

NLB routes traffic.

↓

Application remains online.
```

---

## Validation

No downtime observed.

---

## Screenshot

> Insert ASG Replacement

---

# Test 12 – End-to-End Validation

## Verify Complete Request Flow

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

Target Group

↓

Auto Scaling

↓

EC2
```

---

## Expected Result

```
Application loads successfully.

All security controls enforced.
```

---

# Test Summary

| Test | Expected Result | Status |
|-------|-----------------|--------|
| DNS Resolution | Pass | ✅ |
| Browser Access | Pass | ✅ |
| ALB Health | Healthy | ✅ |
| NLB Health | Healthy | ✅ |
| Auto Scaling | Registered | ✅ |
| Geo Match | Blocked | ✅ |
| Rate Limit | Blocked | ✅ |
| Firewall | ICMP Blocked | ✅ |
| HTTP | Allowed | ✅ |
| TGW Routing | Pass | ✅ |
| High Availability | Pass | ✅ |

---

# Lessons Learned

The testing phase confirmed:

- Route53 correctly resolves the application.
- AWS WAF blocks malicious requests before reaching the ALB.
- The ALB forwards traffic to the Internal NLB using an IP Target Group.
- Transit Gateway provides reliable inter-VPC routing.
- The Internal NLB distributes traffic across healthy EC2 instances.
- Auto Scaling automatically registers new instances with the Target Group.
- AWS Network Firewall enforces centralized outbound inspection.
- The architecture remains available during instance failures.

---

# Best Practices

- Validate health checks after every deployment.
- Test WAF rules before production.
- Monitor Auto Scaling activity.
- Review TGW route tables after changes.
- Confirm firewall routing after updates.
- Document all validation results.

---

# Screenshot Checklist

- Route53 Hosted Zone
- Browser Test
- ALB Target Health
- NLB Target Health
- Auto Scaling Activity
- WAF Geo Match
- WAF Rate Limit
- Firewall Policy
- ICMP Drop Test
- Transit Gateway Route Table
- EC2 Replacement

---

# Conclusion

All functional, networking, and security tests completed successfully. The architecture demonstrated centralized ingress, secure routing, automatic scaling, firewall enforcement, and high availability. These validation results confirm that the Hub-and-Spoke implementation operates as designed and aligns with AWS networking and security best practices.

---

# References

- AWS Well-Architected Framework
- AWS WAF Developer Guide
- AWS Network Firewall Documentation
- AWS Transit Gateway Documentation

---

# Next Document

➡️ **17-Troubleshooting.md**