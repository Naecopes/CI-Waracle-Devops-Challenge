variable "bucket_name" {
  description = "The name of the S3 bucket to host the static website"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the CloudFront distribution"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ACM Certificate ARN for enabling HTTPS on CloudFront"
  type        = string
}