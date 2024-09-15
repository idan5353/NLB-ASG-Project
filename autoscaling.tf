resource "aws_autoscaling_group" "example" {
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  min_size          = 1
  max_size          = 3
  desired_capacity  = 2

  vpc_zone_identifier = [
    "subnet-096a7c55adcfb1322",
    "subnet-03cc4e1accf07603e",
    "subnet-08542edff0f3274dd",
    "subnet-0df2c43b1a9de8c6b"
  ]

  tag {
    key                 = "Name"
    value               = "example-asg-instance"
    propagate_at_launch = true
  }

  health_check_type          = "EC2"
  health_check_grace_period = 300

  # Associate target group
  target_group_arns = [aws_lb_target_group.example.arn]

  lifecycle {
    ignore_changes = [
      desired_capacity,
      max_size,
      min_size
    ]
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.example.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.example.name
}
