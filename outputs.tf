output "sg_id" {
    value = aws_security_group.htme.id
    description = "HTME security group ID."
}

output "asg_name" {
    value = aws_autoscaling_group.htme.name
    description = "HTME Auto-scaling group name."
}