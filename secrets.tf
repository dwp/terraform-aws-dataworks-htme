resource "aws_secretsmanager_secret" "htme_collections_ris" {
  name        = "/htme/collections/ris"
  description = "Collections list for ris processing in HTME"
  tags        = var.common_tags
}

resource "aws_secretsmanager_secret_version" "htme_collections_ris" {
  secret_id     = aws_secretsmanager_secret.htme_collections_ris.name
  secret_string = data.local_file.htme_default_topics_ris_csv.content_base64 != "" ? data.local_file.htme_default_topics_ris_csv.content_base64 : base64encode("NOT_SET")
}
