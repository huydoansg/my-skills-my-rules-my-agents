# KUBERNETES (K8S) CLOUD-NATIVE CONVENTIONS

## 1. RESOURCE MANAGEMENT & SCHEDULING
- **Mandatory Requests and Limits**:
  - Every container must declare both `resources.requests` and `resources.limits` for CPU and Memory.
  - Set Memory requests equal to limits (`requests.memory == limits.memory`) to achieve Guaranteed QoS and prevent abrupt Out-Of-Memory (OOM) eviction.
  - Never set unbounded CPU limits to prevent CPU throttling loops.
- **Horizontal Pod Autoscaler (HPA)**:
  - Deploy an HPA for every public-facing deployment.
  - Base autoscaling on CPU/Memory utilization (e.g., target 70%) or custom Prometheus metrics (e.g., HTTP request rate).

```yaml
resources:
  requests:
    cpu: "250m"
    memory: "512Mi"
  limits:
    cpu: "1000m"
    memory: "512Mi"
```

## 2. HEALTH PROBES & ZERO-DOWNTIME LIFECYCLE
- **Three Separate Probes**:
  - `startupProbe`: Allows slow-starting containers to bootstrap without being prematurely terminated by liveness probes.
  - `livenessProbe`: Verifies whether the process is alive. Do not check external dependencies (DB/Redis) here; if a DB goes down, killing the app container won't help.
  - `readinessProbe`: Verifies whether the container is ready to accept user traffic. Remove container from Service endpoint when downstream DB/cache is unreachable.
- **Pod Disruption Budgets (PDB)**: Configure PDBs (`minAvailable: 1` or `maxUnavailable: 25%`) on all multi-replica workloads to guarantee availability during cluster upgrades.

## 3. POD SECURITY STANDARDS (PSS)
- **Restricted Security Context**:
  - All workloads must run under the `restricted` Pod Security Standard.
  - `runAsNonRoot: true`
  - `readOnlyRootFilesystem: true` (use `emptyDir` mounts for `/tmp` or write directories).
  - `allowPrivilegeEscalation: false`
  - `capabilities.drop: ["ALL"]`

```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 10001
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
```

## 4. NETWORK POLICIES & TRAFFIC SEGMENTATION
- **Default Deny All**: Every namespace must define a default-deny Ingress and Egress `NetworkPolicy`.
- **Explicit Ingress Whitelisting**: Explicitly allow ingress traffic only from the Ingress Controller or authorized upstream services on specified ports.
