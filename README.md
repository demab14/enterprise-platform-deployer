# Enterprise Platform Deployer (EPD)

A multi-client, multi-environment cloud platform built on AWS EKS, demonstrating production-grade GitOps, infrastructure-as-code, and secrets management patterns.

## What this project demonstrates

This isn't a tutorial follow-along — it's a from-scratch build covering the core toolchain used by modern platform/DevOps teams:

- **Terraform** — modular, reusable IaC for VPC, EKS, ECR, and Vault infrastructure across 3 isolated client environments
- **Helm** — parameterized application packaging with per-client, per-environment values and IRSA-annotated service accounts
- **HashiCorp Vault** — HA/Raft deployment with AWS KMS auto-unseal, Kubernetes auth backend, and dynamic AWS secrets (no static credentials, anywhere)
- **IRSA (IAM Roles for Service Accounts)** — every AWS-facing workload (nodes, Vault, EBS CSI driver) authenticates via OIDC federation, not static keys
- *(In progress)* Flux CD for GitOps delivery, Trivy for container/IaC scanning, OIDC-based CI/CD

## Architecture

    terraform/
      modules/
        eks-aws/     - VPC, subnets, routing, EKS cluster, node group, OIDC provider, EBS CSI driver
        ecr/         - Container registry with lifecycle policy and scan-on-push
        vault/       - KMS auto-unseal key, IRSA trust policy, AWS secrets engine IAM policy
      environments/
        client-a/    - Production tier (2-4 nodes, full HA)
        client-b/    - Larger tenant (4-8 nodes)
        client-c/    - Staging tier (1-2 nodes)

    helm/
      platform-app/  - Reusable Helm chart: deployment, HPA, PDB, service, IRSA-annotated ServiceAccount
                       Per-client values files (client-a/b/c) with distinct sizing

    kubernetes/
      vault/         - Vault Helm values per client (HA, Raft, AWS KMS auto-unseal)
      flux/          - (planned) GitOps bootstrap manifests
      overlays/      - (planned) Kustomize overlays per environment

Each client environment gets its own VPC (non-overlapping CIDR ranges), EKS cluster, ECR repository, and Vault instance — genuinely isolated infrastructure, not shared multi-tenancy within one cluster.

## What's built and verified

- [x] **Phase 1-2**: Terraform modules for EKS, ECR — validated and applied
- [x] **Phase 3**: Helm chart with per-client values, IRSA service accounts, HPA, PDB
- [x] **Phase 3.5**: All 3 client environments wired end-to-end (VPC to EKS to ECR to remote state)
- [x] **Phase 4 (partial)**: Vault deployed HA/Raft with AWS KMS auto-unseal — genuinely initialized, unsealed, and tested with real dynamic AWS credential issuance
- [ ] Kubernetes auth role bindings for application service accounts
- [ ] Vault deployment replicated to client-b / client-c
- [ ] Flux CD GitOps bootstrap
- [ ] Trivy scanning in CI, OIDC-based pipeline

## Real infrastructure, not just validated code

Every module here has been applied to live AWS infrastructure, not just `terraform validate`d. Along the way this surfaced (and fixed) several real-world issues:

- **Missing route tables** — the original EKS module created a NAT gateway and IGW but never wired subnet routing to them, causing worker nodes to fail joining the cluster silently
- **EKS version support** — hit AWS's one-minor-version-at-a-time upgrade limit and an unsupported AMI on an aged Kubernetes version; resolved by destroying and recreating at a current supported version
- **Missing EBS CSI driver** — a fresh EKS cluster has no default working StorageClass; the legacy in-tree `gp2` provisioner is deprecated and non-functional on modern Kubernetes, requiring the CSI driver to be installed as a proper EKS add-on with its own IRSA role
- **Pod anti-affinity vs. node count** — Vault's 3-replica HA StatefulSet requires 3 separate nodes due to strict anti-affinity rules; caught and fixed via node group scaling
- **Vault Helm chart config path** — `server.ha.config` silently does nothing when Raft is enabled; the correct path is `server.ha.raft.config`, confirmed by reading the chart's actual source rather than guessing from docs

## Cost management

This project is deliberately **not** left running continuously. AWS infrastructure (EKS control plane, EC2 nodes, NAT Gateway, EBS volumes) is applied on demand for development/demo sessions and torn down via `terraform destroy` afterward. All infrastructure is fully reproducible from code — a fresh `terraform apply` rebuilds the entire stack from nothing.

## Tech stack

AWS (EKS, ECR, VPC, IAM/IRSA, KMS, EBS) - Terraform - Helm - HashiCorp Vault - Kubernetes 1.34 - (planned: Flux CD, Trivy, GitHub Actions OIDC)
