output "bucket_name" {
  description = "Name of the S3 bucket created"
  value       = aws_s3_bucket.static_site.bucket
}

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn.domain_name
}