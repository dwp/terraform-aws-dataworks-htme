data "local_file" "htme_wrapper_script" {
  filename = "files/htme/htme_wrapper.sh"
}

data "local_file" "htme_logrotate_script" {
  filename = "files/htme/htme.logrotate"
}

data "local_file" "htme_shell_script" {
  filename = "files/htme/htme.sh"
}

data "local_file" "htme_cloudwatch_script" {
  filename = "files/htme/htme_cloudwatch.sh"
}

data "local_file" "htme_default_topics_full_csv" {
  filename = "files/htme/htme_default_topics_full.csv"
}

data "local_file" "htme_default_topics_incrementals_csv" {
  filename = "files/htme/htme_default_topics_incrementals.csv"
}

data "local_file" "htme_default_topics_drift_testing_incrementals_csv" {
  filename = "files/htme/htme_default_topics_drift_testing_incrementals.csv"
}

data "local_file" "htme_default_topics_ris_csv" {
  filename = "files/htme/htme_default_topics_ris/${var.htme_default_topics_ris_file_name}"
}

data "local_file" "wrapper_checker_script" {
  filename = "files/htme/wrapper_checker.sh"
}

resource "aws_s3_bucket_object" "htme_wrapper_script" {
  bucket     = var.s3_config_bucket_id
  key        = "component/htme/htme_wrapper.sh"
  content    = data.local_file.htme_wrapper_script.content
  kms_key_id = var.config_bucket_cmk_arn
}

resource "aws_s3_bucket_object" "htme_logrotate_script" {
  bucket     = var.s3_config_bucket_id
  key        = "component/htme/htme.logrotate"
  content    = data.local_file.htme_logrotate_script.content
  kms_key_id = var.config_bucket_cmk_arn
}

resource "aws_s3_bucket_object" "htme_shell_script" {
  bucket     = var.s3_config_bucket_id
  key        = "component/htme/htme.sh"
  content    = data.local_file.htme_shell_script.content
  kms_key_id = var.config_bucket_cmk_arn
}

resource "aws_s3_bucket_object" "htme_cloudwatch_script" {
  bucket     = var.s3_config_bucket_id
  key        = "component/htme/htme_cloudwatch.sh"
  content    = data.local_file.htme_cloudwatch_script.content
  kms_key_id = var.config_bucket_cmk_arn
}

resource "aws_s3_bucket_object" "htme_default_topics_full_csv" {
  bucket     = var.s3_config_bucket_id
  key        = "component/htme/htme_default_topics_full.csv"
  content    = data.local_file.htme_default_topics_full_csv.content
  kms_key_id = var.config_bucket_cmk_arn
}

resource "aws_s3_bucket_object" "htme_default_topics_incrementals_csv" {
  bucket     = var.s3_config_bucket_id
  key        = "component/htme/htme_default_topics_incrementals.csv"
  content    = data.local_file.htme_default_topics_incrementals_csv.content
  kms_key_id = var.config_bucket_cmk_arn
}

resource "aws_s3_bucket_object" "htme_default_topics_drift_testing_incrementals_csv" {
  bucket     = var.s3_config_bucket_id
  key        = "component/htme/htme_default_topics_drift_testing_incrementals_csv.csv"
  content    = data.local_file.htme_default_topics_drift_testing_incrementals_csv.content
  kms_key_id = var.config_bucket_cmk_arn
}

resource "aws_s3_bucket_object" "htme_default_topics_ris_csv" {
  bucket     = var.s3_config_bucket_id
  key        = "component/htme/htme_default_topics_ris.csv"
  content    = data.local_file.htme_default_topics_ris_csv.content
  kms_key_id = var.config_bucket_cmk_arn
}

resource "aws_s3_bucket_object" "wrapper_checker_script" {
  bucket     = var.s3_config_bucket_id
  key        = "component/htme/wrapper_checker.sh"
  content    = data.local_file.wrapper_checker_script.content
  kms_key_id = var.config_bucket_cmk_arn
}

