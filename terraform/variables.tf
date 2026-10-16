variable "aws_region" {
  description = "AWS region for this lab."
  type        = string
  default     = "eu-central-1"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name with the required lab prefix."
  type        = string

  validation {
    condition     = can(regex("^hamid-cloud-platform-lab-[a-z0-9-]{3,30}$", var.bucket_name))
    error_message = "Bucket name must start with hamid-cloud-platform-lab- and contain only lowercase letters, numbers, and hyphens."
  }
}
