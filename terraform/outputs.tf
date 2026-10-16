output "bucket_name" {
  description = "Name of the private lab bucket."
  value       = aws_s3_bucket.lab.id
}

output "bucket_arn" {
  description = "ARN of the private lab bucket."
  value       = aws_s3_bucket.lab.arn
}
