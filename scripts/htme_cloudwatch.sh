#!/bin/bash

set -Eeuo pipefail

cwa_metrics_collection_interval="$1"
cwa_namespace="$2"
cwa_cpu_metrics_collection_interval="$3"
cwa_disk_measurement_metrics_collection_interval="$4"
cwa_disk_io_metrics_collection_interval="$5"
cwa_mem_metrics_collection_interval="$6"
cwa_netstat_metrics_collection_interval="$7"
cwa_log_group_name_htme="${8}"
cwa_log_group_name_acm="${9}"
cwa_log_group_name_application="${10}"
cwa_log_group_name_boostrapping="${11}"
cwa_log_group_name_system="${12}"

export AWS_DEFAULT_REGION="${13}"

# Create config file required for CloudWatch Agent
mkdir -p /opt/aws/amazon-cloudwatch-agent/etc
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<CWAGENTCONFIG
{
  "agent": {
    "metrics_collection_interval": ${cwa_metrics_collection_interval},
    "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
  },
  "metrics": {
    "namespace" : "${cwa_namespace}",
    "metrics_collected": {
      "cpu": {
        "resources": [
          "*"
        ],
        "measurement": [
          {"name": "cpu_usage_idle", "rename": "CPU_USAGE_IDLE", "unit": "Percent"},
          {"name": "cpu_usage_nice", "unit": "Percent"},
          "cpu_usage_guest"
        ],
        "totalcpu": false,
        "metrics_collection_interval": ${cwa_cpu_metrics_collection_interval}
      },
      "disk": {
        "resources": [
          "/",
          "/tmp"
        ],
        "measurement": [
          {"name": "free", "rename": "DISK_FREE", "unit": "Gigabytes"},
          "total",
          "used"
        ],
          "ignore_file_system_types": [
          "sysfs", "devtmpfs"
        ],
        "metrics_collection_interval": ${cwa_disk_measurement_metrics_collection_interval}
      },
      "diskio": {
        "resources": [
          "*"
        ],
        "measurement": [
          "reads",
          "writes",
          "read_time",
          "write_time",
          "io_time"
        ],
        "metrics_collection_interval": ${cwa_disk_io_metrics_collection_interval}
      },
      "swap": {
        "measurement": [
          "swap_used",
          "swap_free",
          "swap_used_percent"
        ]
      },
      "mem": {
        "measurement": [
          "mem_used",
          "mem_cached",
          "mem_total"
        ],
        "metrics_collection_interval": ${cwa_mem_metrics_collection_interval}
      },
      "net": {
        "resources": [
          "eth0"
        ],
        "measurement": [
          "bytes_sent",
          "bytes_recv",
          "drop_in",
          "drop_out"
        ]
      },
      "netstat": {
        "measurement": [
          "tcp_established",
          "tcp_syn_sent",
          "tcp_close"
        ],
        "metrics_collection_interval": ${cwa_netstat_metrics_collection_interval}
      },
      "processes": {
        "measurement": [
          "running",
          "sleeping",
          "dead"
        ]
      }
    },
    "append_dimensions": {
      "ImageId": "\${aws:ImageId}",
      "InstanceId": "\${aws:InstanceId}",
      "InstanceType": "\${aws:InstanceType}",
      "AutoScalingGroupName": "\${aws:AutoScalingGroupName}"
    },
    "aggregation_dimensions" : [["ImageId"], ["InstanceId", "InstanceType"], ["d1"],[]],
    "force_flush_interval" : 15
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log",
            "log_group_name": "${cwa_log_group_name_system}",
            "log_stream_name": "{instance_id}-amazon-cloudwatch-agent.log",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/htme/htme.log",
            "log_group_name": "${cwa_log_group_name_htme}",
            "log_stream_name": "{instance_id}-htme.log",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/messages",
            "log_group_name": "${cwa_log_group_name_system}",
            "log_stream_name": "{instance_id}-messages",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/secure",
            "log_group_name": "${cwa_log_group_name_system}",
            "log_stream_name": "{instance_id}-secure",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/cloud-init-output.log",
            "log_group_name": "${cwa_log_group_name_boostrapping}",
            "log_stream_name": "{instance_id}-cloud-init-output.log",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/htme/nohup.log",
            "log_group_name": "${cwa_log_group_name_application}",
            "log_stream_name": "{instance_id}-nohup.log",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/acm-cert-retriever.log",
            "log_group_name": "${cwa_log_group_name_acm}",
            "log_stream_name": "{instance_id}-acm-cert-retriever.log",
            "timezone": "UTC"
          }
        ]
      }
    },
    "log_stream_name": "${cwa_namespace}",
    "force_flush_interval" : 15
  }
}
CWAGENTCONFIG

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
systemctl start amazon-cloudwatch-agent

