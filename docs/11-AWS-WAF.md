# AWS Web Application Firewall (WAF)

---

# Overview

AWS Web Application Firewall (AWS WAF) is the first security layer protecting the web application from malicious HTTP and HTTPS requests.

In this architecture, AWS WAF is associated with the Internet-facing Application Load Balancer deployed inside the Hub VPC.

Every incoming request is evaluated against the configured Web ACL before it reaches the Application Load Balancer.

This provides centralized protection for all application workloads hosted inside the Spoke VPC.

---

# Architecture

```
                 Internet

                      │

                 Amazon Route53

                      │

                 AWS WAF Web ACL

                      │

         Internet-facing Application
             Load Balancer (ALB)

                      │

            Transit Gateway Routing

                      │

            Internal Network Load Balancer

                      │

                  EC2 Instances
```

---

# Why AWS WAF?

The objective of AWS WAF is to inspect HTTP requests before they reach the application.

Benefits include:

- Centralized web protection
- Layer 7 filtering
- Geo blocking
- Rate limiting
- Custom responses
- Protection against common web attacks
- Managed AWS service

---

# Deployment

AWS WAF is deployed as a Web ACL.

Resource Association:

```
Internet-facing ALB
```

The Web ACL evaluates every incoming request before forwarding traffic.

---

# Web ACL Components

The Web ACL consists of one or more rules.

Typical rule order:

```
Geo Match Rule

↓

Rate-Based Rule

↓

Default Action
```

AWS evaluates rules in priority order.

The first matching rule determines the final action.

---

# Rule 1 – Geo Match

Purpose

Restrict access based on the client's country.

Example:

```
Allow

Egypt

Saudi Arabia

United Arab Emirates
```

or

```
Block

Specified Countries
```

Use Cases

- Regional applications
- Compliance
- Attack reduction
- Fraud prevention

---

# Rule 2 – Rate-Based Rule

Purpose

Protect against excessive requests from a single IP address.

Example

```
100 Requests

Per 5 Minutes

Per Source IP
```

If the threshold is exceeded:

```
Block Request
```

Benefits

- Mitigates Layer 7 DoS attacks
- Prevents abuse
- Reduces unnecessary backend load

---

# Custom Response

Instead of the default AWS WAF response, a custom HTTP response can be returned.

Example

```
HTTP Status

503

Service Temporarily Unavailable
```

Custom responses improve the user experience and provide consistent application behavior.

---

# Default Action

If a request does not match any blocking rule:

```
Allow
```

The request proceeds to the Application Load Balancer.

---

# Request Evaluation Flow

```
Client Request

↓

Route53

↓

AWS WAF

↓

Evaluate Rule 1

↓

Evaluate Rule 2

↓

Allowed?

↓

YES

↓

Application Load Balancer

↓

Transit Gateway

↓

Internal NLB

↓

EC2
```

Blocked requests never reach the Application Load Balancer.

---

# Rule Priority

Example:

| Priority | Rule | Action |
|-----------|------|--------|
| 1 | Geo Match | Block |
| 2 | Rate Limit | Block |
| Default | Allow | Allow |

AWS evaluates rules from the lowest priority number to the highest.

---

# Security Benefits

AWS WAF provides:

- Layer 7 protection
- Reduced attack surface
- Centralized security
- Lower backend utilization
- Improved application resilience

---

# Logging

AWS WAF logs can be sent to:

- Amazon CloudWatch Logs
- Amazon S3
- Amazon Kinesis Data Firehose

Typical logged information includes:

- Source IP
- Country
- Matched Rule
- HTTP Method
- URI
- Timestamp
- Action (Allow/Block)

---

# Monitoring

Useful CloudWatch Metrics

- AllowedRequests
- BlockedRequests
- CountedRequests
- PassedRequests

Monitoring these metrics helps identify attack patterns and validate rule effectiveness.

---

# Testing

## Test 1 – Normal Request

Expected Result

```
Allowed
```

The application loads successfully.

---

## Test 2 – Geo Block

Expected Result

```
Blocked
```

AWS WAF returns the configured custom response.

---

## Test 3 – Rate Limit

Generate repeated requests from a single IP.

Expected Result

```
Blocked

HTTP 503
```

---

# Best Practices

- Place AWS WAF in front of Internet-facing ALBs.
- Use least-privilege rule design.
- Review logs regularly.
- Tune rate limits based on application behavior.
- Test rules in Count mode before enforcing them.
- Combine custom rules with AWS Managed Rule Groups where appropriate.

---

# Future Enhancements

The following AWS WAF features can further improve security:

- AWS Managed Rule Groups
- Bot Control
- CAPTCHA
- Challenge Actions
- IP Reputation Lists
- Anonymous IP Lists
- SQL Injection Protection
- Cross-Site Scripting (XSS) Protection

---

# Screenshot Placeholders

## Figure 1 – Web ACL

> Insert Web ACL overview.

---

## Figure 2 – Resource Association

> Insert ALB association screenshot.

---

## Figure 3 – Geo Match Rule

> Insert Geo Match Rule screenshot.

---

## Figure 4 – Rate-Based Rule

> Insert Rate-Based Rule screenshot.

---

## Figure 5 – Custom Response

> Insert Custom Response configuration.

---

## Figure 6 – Monitoring

> Insert CloudWatch metrics screenshot.

---

# Summary

AWS WAF serves as the first layer of defense in the Hub-and-Spoke architecture. By inspecting every incoming HTTP request before it reaches the Application Load Balancer, the Web ACL helps protect backend workloads from malicious traffic, excessive requests, and unwanted geographic sources. The use of centralized WAF policies simplifies security management while improving the overall resilience of the application.

---

# References

- AWS WAF Developer Guide
- AWS WAF Best Practices
- AWS Security Best Practices

---

# Next Document

➡️ **12-AWS-Network-Firewall.md**