resource "aws_security_group" "instance" {
  name        = "example-instance-sg"
  description = "Allow inbound HTTP traffic"
  vpc_id      = "vpc-052392afe48c5a6ac"  # Replace with your VPC ID

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-instance-sg"
  }
}
