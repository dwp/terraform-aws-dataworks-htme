data "local_file" "logging_script" {
  filename = "files/shared/logging.sh"
}

data "local_file" "htme_default_topics_ris_csv" {
  filename = "files/htme/htme_default_topics_ris/htme_default_topics_ris_development.csv"
}
