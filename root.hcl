terraform {
   required_version = ">=1.12.0"
   source = "./infrastructure/modules/static_site"
}

locals {
  region = "eu-west-2"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "ci-waracle-devops-challenge"
    key            = "terraform.tfstate"
    region         = local.region
    encrypt        = true
    use_lockfile   = true
  }
}

inputs = {
  bucket_name           = get_env("TF_VAR_bucket_name", "")
  domain_name           = get_env("TF_VAR_domain_name", "")
  acm_certificate_arn   = get_env("TF_VAR_acm_certificate_arn", "")
}