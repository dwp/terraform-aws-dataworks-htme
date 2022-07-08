output "htme_default_topics_csv" {
  value = {
    full                       = aws_s3_bucket_object.htme_default_topics_full_csv
    incrementals               = aws_s3_bucket_object.htme_default_topics_incrementals_csv
    drift_testing_incrementals = aws_s3_bucket_object.htme_default_topics_drift_testing_incrementals_csv
    ris                        = aws_s3_bucket_object.htme_default_topics_ris_csv
  }
}