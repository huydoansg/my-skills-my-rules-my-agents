---
name: k8s-gitops-deployer
description: >-
  Kubernetes manifest generation and GitOps pipeline management. Activates when creating
  or modifying Kubernetes Deployments, Services, Ingresses, Kustomize overlays, Helm charts,
  or ArgoCD / Flux application manifests.
---

# KUBERNETES & GITOPS DEPLOYMENT WORKFLOW

Activate this skill when authoring container manifests or GitOps continuous deployment pipelines.

## PROTOCOL

1. **Production-Ready Manifest Generation**:
   - Every Deployment must include:
     - `resources.requests` and `resources.limits` (Guaranteed memory QoS).
     - `readinessProbe` and `livenessProbe` with calibrated `initialDelaySeconds` and `failureThreshold`.
     - `securityContext`: `runAsNonRoot: true`, `readOnlyRootFilesystem: true`, `capabilities.drop: ["ALL"]`.
   - Pod Disruption Budget (`PodDisruptionBudget`) with `minAvailable: 1` or `maxUnavailable: 25%`.
   - Horizontal Pod Autoscaler (`HorizontalPodAutoscaler`) targeting 70% average CPU/Memory.

2. **Kustomize Base & Overlays Structure**:
   - Organize directories into `base/` and `overlays/{dev, staging, production}/`.
   - Keep differences strictly to replicas, resource quotas, and ingress hostnames via JSON/Strategic Merge patches.

3. **GitOps Application Definition**:
   - Create declarative ArgoCD `Application` or Flux `Kustomization` CRDs.
   - Enforce automated sync with self-healing enabled (`prune: true`, `selfHeal: true`).
   - Validate that secrets use External Secrets Operator (ESO), Sealed Secrets, or SOPS.
