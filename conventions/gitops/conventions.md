# GITOPS & DECLARATIVE INFRASTRUCTURE CONVENTIONS

## 1. CORE GITOPS PRINCIPLES
- **Git is the Single Source of Truth**: The desired state of the entire cluster, infrastructure, and application configuration lives strictly in Git.
- **Automated Synchronization (ArgoCD / Flux)**: An in-cluster agent continuously compares desired state in Git with live cluster state and automatically reconciles drift.
- **Zero Manual `kubectl` Mutations**: Developers and operators are forbidden from running `kubectl apply`, `helm install`, or editing live resources directly in production clusters.

## 2. REPOSITORY & DIRECTORY LAYOUT
- Use **Kustomize** or **Helm** with the Base / Overlay pattern to avoid duplicate YAML definitions:

```text
gitops-repo/
├── apps/
│   ├── base/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── kustomization.yaml
│   └── overlays/
│       ├── dev/
│       │   ├── patches/
│       │   └── kustomization.yaml
│       ├── staging/
│       └── production/
│           ├── patches/
│           │   ├── replicas.yaml
│           │   └── resources.yaml
│           └── kustomization.yaml
└── infrastructure/
    ├── cert-manager/
    ├── ingress-nginx/
    └── monitoring/
```

## 3. SECRETS MANAGEMENT IN GITOPS
- **Never Commit Raw Secrets**: Plaintext Kubernetes `Secret` resources in Git are strictly forbidden.
- **Approved Secret Encryption Mechanisms**:
  - **Sealed Secrets**: Encrypt secrets with public key, decrypt only in-cluster via Sealed Secrets Controller.
  - **Mozilla SOPS**: Encrypt secret files using AWS KMS, GCP KMS, or age keys before committing to Git.
  - **External Secrets Operator (ESO)**: Fetch secrets dynamically from AWS Secrets Manager, HashiCorp Vault, or Google Secret Manager at runtime.

## 4. PROMOTION STRATEGY & DRIFT DETECTION
- **Environment Promotion via Pull Requests**:
  - Promoting from `dev` to `staging` to `production` must occur via Pull Requests updating image tags or overlay parameters.
  - Require branch protection, PR approvals, and CI smoke tests before merging into `main`.
- **Automated Drift Detection & Self-Healing**:
  - Configure ArgoCD `syncPolicy` with `automated: { prune: true, selfHeal: true }` to automatically revert manual tampering in the cluster.
