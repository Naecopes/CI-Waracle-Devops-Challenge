---

## ✅ File: `design.md`

```markdown
# Design Document

## Cloud Platform: AWS

AWS was chosen for its powerful static hosting capabilities via S3 and global CDN through CloudFront. It is ideal for serving SPAs with SSL and low latency.

## Components

- **S3 Bucket**: For storing and serving the SPA's static assets.
- **CloudFront**: Edge caching, HTTPS support, domain mapping.
- **ACM Certificate**: For enabling HTTPS via CloudFront.
- **Terraform + Terragrunt**: Modular, DRY infrastructure-as-code setup.
- **GitHub Actions**: CI/CD automation for validating and deploying infrastructure.

## CI/CD Flow

1. Code is pushed to `main`, `dev`, or `staging`.
2. GitHub Actions checks out the code and installs Terraform and Terragrunt.
3. Secrets are injected to pass environment-specific variables.
4. Terragrunt runs `init` and `plan`.
5. An "apply" step is simulated (can be triggered with approval gates in real scenarios).

## 🧩 Stack Justification

1. **Terraform/Terragrunt** — Terraform is a cloud agnostic, industry standard tool and the syntax is human readable and while the infrastructure varies per provider the syntax is straightforward. Terragrunt allows for much easier management of multiple environments due to it being an abstraction layer
2. **Cloud Infrastructure** — Any cloud provider can provide this functionality however I used AWS due to this being a very common, well documented and quick to implement configuration for this use case. It is fronted by Cloudfront and ACM for possible future scalability along with security (redirecting 80 to 443 as an example)
3. **CI/CD and Approval Flow** — This is expanded upon later in the Readme and there are many different ways to do this however even just from a personal standpoint what I have found to be efficient and have the least issues is an environment promotion model.