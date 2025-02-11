provider "aws" {
  region = "us-west-2"  # Update with your region
}

# Create an EC2 security group
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = "vpc-052392afe48c5a6ac"  # Added VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Added missing egress rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch Template for EC2 instances
resource "aws_launch_template" "web_template" {
  name = "web-template"

  # The EC2 instance type
  instance_type = "t2.micro"

  # AMI for Apache setup (Amazon Linux 2)
  image_id = "ami-0005ee01bca55ab66"

  # Security Groups - Changed to use VPC security group IDs
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # User data to install Apache
  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Welcome to Apache on EC2!" > /var/www/html/index.html
              EOF
  )
}

# Create an Auto Scaling Group with the Launch Template
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity    = 2
  max_size           = 3
  min_size           = 1
  target_group_arns  = [aws_lb_target_group.web_target_group.arn]  # Added target group association
  vpc_zone_identifier = ["subnet-096a7c55adcfb1322"]  # Update with your subnet ID

  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }
}

# Create an Application Load Balancer
resource "aws_lb" "web_lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = ["subnet-096a7c55adcfb1322", "subnet-03cc4e1accf07603e"]
  enable_deletion_protection = false
}

# Create a Target Group for the Load Balancer
resource "aws_lb_target_group" "web_target_group" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-052392afe48c5a6ac"

  health_check {
    enabled             = true
    healthy_threshold   = 1
    interval            = 30
    timeout             = 5
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    unhealthy_threshold = 2
  }
}

# Create a listener for the Load Balancer
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"  # Changed to forward instead of fixed-response
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}

output "elb_url" {
  value = aws_lb.web_lb.dns_name
}
