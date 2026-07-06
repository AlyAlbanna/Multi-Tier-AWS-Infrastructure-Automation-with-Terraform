variable "state_bucket_name" {
  description = "Name of the S3 bucket that stores Terraform state"
  type        = string
}

variable "lock_table_name" {
  description = "Name of the DynamoDB table used for state locking"
  type        = string
  default     = "terraform-locks"
}

variable "force_destroy" {
  description = "Allow the state bucket to be destroyed even if it contains objects (use with caution)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags to apply to backend resources"
  type        = map(string)
  default     = {}
}
