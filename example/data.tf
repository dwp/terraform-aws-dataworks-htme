data "aws_sqs_queue" "scheduler_sqs" {
  name = aws_sqs_queue.export_state_fifo.name
}

data "aws_sqs_queue" "corporate_storage_export_sqs" {
  name = aws_sqs_queue.corporate_storage_export.name
}

data "local_file" "logging_script" {
  filename = "files/shared/logging.sh"
}

data "local_file" "htme_default_topics_ris_csv" {
  filename = "files/htme/htme_default_topics_ris/htme_default_topics_ris_development.csv"
}
