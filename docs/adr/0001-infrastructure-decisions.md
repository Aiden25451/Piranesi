# 1. Infrastructure architecture decisions

Date: 2026-06-30

## Status

Accepted

## Context

The Piranesi project needed a production AWS setup serving two workloads: a Hono API (Lambda) and a Next.js resume app (Docker container). The original codebase had a single flat Terraform directory with mixed IAM and infrastructure resources, an EC2-based container deployment, ad hoc naming, and no clear separation between admin-only and CI/CD operations.

## Decisions

### 1. Two-stage Terraform

Split into `terraform/bootstrap/` (run locally by admin) and `terraform/infra/` (run by CI/CD via OIDC). Bootstrap creates the GitHub OIDC provider and IAM role that infra deployments assume. Each stage has its own backend: a dedicated bucket for bootstrap, the original bucket with a different key for infra.

### 2. Resource naming

All AWS resources follow `piranesi-{env}-{component}` (e.g. `piranesi-prod-lambda`, `piranesi-prod-gateway`). Environment defaults to `prod`.

### 3. ECS Fargate over EC2

Replaced the EC2 instance with ECS Fargate (256 CPU / 512 MB). Removes OS management, reduces idle cost to ~$3-4/month, and lets the Docker image be referenced directly in the task definition.

### 4. API Gateway routing

Single HTTP API with `$default` → Lambda (Hono) and `ANY /resume/{proxy+}` → Fargate via HTTP_PROXY. The resume integration URL uses a variable placeholder until automated IP discovery is wired up.

### 5. GitHub Actions OIDC

No static AWS keys. The bootstrap stage creates an IAM OIDC provider and a role scoped to `repo:aasprakis/Piranesi:*`. The workflow assumes this role per-job via `configure-aws-credentials`.

### 6. State storage

| Stage | Bucket | Key |
|---|---|---|
| Bootstrap | `piranesi-terraform-state-bootstrap` | `terraform.tfstate` |
| Infra | `piranesi-terraform-state` | `infra/terraform.tfstate` |

## Consequences

- Admin credentials are only needed for the initial bootstrap; day-to-day runs use short-lived OIDC tokens.
- The Fargate task's public IP must be propagated to the API Gateway integration (future automation).
- Both S3 buckets must exist before their respective `terraform init` commands.
- Resource names are longer but self-documenting.
