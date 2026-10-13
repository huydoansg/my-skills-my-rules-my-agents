# ARCHITECTURE DOCUMENTATION & MERMAID DIAGRAM STANDARDS

Architecture documentation must be concise, punchy, and diagram-driven. Long-winded prose is discouraged.

## 1. THE 4 MANDATORY ARCHITECTURE VIEWS

Every system design document must include the following 4 views rendered with standard **Mermaid** syntax:

### 1. Static View (C4 Model - System Context & Containers)
- Purpose: Show external actors, third-party integrations, and core software containers.
- Mermaid Type: `graph TD` or `flowchart TD`

```mermaid
flowchart TD
    User([End User]) -->|HTTPS / Port 443| Cloudflare[Cloudflare CDN & WAF]
    Cloudflare -->|Route traffic| Ingress[Kubernetes Ingress Controller]
    
    subgraph VPC [Private AWS VPC]
        subgraph K8s [EKS Cluster]
            Ingress --> Gateway[API Gateway Service]
            Gateway --> CoreApp[Core Backend Service]
            Gateway --> AuthSvc[Auth Service]
        end
        
        subgraph Storage [Managed Persistence Tier]
            CoreApp --> Postgres[(AWS Aurora PostgreSQL)]
            CoreApp --> Redis[(ElastiCache Redis)]
        end
    end
```

### 2. Dynamic View (Sequence Diagram - Business Flow & Failure Paths)
- Purpose: Show step-by-step communication across services, including error and timeout paths.
- Mermaid Type: `sequenceDiagram`

```mermaid
sequenceDiagram
    autonumber
    actor Client
    participant API as API Gateway
    participant Order as Order Service
    participant Pay as Payment Gateway
    participant DB as Database

    Client->>API: POST /api/v1/orders (Idempotency-Key: id-123)
    API->>Order: Validate & Forward
    Order->>DB: Begin Tx (Insert Order Status: PENDING)
    Order->>Pay: Process Charge
    alt Payment Succeeded
        Pay-->>Order: 200 OK (TransactionID)
        Order->>DB: Update Status: CONFIRMED & Commit Tx
        Order-->>Client: 201 Created (Order Details)
    else Payment Timeout / 5xx
        Pay-->>Order: 504 Gateway Timeout
        Order->>DB: Rollback Tx & Log Failure
        Order-->>Client: 502 Bad Gateway (Retryable)
    end
```

### 3. Integration View (Async Events & Message Queues)
- Purpose: Show pub/sub topologies, event brokers, dead-letter queues, and consumers.
- Mermaid Type: `flowchart LR`

```mermaid
flowchart LR
    OrderService[Order Service] -->|Write Outbox Table| DB[(PostgreSQL)]
    DB -->|Debezium CDC Poller| KafkaTopic[(Kafka: orders.v1)]
    KafkaTopic -->|At-least-once| InventoryConsumer[Inventory Consumer]
    KafkaTopic -->|At-least-once| EmailConsumer[Email Notification Consumer]
    InventoryConsumer -->|Retry 3x Fail| DLQ[(Dead Letter Queue)]
    DLQ --> AlertingSystem[PagerDuty / Ops Alert]
```

### 4. Deployment & Infrastructure View
- Purpose: Show network subnets, multi-availability zones, container pods, and CI/CD promotion.
- Mermaid Type: `graph TB`

```mermaid
graph TB
    subgraph Region [AWS us-east-1]
        subgraph AZ1 [Availability Zone A]
            Node1[Worker Node 1 - Pod A]
            DBPrimary[(Aurora Primary)]
        end
        subgraph AZ2 [Availability Zone B]
            Node2[Worker Node 2 - Pod B]
            DBReplica[(Aurora Read Replica)]
        end
    end
    ALB[Application Load Balancer] --> Node1 & Node2
    DBPrimary -.->|Sync Replication| DBReplica
```

---

## 2. MERMAID SYNTAX RULES FOR AGENTS
1. Quote all node labels containing special characters, brackets, or parentheses: `node["Label (v1.2)"]`.
2. Do not use raw HTML tags inside node text.
3. Keep diagrams legible: decompose into subgraphs when exceeding 10 components.
