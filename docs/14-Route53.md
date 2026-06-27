# Amazon Route 53

---

# Overview

Amazon Route 53 is the managed DNS service used to resolve the application's domain name to the Internet-facing Application Load Balancer (ALB).

In this architecture, Route 53 serves as the public entry point for client requests and integrates seamlessly with the ALB using an Alias A Record.

Route 53 provides highly available and scalable DNS resolution while allowing the underlying infrastructure to remain flexible and transparent to end users.

---

# Architecture

```
                 Client

                    │

                    ▼

             Amazon Route53

                    │

                    ▼

              Alias Record

                    │

                    ▼

         Internet-facing ALB

                    │

                    ▼

                 AWS WAF

                    │

                    ▼

             Transit Gateway

                    │

                    ▼

            Internal NLB

                    │

                    ▼

               EC2 Instances
```

---

# Purpose

Amazon Route 53 is responsible for:

- Public DNS resolution
- Domain name management
- Routing users to the Application Load Balancer
- High availability
- Seamless integration with AWS resources

---

# Hosted Zone

The architecture uses a **Public Hosted Zone**.

Example

```
example.com
```

The hosted zone stores all DNS records associated with the domain.

---

# DNS Record

The application uses an **Alias A Record**.

Example

| Record Type | Value |
|-------------|-------|
| A (Alias) | Internet-facing ALB |

Unlike a traditional A record, an Alias record automatically tracks changes to the ALB's underlying IP addresses.

---

# Why Alias Records?

AWS recommends Alias records for AWS resources because they provide:

- No hardcoded IP addresses
- Automatic updates
- Native AWS integration
- No additional DNS query charges for Alias lookups to supported AWS resources

---

# Request Flow

When a user accesses the application:

1. The client requests the application domain.
2. DNS resolution is performed by Amazon Route 53.
3. Route 53 returns the ALB Alias Record.
4. The client connects to the Internet-facing ALB.
5. AWS WAF evaluates the request.
6. The ALB forwards traffic through the Transit Gateway to the Internal NLB.
7. The Internal NLB distributes traffic to a healthy EC2 instance.

---

# DNS Resolution Process

```
Browser

↓

DNS Query

↓

Amazon Route53

↓

Alias Record

↓

Application Load Balancer

↓

Web Application
```

The client never communicates directly with the EC2 instances.

---

# Integration with ALB

The Alias record points directly to the Internet-facing ALB.

Benefits include:

- Automatic endpoint updates
- Simplified configuration
- High availability
- Native AWS support

No manual DNS updates are required if the ALB changes its underlying IP addresses.

---

# High Availability

Amazon Route 53 is a globally distributed managed service.

Benefits include:

- Highly available DNS infrastructure
- Low-latency DNS responses
- Fault tolerance
- Automatic scaling

This complements the Multi-AZ deployment of the ALB and backend resources.

---

# Security Considerations

While Route 53 provides DNS resolution, security is enforced by downstream services.

Security layers include:

- AWS WAF
- Security Groups
- AWS Network Firewall
- Private Subnets

Route 53 itself does not inspect application traffic.

---

# Routing Policy

This project uses the standard Alias routing configuration.

Other supported routing policies include:

- Simple Routing
- Weighted Routing
- Latency-Based Routing
- Failover Routing
- Geolocation Routing
- Geoproximity Routing
- Multi-Value Answer Routing

For this implementation, a Simple Alias record is sufficient because only one Internet-facing ALB is used.

---

# Monitoring

Amazon Route 53 can be monitored using:

- Route 53 Health Checks
- CloudWatch Metrics
- Resolver Query Logs

Typical monitoring includes:

- DNS query volume
- Health check status
- Resolution failures

---

# Best Practices

- Use Alias records for AWS resources.
- Keep DNS records simple and descriptive.
- Enable Route 53 Health Checks for critical endpoints.
- Use short TTL values when frequent endpoint changes are expected.
- Protect public applications with AWS WAF.
- Use meaningful hosted zone documentation.

---

# Common Issues

### DNS Does Not Resolve

Possible causes:

- Incorrect Hosted Zone
- Missing Alias Record
- Domain not delegated to Route 53 name servers

---

### Incorrect ALB Target

Possible causes:

- Alias record points to the wrong ALB
- ALB deleted or recreated without updating DNS

---

### Application Unreachable

Possible causes:

- ALB listener misconfiguration
- WAF blocking requests
- Backend target health failures

---

# Screenshot Placeholders

## Figure 1 – Hosted Zone

> Insert Hosted Zone overview screenshot.

---

## Figure 2 – Alias Record

> Insert DNS record screenshot.

---

## Figure 3 – Record Details

> Insert Alias Record configuration.

---

## Figure 4 – Route 53 Console

> Insert Route 53 overview.

---

## Figure 5 – Browser Test

> Insert successful browser access using the custom domain.

---

# Summary

Amazon Route 53 provides the public DNS layer for the Hub-and-Spoke architecture by resolving the application domain to the Internet-facing Application Load Balancer. Through the use of Alias records, Route 53 offers a highly available and fully managed DNS solution that integrates seamlessly with AWS resources while supporting the architecture's centralized ingress model.

---

# References

- Amazon Route 53 Developer Guide
- Route 53 Best Practices
- Elastic Load Balancing Documentation

---

# Next Document

➡️ **15-Traffic-Flow.md**