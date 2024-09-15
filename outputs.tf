output "nlb_dns_name" {
  value = aws_lb.example.dns_name
}

output "asg_name" {
  value = aws_autoscaling_group.example.name
}
