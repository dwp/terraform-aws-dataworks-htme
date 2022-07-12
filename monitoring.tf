resource "aws_cloudwatch_log_metric_filter" "htme_records_processed" {
  name           = "htme_records_processed"
  pattern        = "{$.message = \"*Putting batch object into bucket\"}"
  log_group_name = var.cw_agent_log_group_name_htme

  metric_transformation {
    name      = "htme_records_processed"
    namespace = var.cw_agent_namespace
    value     = "$.records_in_batch"
  }
}

resource "aws_cloudwatch_log_metric_filter" "htme_collections_started" {
  name           = "htme_collections_started"
  pattern        = "{ $.message = \"Starting topic\" }"
  log_group_name = var.cw_agent_log_group_name_htme

  metric_transformation {
    name      = "htme_collections_started"
    namespace = var.cw_agent_namespace
    value     = 1
  }
}

resource "aws_cloudwatch_log_metric_filter" "htme_collections_successfully_completed" {
  name           = "htme_collections_successfully_completed"
  pattern        = "{ $.message = \"Collection status set\" && $.collection_status = \"*Exported*\" }"
  log_group_name = var.cw_agent_log_group_name_htme

  metric_transformation {
    name      = "htme_collections_successfully_completed"
    namespace = var.cw_agent_namespace
    value     = 1
  }
}

resource "aws_cloudwatch_log_metric_filter" "htme_successful_non_empty_collections" {
  name           = "htme_successful_non_empty_collections"
  pattern        = "{ $.message = \"Collection status set\" && $.collection_status = \"*Exported*\" && $.files_exported != 0 }"
  log_group_name = var.cw_agent_log_group_name_htme

  metric_transformation {
    name      = "htme_successful_non_empty_collections"
    namespace = var.cw_agent_namespace
    value     = 1
  }
}

resource "aws_cloudwatch_log_metric_filter" "htme_successful_empty_collections" {
  name           = "htme_successful_empty_collections"
  pattern        = "{ $.message = \"Collection status set\" && $.collection_status = \"*Exported*\" && $.files_exported = 0 }"
  log_group_name = var.cw_agent_log_group_name_htme

  metric_transformation {
    name      = "htme_successful_empty_collections"
    namespace = var.cw_agent_namespace
    value     = 1
  }
}

resource "aws_cloudwatch_log_metric_filter" "htme_collections_failed" {
  name           = "htme_collections_failed"
  pattern        = "{ $.message = \"Collection status set\" && $.collection_status = \"*Export_Failed*\" }"
  log_group_name = var.cw_agent_log_group_name_htme

  metric_transformation {
    name      = "htme_collections_failed"
    namespace = var.cw_agent_namespace
    value     = 1
  }
}


resource "aws_cloudwatch_log_metric_filter" "htme_collection_duration_ms" {
  name           = "htme_collection_duration_ms"
  pattern        = "{ $.message = \"Job completed\" }"
  log_group_name = var.cw_agent_log_group_name_htme

  metric_transformation {
    name      = "htme_collection_duration_ms"
    namespace = var.cw_agent_namespace
    value     = "$.duration_in_milliseconds"
  }
}

resource "aws_cloudwatch_log_metric_filter" "htme_read_failures" {
  name           = "htme_read_failures"
  pattern        = "{$.message = \"Failed to get next record after max retries\"}"
  log_group_name = var.cw_agent_log_group_name_htme

  metric_transformation {
    name      = "htme_read_failures"
    namespace = var.cw_agent_namespace
    value     = 1
  }
}

resource "aws_cloudwatch_log_metric_filter" "htme_failed_snapshots" {
  name           = "htme_snapshots_failed_to_write_to_s3"
  pattern        = "{$.message = \"Exception while writing snapshot file to s3\"}"
  log_group_name = var.cw_agent_log_group_name_htme

  metric_transformation {
    name      = "htme_snapshots_failed_to_write_to_s3"
    namespace = var.cw_agent_namespace
    value     = 1
  }
}

resource "aws_cloudwatch_log_metric_filter" "htme_rejected_hbase_records" {
  name           = "htme_rejected_hbase_records"
  pattern        = "{$.message = \"Rejecting invalid item\"}"
  log_group_name = var.cw_agent_log_group_name_htme

  metric_transformation {
    name      = "htme_rejected_hbase_records"
    namespace = var.cw_agent_namespace
    value     = 1
  }
}

resource "aws_cloudwatch_log_metric_filter" "htme_failed_manifest_writes" {
  name           = "htme_failed_manifest_writes"
  pattern        = "{$.message = \"Failed to write manifest\"}"
  log_group_name = var.cw_agent_log_group_name_htme

  metric_transformation {
    name      = "htme_failed_manifest_writes"
    namespace = var.cw_agent_namespace
    value     = 1
  }
}

resource "aws_cloudwatch_log_metric_filter" "htme_dks_retries" {
  name           = "htme_dks_retries"
  pattern        = "{$.message = \"*from data key service*\" && $.log_level = \"WARN\"}"
  log_group_name = var.cw_agent_log_group_name_htme

  metric_transformation {
    name      = "htme_dks_retries"
    namespace = var.cw_agent_namespace
    value     = 1
  }
}

resource "aws_cloudwatch_log_metric_filter" "htme_dks_errors" {
  name           = "htme_dks_errors"
  pattern        = "{$.message = \"*Non-skippable exception in recoverer while processing*\" && $.message = \"*data key service returned status code*\" && $.log_level = \"ERROR\"}"
  log_group_name = var.cw_agent_log_group_name_htme

  metric_transformation {
    name      = "htme_dks_errors"
    namespace = var.cw_agent_namespace
    value     = 1
  }
}

resource "aws_cloudwatch_log_metric_filter" "htme_requested_topics_to_export" {
  name           = "htme_requested_topics_to_export"
  pattern        = "{$.message = \"Topic list qualified\"}"
  log_group_name = var.uc_export_to_crown_controller_log_group_name

  metric_transformation {
    name      = "htme_requested_topics_to_export"
    namespace = var.cw_agent_controller_namespace
    value     = "$.number_of_topics_to_export"
  }
}

resource "aws_cloudwatch_log_metric_filter" "htme_requested_topics_to_send" {
  name           = "htme_requested_topics_to_send"
  pattern        = "{$.message = \"Topic list qualified\"}"
  log_group_name = var.cw_uc_export_to_crown_controller_log_group_name

  metric_transformation {
    name      = "htme_requested_topics_to_send"
    namespace = var.cw_agent_controller_namespace
    value     = "$.number_of_topics_to_send"
  }
}

resource "aws_cloudwatch_metric_alarm" "htme_failed_manifest_write" {
  count               = var.htme_alert_on_failed_manifest_writes == true ? 1 : 0
  alarm_name          = "HTME: Failed to write a manifest file after retries."
  comparison_operator = "LessThanThreshold"
  period              = 900
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.htme_failed_manifest_writes.name
  namespace           = var.cw_agent_namespace
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"

  alarm_actions     = [var.sns_topic_arn_monitoring_arn]
  alarm_description = "HTME has failed to write a manifest file after max retries"
  tags              = { notification_type = "Error", severity = "Medium" }
}

resource "aws_cloudwatch_metric_alarm" "htme_failed_to_start_in_24h" {
  count               = var.htme_alert_on_failed_to_start == true ? 1 : 0
  alarm_name          = "HTME: Failed to start within 24 hour period."
  comparison_operator = "LessThanThreshold"
  period              = 3600
  evaluation_periods  = 24
  metric_name         = aws_cloudwatch_log_metric_filter.htme_collections_started.name
  namespace           = var.cw_agent_namespace
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "breaching"

  alarm_actions     = [var.sns_topic_arn_monitoring_arn]
  alarm_description = "HTME hasn't ran or failed to start in 24 hours"
  tags = {
    notification_type = "Error",
    severity          = "High",
    active_days       = "Monday+Tuesday+Wednesday+Thursday+Friday+Sunday"
  }
}

resource "aws_cloudwatch_metric_alarm" "collection_duration_ms_exceeded_average" {
  count               = var.htme_alert_on_collection_duration == true ? 1 : 0
  alarm_name          = "HTME: running for longer than 12 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = 900
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  metric_name         = aws_cloudwatch_log_metric_filter.htme_collection_duration_ms.name
  namespace           = var.cw_agent_namespace
  statistic           = "Maximum"
  threshold           = 43200000
  treat_missing_data  = "notBreaching"

  alarm_actions     = [var.sns_topic_arn_monitoring_arn]
  alarm_description = "HTME has been running for longer than 12 hours"
  tags              = { notification_type = "Warning", severity = "Low" }
}

resource "aws_cloudwatch_metric_alarm" "htme_read_failures" {
  count               = var.htme_alert_on_read_failures == true ? 1 : 0
  alarm_name          = "HTME: 5 or more HBase read errors found in 30 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.htme_read_failures.name
  namespace           = var.cw_agent_namespace
  period              = 1800
  threshold           = 5
  statistic           = "Sum"

  alarm_actions     = [var.sns_topic_arn_monitoring_arn]
  alarm_description = "5 or more HBase read errors found in 30 minutes for HTME"
  tags              = { notification_type = "Warning", severity = "High" }
}

resource "aws_cloudwatch_metric_alarm" "htme_failed_snapshots" {
  count               = var.htme_alert_on_failed_snapshots == true ? 1 : 0
  alarm_name          = "HTME: 5 or more failed snapshot writes found in 30 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.htme_failed_snapshots.name
  namespace           = var.cw_agent_namespace
  period              = 900
  threshold           = 5
  statistic           = "Sum"

  alarm_actions     = [var.sns_topic_arn_monitoring_arn]
  alarm_description = "5 or more failed snapshot writes found in 30 minutes for HTME"
  tags              = { notification_type = "Warning", severity = "High" }
}

resource "aws_cloudwatch_metric_alarm" "htme_dks_errors" {
  count               = var.htme_alert_on_dks_errors == true ? 1 : 0
  alarm_name          = "HTME: DKS errors found"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.htme_dks_errors.name
  namespace           = var.cw_agent_namespace
  period              = 900
  threshold           = 1
  statistic           = "Sum"

  alarm_actions     = [var.sns_topic_arn_monitoring_arn]
  alarm_description = "DKS errors found for HTME"
  tags              = { notification_type = "Error", severity = "High" }
}

resource "aws_cloudwatch_metric_alarm" "htme_dks_retries" {
  count               = var.htme_alert_on_dks_retries == true ? 1 : 0
  alarm_name          = "HTME: 50 or more DKS errors found in 15 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.htme_dks_retries.name
  namespace           = var.cw_agent_namespace
  period              = 900
  threshold           = 50
  statistic           = "Sum"

  alarm_actions     = [var.sns_topic_arn_monitoring_arn]
  alarm_description = "50 or more DKS errors found in 15 minutes for HTME"
  tags              = { notification_type = "Warning", severity = "Low" }
}

resource "aws_cloudwatch_metric_alarm" "htme_rejected_hbase_records" {
  count               = var.htme_alert_on_rejected_records == true ? 1 : 0
  alarm_name          = "HTME: 5 or more rejected records found in 30 minutes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.htme_rejected_hbase_records.name
  namespace           = var.cw_agent_namespace
  period              = 1800
  threshold           = 5
  statistic           = "Sum"

  alarm_actions     = [var.sns_topic_arn_monitoring_arn]
  alarm_description = "5 or more rejected records found in 30 minutes for HTME"
  tags              = { notification_type = "Warning", severity = "Medium" }
}

resource "aws_cloudwatch_metric_alarm" "collections_failed" {
  count               = var.htme_alert_on_failed_collections == true ? 1 : 0
  alarm_name          = "HTME: 1 or more failed collections found in 1 hour"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.htme_collections_failed.name
  namespace           = var.cw_agent_namespace
  period              = 3600
  threshold           = 1
  statistic           = "Sum"

  alarm_actions     = [var.sns_topic_arn_monitoring_arn]
  alarm_description = "1 or more failed collections found in 1 hour for HTME"
  tags              = { notification_type = "Error", severity = "High" }
}

resource "aws_cloudwatch_metric_alarm" "htme_memory_usage" {
  count               = var.htme_alert_on_memory_usage == true ? 1 : 0
  alarm_name          = "htme_memory_usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = "90"

  alarm_actions     = [var.sns_topic_arn_monitoring_arn]
  alarm_description = "Triggers when HTME uses >90% of available memory"
  tags              = { notification_type = "Warning", severity = "Medium" }

  metric_query {
    id          = "mem_used_percent"
    expression  = "mem_used/mem_total*100"
    label       = "Memory Usage (%)"
    return_data = "true"
  }

  metric_query {
    id = "mem_used"

    metric {
      metric_name = "mem_used"
      namespace   = var.cw_agent_namespace
      period      = "60"
      stat        = "Maximum"
    }
  }

  metric_query {
    id = "mem_total"

    metric {
      metric_name = "mem_total"
      namespace   = var.cw_agent_namespace
      period      = "60"
      stat        = "Maximum"
    }
  }
}

resource "aws_cloudwatch_dashboard" "htme" {
  dashboard_name = "htme"

  dashboard_body = <<EOF
{
    "start": "-PT12H",
    "periodOverride": "auto",
    "widgets": [
        {
            "type":"metric",
            "x":0,
            "y":0,
            "width":6,
            "height":3,
            "properties":{
                "metrics":[
                    [
                        "/app/htme",
                        "htme_collections_started",
                        {
                            "label":"Collections started (24h)"
                        }
                    ]
                ],
                "view":"singleValue",
                "region":"eu-west-2",
                "stat":"Sum",
                "period":57600,
                "title":"Collections Started"
            }
        },
        {
            "type":"metric",
            "x":6,
            "y":0,
            "width":6,
            "height":3,
            "properties":{
                "metrics":[
                    [
                        "/app/lambda/uc_export_to_crown_controller",
                        "htme_requested_topics_to_export",
                        {
                            "label":"Collections requested (24h)"
                        }
                    ]
                ],
                "view":"singleValue",
                "region":"eu-west-2",
                "stat":"Sum",
                "period":57600,
                "title":"Collections Requested"
            }
        },
        {
            "type":"metric",
            "x":12,
            "y":0,
            "width":6,
            "height":3,
            "properties":{
                "metrics":[
                    [
                        "/app/htme",
                        "htme_collections_successfully_completed",
                        {
                            "label":"Collections successfully completed (24h)"
                        }
                    ]
                ],
                "view":"singleValue",
                "region":"eu-west-2",
                "stat":"Sum",
                "period":57600,
                "title":"Collections Successful"
            }
        },
        {
            "type":"metric",
            "x":18,
            "y":0,
            "width":6,
            "height":3,
            "properties":{
                "metrics":[
                    [
                        "/app/htme",
                        "htme_collections_failed",
                        {
                            "label":"Collections failed (24h)"
                        }
                    ]
                ],
                "view":"singleValue",
                "region":"eu-west-2",
                "stat":"Sum",
                "period":57600,
                "title":"Collections Failed"
            }
        },
        {
            "type":"metric",
            "x":0,
            "y":3,
            "width":8,
            "height":3,
            "properties":{
                "metrics":[
                    [
                        "/app/htme",
                        "htme_successful_non_empty_collections",
                        {
                            "label":"Successful collections with files to send (24h)"
                        }
                    ]
                ],
                "view":"singleValue",
                "region":"eu-west-2",
                "stat":"Sum",
                "period":57600,
                "title":"Successful Collections With Files"
            }
        },
        {
            "type":"metric",
            "x":8,
            "y":3,
            "width":8,
            "height":3,
            "properties":{
                "metrics":[
                    [
                        "/app/htme",
                        "htme_successful_empty_collections",
                        {
                            "label":"Successful collections with no files to send (24h)"
                        }
                    ]
                ],
                "view":"singleValue",
                "region":"eu-west-2",
                "stat":"Sum",
                "period":57600,
                "title":"Successful Empty Collections"
            }
        },
        {
            "type":"metric",
            "x":16,
            "y":3,
            "width":8,
            "height":3,
            "properties":{
                "metrics":[
                    [
                        "/app/htme",
                        "htme_collection_duration_ms",
                        {
                            "label":"Collection average duration (24h)"
                        }
                    ]
                ],
                "view":"singleValue",
                "region":"eu-west-2",
                "stat":"Average",
                "period":57600,
                "title":"Average Duration"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 6,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "/app/htme", "htme_collections_started" ],
                    [ "/app/htme", "htme_successful_non_empty_collections" ],
                    [ "/app/htme", "htme_successful_empty_collections" ],
                    [ "/app/htme", "htme_collections_failed" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "eu-west-2",
                "stat": "Sum",
                "period": 900,
                "liveData": true,
                "title": "Collections Processed",
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                }
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 6,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "/app/htme", "htme_read_failures" ],
                    [ "/app/htme", "htme_failed_snapshots" ],
                    [ "/app/htme", "htme_rejected_hbase_records" ],
                    [ "/app/htme", "htme_dks_errors" ]
                ],
                "view": "bar",
                "stacked": false,
                "region": "eu-west-2",
                "stat": "Sum",
                "period": 900,
                "liveData": true,
                "title": "Errors",
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                }
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 12,
            "width": 9,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "expression": "m1/m2*100", "label": "mem_used_percent", "id": "e1", "region": "eu-west-2" } ],
                    [ "/app/htme", "mem_used", { "id": "m1", "visible": false } ],
                    [ ".", "mem_total", { "id": "m2", "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "eu-west-2",
                "stat": "Maximum",
                "period": 900,
                "title": "Memory Utilisation",
                "yAxis": {
                    "left": {
                        "showUnits": false,
                        "label": "%"
                    }
                }
            }
        },
        {
            "type": "metric",
            "x": 9,
            "y": 12,
            "width": 9,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "expression": "100-m1", "label": "cpu_usage", "id": "e1", "stat": "Maximum", "region": "eu-west-2" } ],
                    [ "/app/htme", "CPU_USAGE_IDLE", { "id": "m1", "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "eu-west-2",
                "stat": "Maximum",
                "period": 900,
                "yAxis": {
                    "left": {
                        "label": "%",
                        "showUnits": false
                    },
                    "right": {
                        "showUnits": false
                    }
                },
                "title": "CPU Utilisation"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 12,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "/app/htme", "net_bytes_recv" ],
                    [ ".", "net_bytes_sent" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "eu-west-2",
                "stat": "Average",
                "period": 900,
                "title": "Network Utilisation"
            }
        },
        {
            "type": "log",
            "x": 0,
            "y": 18,
            "width": 24,
            "height": 6,
            "properties": {
                "query": "SOURCE '/app/htme' | filter message = \"Starting topic\" or message = \"Completed topic\" and @message like /full/\n | fields successful_count, topic_name |\n stats count(successful_count) as topics_finished_count, count(successful_count) / 136 * 100 as percentage_complete,\n (latest(@timestamp) - earliest(@timestamp)) / 1000 / 60 / 60 as duration_hours, ((100 / (count(successful_count) / 136 * 100)* ((latest(@timestamp) - earliest(@timestamp)) / 1000 / 60 / 60))) as predicted_duration,\n fromMillis(earliest(@timestamp)) as start_time, fromMillis(earliest(@timestamp) + ((100 / (count(successful_count) / 136 * 100)* ((latest(@timestamp) - earliest(@timestamp)))))) as predicted_finish_time, sum(successful_count) as successful_topics, min(successful_count) as successful_count_min, stddev(successful_count) as successful_count_deviation",
                "region": "eu-west-2",
                "stacked": false,
                "view": "table",
                "title": "Full snapshot run progress"
            }
        },
        {
            "type": "log",
            "x": 0,
            "y": 24,
            "width": 24,
            "height": 6,
            "properties": {
                "query": "SOURCE '/app/htme' | filter message = \"Starting topic\" or message = \"Completed topic\" and @message like /incremental/\n | fields successful_count, topic_name |\n stats count(successful_count) as topics_finished_count, count(successful_count) / 136 * 100 as percentage_complete,\n (latest(@timestamp) - earliest(@timestamp)) / 1000 / 60 / 60 as duration_hours, ((100 / (count(successful_count) / 136 * 100)* ((latest(@timestamp) - earliest(@timestamp)) / 1000 / 60 / 60))) as predicted_duration,\n fromMillis(earliest(@timestamp)) as start_time, fromMillis(earliest(@timestamp) + ((100 / (count(successful_count) / 136 * 100)* ((latest(@timestamp) - earliest(@timestamp)))))) as predicted_finish_time, sum(successful_count) as successful_topics, min(successful_count) as successful_count_min, stddev(successful_count) as successful_count_deviation",
                "region": "eu-west-2",
                "stacked": false,
                "view": "table",
                "title": "Incremental snapshot run progress"
            }
        }
    ]
}
EOF

}
