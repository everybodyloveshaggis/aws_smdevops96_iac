# aws_smdevops96_iac

IaC for running a Next.js container from ECR with a low-cost, HTTPS-by-default, secure baseline.

## Why this design

For your requirements (lowest practical cost + HTTPS endpoint + modern security baseline), this repo now uses:

- **Amazon ECR** for image storage (works with your GitHub Actions push flow).
- **AWS App Runner** to run the container with a managed HTTPS endpoint.

This avoids the extra fixed cost and operational overhead of ECS + ALB + ACM + Route53 just to get HTTPS. App Runner gives HTTPS by default and managed scaling with a very small instance size.

## Security baseline included

- ECR image tags are **immutable**.
- ECR uses **KMS encryption** with a dedicated key and key rotation.
- ECR **scan-on-push** enabled for vulnerability findings.
- ECR lifecycle policy limits image retention to reduce stale artifacts and cost.
- App Runner uses least-privilege style access to pull from private ECR via AWS-managed policy.
- Auto deployments are disabled so deployments happen when you choose an image tag and apply.

## Cost baseline included

- App Runner instance size defaults to **0.25 vCPU / 0.5 GB**.
- Autoscaling defaults to min 1 / max 2 instances.
- ECR lifecycle policy keeps only the latest 15 images.

> Note: If you need **absolute lowest idle cost**, Lambda + container image can be cheaper (scale to zero), but it usually needs app/runtime changes for Next.js behavior. This setup is optimized for simplicity + security + low operational burden.

## Files

- `main.tf` – provider, ECR, KMS, IAM, App Runner service.
- `variables.tf` – configurable values.
- `outputs.tf` – ECR URL and App Runner HTTPS URL.

## Usage

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan -out tfplan
terraform apply tfplan
```

## Deploy flow with GitHub Actions

1. Build and push image to the output `ecr_repository_url`.
2. Tag image (e.g. `release-2026-03-12`).
3. Set `image_tag` variable to that tag and run `terraform apply`.

This keeps infra state and deployed image version explicit and auditable.
