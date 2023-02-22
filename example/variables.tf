variable "al2_hardened_ami_id" {
  description = "The AMI ID of the latest/pinned Hardened AMI AL2 Image"
  type        = string
  default     = "ami-0160d5db0a2ec3a7d"
}

variable "htme_version" {
  description = "Hbase to Mongo export JAR release version"
  type        = string
  default     = "1.0.41"
}

variable "htme_s3_prefix" {
  type        = string
  description = "Prefix name on S3 target bucket where the HTME will export data"
  default     = "businessdata/mongo/ucdata"
}

variable "region" {
  type        = string
  description = "Region"
  default     = "eu-west-2"
}
