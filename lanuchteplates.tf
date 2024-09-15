resource "aws_launch_template" "example" {
  name_prefix   = "example-launch-template"
  image_id       = "ami-0bfddf4206f1fa7b9"  # Amazon Linux 2 AMI ID (update as needed)
  instance_type  = "t2.micro"

  security_group_names = [aws_security_group.instance.name]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo amazon-linux-extras install epel -y
    sudo yum install -y httpd php
    sudo service httpd start
    sudo yum install -y stress
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    
    tags = {
      Name = "example-instance"
    }
  }
}
