# Network Load Balancer
resource "aws_lb" "example" {
  name               = "example-nlb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = []  # Security groups are not used for NLBs
  subnets            = [
    "subnet-096a7c55adcfb1322",
    "subnet-03cc4e1accf07603e",
    "subnet-08542edff0f3274dd",
    "subnet-0df2c43b1a9de8c6b"
  ]

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "example-nlb"
  }
}

# Target Group for NLB
resource "aws_lb_target_group" "example" {
  name     = "example-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = "vpc-052392afe48c5a6ac"  # Replace with your VPC ID

  health_check {
    protocol = "TCP"
    port     = 80
  }

  tags = {
    Name = "example-tg"
  }
}

# Network Load Balancer Listener
resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn = aws_lb_target_group.example.arn
      }
    }
  }
}
