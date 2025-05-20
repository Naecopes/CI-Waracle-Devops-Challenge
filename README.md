# Static Site Infrastructure Deployment (AWS + Terragrunt + GitHub Actions)

This repository defines IaC to deploy a single-page static website on AWS using:

- **S3** for hosting
- **CloudFront** as CDN
- **ACM** for HTTPS
- **Terragrunt** to manage and orchestrate Terraform modules
- **GitHub Actions** for CI/CD with manual approval gates

---

## TO-DO

- **Deployment Role and Environment Accounts** - Create IAM roles following the concept of least priviledge and deploy to the relevant environments
- **Full Branching and Deployment strategy** - As this is a PoC and not much time has been alloted to it if this application needed to scale further there would be discussions around what would fit bet for this client, a basic branching strategy with manual approval gates for Terragrunt with deploy on merge to dev, staging or prod has been implemented
- **Tests** - Testing strategy (security, static analysis etc) would also need to be discussed, especially if this application was to grow in scale and expand beyond a SPA or implement further infrastructure such as a DB backend or other functionality
- **Monitoring, Observability and Logging** - Again, depending on scale and use case for this application. DNS endpoint monitoring may be sufficient for something like this that has very minimal traffic and does not need to scale.
- **Cost Management and Tagging Strategy** - Similar to other considerations, this would be part of the conversation if an application is going to cost and scale. In this case it should be light weight and would not be an extended conversation. 

## 🧩 Stack

| Component     | Tool/Service              |
|---------------|---------------------------|
| IaC           | Terraform + Terragrunt    |
| Cloud         | AWS (S3 + CloudFront + ACM) |
| CI/CD         | GitHub Actions            |
| Approval Flow | GitHub CODEOWNERS + Manual Gate |
| State Mgmt    | S3 Backend with automatic file locking and versioning |

## 🧩 Stack Justification

1. **Terraform/Terragrunt** — Terraform is a cloud agnostic, industry standard tool and the syntax is human readable and while the infrastructure varies per provider the syntax is straightforward. Terragrunt allows for much easier management of multiple environments due to it being an abstraction layer
2. **Cloud Infrastructure** — Any cloud provider can provide this functionality however I used AWS due to this being a very common, well documented and quick to implement configuration for this use case. It is fronted by Cloudfront and ACM for possible future scalability along with security (redirecting 80 to 443 as an example)
3. **CI/CD and Approval Flow** — This is expanded upon later in the Readme and there are many different ways to do this however even just from a personal standpoint what I have found to be efficient and have the least issues is an environment promotion model.

---

## 🚀 Deployment Workflow (Local environment)

# Terraform variable values
```
TF_VAR_bucket_name=insert-bucket-name-here
TF_VAR_domain_name=insert-domain-name-here
TF_VAR_acm_certificate_arn=arn:aws:acm:...
```
# Optional override backend config 
```
TF_STATE_BUCKET=insert-bucket-name-here
TF_STATE_REGION=insert-region-here
```
# Initialise and plan Terragrunt
```
cd infrastructure/modules/static_site
terragrunt init
terragrunt plan \
  -var="bucket_name=my-site-bucket" \
  -var="domain_name=mydomain.com" \
  -var="acm_certificate_arn=arn:aws:acm:..."
```
# Apply Terragrunt:
```
cd infrastructure/modules/static_site
terragrunt apply
```

## 🚀 Deployment Workflow (CI/CD)

### ✅ Triggered only on **merge** into:
- `dev`
- `staging`
- `main`

### ✅ Pipeline Stages:
1. **Terragrunt Plan** — Runs a dry-run to preview changes
2. **Manual Approval** — Enforced via Github group 
3. **Terragrunt Apply** — Infrastructure applied automatically (if approved)

### ✅ Security:
- All env-specific values (e.g., `bucket_name`, `domain_name`) are injected securely via **GitHub Secrets**.
- Manual approval is required before applying any infrastructure changes.

---

## 🪄 Branching Strategy Options

### 🔁 Option A: Environment-Promotion Model (Recommended)

dev -> staging -> main

1. **Dev** — Deploy to a sandbox or development environment, run tests upon completed infrastructure and once approved merge into staging
2. **Staging** — Merge completed dev deployment branch into staging with environment specific vars injected at runtime 
3. **Main** — Merge staging branch into main

Pros: Clear separation, easy to promote validated infrastructure
Cons: Slightly more merge overhead

### 🔁 Option B: Single Branch with Tags 

Use tags like v1.0.0-dev, v1.0.0-staging, v1.0.0-prod to promote through environments

Environment controlled in the pipeline via tag pattern

Pros: Simple branching
Cons: CI becomes more complex, no branch history per env