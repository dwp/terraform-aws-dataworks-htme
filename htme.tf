resource "aws_launch_template" "htme" {
  name_prefix                          = "htme_"
  image_id                             = var.image_id
  instance_type                        = var.instance_type
  vpc_security_group_ids               = [aws_security_group.htme.id]
  user_data                            = base64encode(data.template_file.htme.rendered)
  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    arn = aws_iam_instance_profile.htme.arn
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.ebs_size
      volume_type           = var.ebs_type
      delete_on_termination = true
      encrypted             = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.common_tags,
    {
      Name        = "htme",
      Persistence = "Ignore"
    },
  )

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.common_tags,
      {
        Name        = "htme",
        Application = "htme",
        Persistence = "Ignore"
      },
    )
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(
      var.common_tags,
      {
        Name        = "htme",
        Application = "htme",
      },
    )
  }
}

resource "aws_launch_template" "htme_fallback" {
  name_prefix                          = "htme_"
  image_id                             = var.image_id
  instance_type                        = var.fallback_instance_type
  vpc_security_group_ids               = [aws_security_group.htme.id]
  user_data                            = base64encode(data.template_file.htme_fallback.rendered)
  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    arn = aws_iam_instance_profile.htme.arn
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.ebs_size
      volume_type           = var.ebs_type
      delete_on_termination = true
      encrypted             = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.common_tags,
    {
      Name        = "htme",
      Persistence = "Ignore"
    },
  )

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.common_tags,
      {
        Name        = "htme",
        Application = "htme",
        Persistence = "Ignore"
      },
    )
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(
      var.common_tags,
      {
        Name        = "htme",
        Application = "htme",
      },
    )
  }
}

resource "aws_autoscaling_group" "htme" {
  name                      = var.asg_name
  min_size                  = var.asg_min
  desired_capacity          = var.asg_desired
  max_size                  = var.asg_max
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  force_delete              = true
  suspended_processes       = var.suspended_processes
  vpc_zone_identifier       = var.subnet_ids

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.htme.id
        version            = "$Latest"
      }

      override {
        instance_type     = var.instance_type
        weighted_capacity = "1"
      }

      override {
        instance_type = var.fallback_instance_type
        launch_template_specification {
          launch_template_id = aws_launch_template.htme_fallback.id
        }
        weighted_capacity = "1"
      }
    }
  }

  dynamic "tag" {
    for_each = merge(
      var.common_tags,
      { Name                 = var.instance_name,
        htme-version         = var.htme_version,
        htme-spring-profiles = var.htme_spring_profiles,
        AutoShutdown         = var.asg_autoshutdown,
        SSMEnabled           = var.asg_ssm_enabled,
        Inspector            = var.inspector,
        Persistence          = "Ignore",
      },
    )

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}

data "aws_sqs_queue" "scheduler_sqs" {
  name = var.scheduler_sqs_queue_name
}

data "aws_sqs_queue" "corporate_storage_export_sqs" {
  name = var.corporate_storage_export_sqs_queue_name
}

data "template_file" "htme" {
  template = file("htme_userdata.tpl")

  vars = {
    name                                             = var.instance_name
    acm_cert_arn                                     = aws_acm_certificate.htme.arn
    private_key_alias                                = var.environment
    truststore_aliases                               = var.host_truststore_aliases
    truststore_certs                                 = var.host_truststore_certs
    internet_proxy                                   = var.internet_proxy_dns_name
    non_proxied_endpoints                            = var.non_proxied_endpoints
    s3_artefact_bucket_id                            = var.s3_artefact_bucket_id
    htme_log_level                                   = var.htme_log_level
    dks_endpoint                                     = var.dks_endpoint
    output_batch_size_max_bytes                      = var.output_batch_size_max_bytes
    directory_output                                 = var.directory_output
    s3_bucket                                        = var.s3_compaction_bucket_id
    sqs_url                                          = data.aws_sqs_queue.scheduler_sqs.url
    sqs_incoming_url                                 = data.aws_sqs_queue.corporate_storage_export_sqs.url
    s3_manifest_folder                               = var.s3_manifest_prefix
    s3_manifest_bucket                               = var.s3_manifest_bucket_id
    hbase_master_url                                 = var.hbase_master_url
    htme_max_memory_allocation                       = var.max_memory_allocation
    htme_scan_width                                  = var.scan_width
    cwa_metrics_collection_interval                  = var.cw_agent_metrics_collection_interval
    cwa_namespace                                    = var.cw_agent_namespace
    cwa_cpu_metrics_collection_interval              = var.cw_agent_cpu_metrics_collection_interval
    cwa_disk_measurement_metrics_collection_interval = var.cw_agent_disk_measurement_metrics_collection_interval
    cwa_disk_io_metrics_collection_interval          = var.cw_agent_disk_io_metrics_collection_interval
    cwa_mem_metrics_collection_interval              = var.cw_agent_mem_metrics_collection_interval
    cwa_netstat_metrics_collection_interval          = var.cw_agent_netstat_metrics_collection_interval
    cwa_log_group_name_htme                          = aws_cloudwatch_log_group.htme.name
    cwa_log_group_name_acm                           = aws_cloudwatch_log_group.acm_cert_retriever.name
    cwa_log_group_name_application                   = aws_cloudwatch_log_group.application.name
    cwa_log_group_name_boostrapping                  = aws_cloudwatch_log_group.bootstrapping.name
    cwa_log_group_name_system                        = aws_cloudwatch_log_group.system.name
    s3_scripts_bucket                                = var.s3_config_bucket_id
    s3_script_key_htme_sh                            = aws_s3_bucket_object.htme_shell_script.id
    s3_script_key_htme_wrapper_sh                    = aws_s3_bucket_object.htme_wrapper_script.id
    s3_script_key_htme_logrotate                     = aws_s3_bucket_object.htme_logrotate_script.id
    s3_script_htme_cloudwatch_sh                     = aws_s3_bucket_object.htme_cloudwatch_script.id
    s3_script_common_logging_sh                      = var.s3_script_common_logging_sh_id
    s3_script_logging_sh                             = var.s3_script_logging_sh_id
    s3_script_wrapper_checker_sh                     = aws_s3_bucket_object.wrapper_checker_script.id
    s3_script_hash_htme_sh                           = md5(data.local_file.htme_shell_script.content)
    s3_script_hash_htme_wrapper_sh                   = md5(data.local_file.htme_wrapper_script.content)
    s3_script_hash_htme_logrotate                    = md5(data.local_file.htme_logrotate_script.content)
    s3_script_hash_htme_cloudwatch_sh                = md5(data.local_file.htme_cloudwatch_script.content)
    s3_script_hash_common_logging_sh                 = var.common_logging_sh_content_hash
    s3_script_hash_logging_sh                        = var.logging_sh_content_hash
    s3_script_hash_wrapper_checker_sh                = md5(data.local_file.wrapper_checker_script.content)
    environment_name                                 = var.environment
    htme_version                                     = var.htme_version
    htme_spring_profiles                             = var.spring_profiles
    htme_s3_socket_timeout_milliseconds              = var.s3_socket_timeout_milliseconds
    htme_scan_max_result_size                        = var.scan_max_result_size
    htme_use_block_cache                             = var.use_block_cache
    htme_use_timeline_consistency                    = var.use_timeline_consistency
    asg_name                                         = var.asg_name
    environment_name                                 = var.environment
    status_table_name                                = var.uc_export_to_crown_status_table_name
    product_status_table_name                        = var.data_pipeline_metadata_name
    htme_message_delay_seconds                       = var.message_delay_seconds
    htme_manifest_retry_max_attempts                 = var.manifest_retry_max_attempts
    htme_manifest_retry_delay_ms                     = var.manifest_retry_delay_ms
    htme_manifest_retry_multiplier                   = var.manifest_retry_multiplier
    blocked_topics                                   = var.blocked_topics
    sns_topic_arn_monitoring                         = var.sns_topic_arn_monitoring_arn
    sns_topic_arn_completion_incremental             = var.sns_topic_arn_completion_incremental
    sns_topic_arn_completion_full                    = var.sns_topic_arn_completion_full
    pushgateway_hostname                             = var.htme_pushgateway_hostname
    sqs_message_group_id                             = var.sqs_messages_group_id_retries
    hbase_scanner_timeout_ms                         = var.hbase_client_scanner_timeout_ms
    hbase_rpc_timeout_ms                             = var.hbase_rpc_timeout_ms
    hbase_rpc_read_timeout_ms                        = var.hbase_rpc_read_timeout_ms
    data_egress_sqs_url                              = var.data_egress_sqs_url
    pdm_common_model_site_prefix                     = var.pdm_common_model_site_prefix
  }
}

data "template_file" "htme_fallback" {
  template = file("htme_userdata.tpl")

  vars = {
    name                                             = var.instance_name
    acm_cert_arn                                     = aws_acm_certificate.htme.arn
    private_key_alias                                = var.environment
    truststore_aliases                               = var.host_truststore_aliases
    truststore_certs                                 = var.host_truststore_certs
    internet_proxy                                   = var.internet_proxy_dns_name
    non_proxied_endpoints                            = var.non_proxied_endpoints
    s3_artefact_bucket_id                            = var.s3_artefact_bucket_id
    htme_log_level                                   = var.htme_log_level
    dks_endpoint                                     = var.dks_endpoint
    output_batch_size_max_bytes                      = var.output_batch_size_max_bytes
    directory_output                                 = var.directory_output
    s3_bucket                                        = var.s3_compaction_bucket_id
    sqs_url                                          = data.aws_sqs_queue.scheduler_sqs.url
    sqs_incoming_url                                 = data.aws_sqs_queue.corporate_storage_export_sqs.url
    s3_manifest_folder                               = var.s3_manifest_prefix
    s3_manifest_bucket                               = var.s3_manifest_bucket_id
    hbase_master_url                                 = var.hbase_master_url
    htme_max_memory_allocation                       = var.max_memory_allocation
    htme_scan_width                                  = var.scan_width
    cwa_metrics_collection_interval                  = var.cw_agent_metrics_collection_interval
    cwa_namespace                                    = var.cw_agent_namespace
    cwa_cpu_metrics_collection_interval              = var.cw_agent_cpu_metrics_collection_interval
    cwa_disk_measurement_metrics_collection_interval = var.cw_agent_disk_measurement_metrics_collection_interval
    cwa_disk_io_metrics_collection_interval          = var.cw_agent_disk_io_metrics_collection_interval
    cwa_mem_metrics_collection_interval              = var.cw_agent_mem_metrics_collection_interval
    cwa_netstat_metrics_collection_interval          = var.cw_agent_netstat_metrics_collection_interval
    cwa_log_group_name_htme                          = aws_cloudwatch_log_group.htme.name
    cwa_log_group_name_acm                           = aws_cloudwatch_log_group.acm_cert_retriever.name
    cwa_log_group_name_application                   = aws_cloudwatch_log_group.application.name
    cwa_log_group_name_boostrapping                  = aws_cloudwatch_log_group.bootstrapping.name
    cwa_log_group_name_system                        = aws_cloudwatch_log_group.system.name
    s3_scripts_bucket                                = var.s3_config_bucket_id
    s3_script_key_htme_sh                            = aws_s3_bucket_object.htme_shell_script.id
    s3_script_key_htme_wrapper_sh                    = aws_s3_bucket_object.htme_wrapper_script.id
    s3_script_key_htme_logrotate                     = aws_s3_bucket_object.htme_logrotate_script.id
    s3_script_htme_cloudwatch_sh                     = aws_s3_bucket_object.htme_cloudwatch_script.id
    s3_script_common_logging_sh                      = var.s3_script_common_logging_sh_id
    s3_script_logging_sh                             = var.s3_script_logging_sh_id
    s3_script_wrapper_checker_sh                     = aws_s3_bucket_object.wrapper_checker_script.id
    s3_script_hash_htme_sh                           = md5(data.local_file.htme_shell_script.content)
    s3_script_hash_htme_wrapper_sh                   = md5(data.local_file.htme_wrapper_script.content)
    s3_script_hash_htme_logrotate                    = md5(data.local_file.htme_logrotate_script.content)
    s3_script_hash_htme_cloudwatch_sh                = md5(data.local_file.htme_cloudwatch_script.content)
    s3_script_hash_common_logging_sh                 = var.common_logging_sh_content_hash
    s3_script_hash_logging_sh                        = var.logging_sh_content_hash
    s3_script_hash_wrapper_checker_sh                = md5(data.local_file.wrapper_checker_script.content)
    environment_name                                 = var.environment
    htme_version                                     = var.htme_version
    htme_spring_profiles                             = var.spring_profiles
    htme_s3_socket_timeout_milliseconds              = var.s3_socket_timeout_milliseconds
    htme_scan_max_result_size                        = var.scan_max_result_size
    htme_use_block_cache                             = var.use_block_cache
    htme_use_timeline_consistency                    = var.use_timeline_consistency
    asg_name                                         = var.asg_name
    environment_name                                 = var.environment
    status_table_name                                = var.uc_export_to_crown_status_table_name
    product_status_table_name                        = var.data_pipeline_metadata_name
    htme_message_delay_seconds                       = var.message_delay_seconds
    htme_manifest_retry_max_attempts                 = var.manifest_retry_max_attempts
    htme_manifest_retry_delay_ms                     = var.manifest_retry_delay_ms
    htme_manifest_retry_multiplier                   = var.manifest_retry_multiplier
    blocked_topics                                   = var.blocked_topics
    sns_topic_arn_monitoring                         = var.sns_topic_arn_monitoring_arn
    sns_topic_arn_completion_incremental             = var.sns_topic_arn_completion_incremental
    sns_topic_arn_completion_full                    = var.sns_topic_arn_completion_full
    pushgateway_hostname                             = var.htme_pushgateway_hostname
    sqs_message_group_id                             = var.sqs_messages_group_id_retries
    hbase_scanner_timeout_ms                         = var.hbase_client_scanner_timeout_ms
    hbase_rpc_timeout_ms                             = var.hbase_rpc_timeout_ms
    hbase_rpc_read_timeout_ms                        = var.hbase_rpc_read_timeout_ms
    data_egress_sqs_url                              = var.data_egress_sqs_url
    pdm_common_model_site_prefix                     = var.pdm_common_model_site_prefix
  }
}

resource "aws_acm_certificate" "htme" {
  domain_name               = "htme.${var.domain_name}"
  certificate_authority_arn = var.root_ca_arn

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.common_tags,
    {
      Name = "Hbase to Mongo Export"
    },
  )
}
