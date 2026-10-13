---
name: aws-architect
description: >-
  AWS cloud architecture and infrastructure design workflow. Activates when designing,
  auditing, or provisioning AWS workloads using CDK, Terraform, or CloudFormation.
  Ensures Well-Architected Framework compliance, IAM least privilege, and cost optimization.
---

# AWS ARCHITECTURE & PROVISIONING WORKFLOW

Activate this skill when designing or deploying workloads onto Amazon Web Services (AWS).

## PROTOCOL

1. **Topology & Network Isolation**:
   - Establish VPC with minimum 2 Availability Zones.
   - Allocate 3 subnet tiers: Public (ALB, NAT Gateway), Private Application (EKS, ECS, Lambda), and Private Isolated (RDS, ElastiCache with no internet egress).
2. **Security & IAM Scoping**:
   - Never write wildcards in IAM policies (`"Resource": "*"` or `"Action": "*"`).
   - Use IRSA (IAM Roles for Service Accounts) in EKS or Task Execution Roles in ECS.
   - Enforce AWS KMS customer-managed keys for all persistent volumes and S3 buckets.
3. **Resilience & High Availability**:
   - RDS/Aurora must be configured with Multi-AZ automated failover.
   - Configure AWS RDS Proxy between Lambda/containers and PostgreSQL to throttle concurrent connections.
   - Utilize SQS with Redrive Policies pointing to Dead-Letter Queues (DLQs).
4. **FinOps & Cost Review**:
   - Calculate monthly estimated costs using AWS Pricing Calculator principles.
   - Validate that logs have CloudWatch expiration policies (default 30 days).
   - Recommend ARM64 (AWS Graviton) for compute instances to save 20-40% compute costs.
