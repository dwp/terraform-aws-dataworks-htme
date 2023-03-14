data "aws_sqs_queue" "scheduler_sqs" {
  name = data.terraform_remote_state.common.outputs.export_state_fifo_sqs.name
}

data "aws_sqs_queue" "corporate_storage_export_sqs" {
  name = data.terraform_remote_state.common.outputs.corporate_storage_export_sqs.name
}

data "local_file" "logging_script" {
  filename = "files/shared/logging.sh"
}

data "local_file" "htme_default_topics_ris_csv" {
  filename = "files/htme/htme_default_topics_ris/htme_default_topics_ris_development.csv"
}

