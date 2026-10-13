# AWS CLOUD ARCHITECTURE & ENGINEERING CONVENTIONS

## 1. ARCHITECTURE & FOUNDATIONS
- **AWS Well-Architected Framework**: Every cloud workload must align with the 6 pillars (Operational Excellence, Security, Reliability, Performance Efficiency, Cost Optimization, Sustainability).
- **Infrastructure as Code (IaC)**: Never configure resources manually in the AWS Console. Use AWS CDK (TypeScript/Python) or Terraform/OpenTofu with remote state locking (S3 + DynamoDB).
- **Multi-AZ by Default**: All production databases (RDS/Aurora) and compute tiers (ECS/EKS/ALB) must span at least 2 Availability Zones.

## 2. SECURITY & IAM
- **Least Privilege Access**: Never use wildcard `*` actions in IAM policies (e.g., avoid `"Action": "s3:*"`). Scope strictly to exact resource ARNs and required verbs.
- **Role-based Authentication**: Use AWS IAM Roles, OIDC (for GitHub Actions / CI/CD), and AWS IAM Identity Center. Never create long-lived IAM User access keys.
- **Zero Public Access to Data Tiers**:
  - S3 buckets must have **Block Public Access** enabled and enforce TLS 1.2+ via bucket policies.
  - Databases and Redis clusters must reside in **Private Isolated Subnets** with zero Internet Gateway routes.
- **KMS Encryption**: All data stores (S3, EBS, RDS, SQS, Secrets Manager) must be encrypted at rest using customer-managed KMS keys or default AWS KMS keys.

## 3. COMPUTE & SERVERLESS
- **Lambda Best Practices**:
  - Keep deployment packages small; utilize Lambda Layers for common runtimes.
  - Implement idempotent handlers. Configure Dead-Letter Queues (DLQ) or EventBridge failure destinations.
  - Set reserved and provisioned concurrency deliberately to prevent database connection exhaustion.
- **Container Workloads (ECS / EKS)**:
  - Prefer AWS Fargate for stateless compute to minimize OS patch overhead.
  - Always define CPU and memory limits. Use Application Load Balancer with dynamic host port mapping.

## 4. PERSISTENCE & MESSAGING
- **RDS & Aurora PostgreSQL**:
  - Enable Automated Backups (minimum 7-day retention) and Deletion Protection for production.
  - Utilize **AWS RDS Proxy** to manage and pool connections from serverless or scaling container workloads.
  - Turn on **Performance Insights** for database bottleneck diagnosis.
- **SQS & SNS**:
  - Use FIFO queues when message ordering and strict deduplication are required.
  - Configure Redrive Policy to route messages to a Dead-Letter Queue (DLQ) after 3-5 failed processing attempts.

## 5. OBSERVABILITY & FINOPS
- **CloudWatch & OpenTelemetry**:
  - Set retention policies on CloudWatch Log Groups (e.g., 30 or 90 days); never retain logs indefinitely.
  - Configure CloudWatch Alarms for ALB 5XX rate, RDS CPU/Storage saturation, and Lambda error spikes.
- **FinOps & Cost Control**:
  - Enforce mandatory tagging: `Environment` (prod/stage/dev), `Project`, `Owner`, `CostCenter`.
  - Use AWS Compute Savings Plans or Reserved Instances for predictable baseline workloads.
