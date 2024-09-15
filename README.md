# Terraform AWS Infrastructure Setup 🚀

This project sets up an AWS infrastructure using Terraform. The infrastructure includes a Network Load Balancer (NLB), a Target Group, an Auto Scaling Group (ASG), and a Launch Template. The configuration is designed to deploy and manage instances behind an NLB with automatic scaling based on demand.

## Project Components 🛠️

### 1. Network Load Balancer (NLB) 🌐

- **Resource**: `aws_lb`
- **Description**: Creates a Network Load Balancer to distribute incoming traffic across multiple targets.
- **Configuration**:
  - Type: Network Load Balancer
  - Subnets: Four specified subnets
  - Tags: `Name` set to "example-nlb"

### 2. Target Group 🎯

- **Resource**: `aws_lb_target_group`
- **Description**: Defines a target group for the NLB to forward traffic to.
- **Configuration**:
  - Protocol: TCP
  - Port: 80
  - VPC: The specified VPC ID
  - Health Check: TCP on port 80
  - Tags: `Name` set to "example-tg"

### 3. Network Load Balancer Listener 🎧

- **Resource**: `aws_lb_listener`
- **Description**: Configures a listener for the NLB to forward traffic to the target group.
- **Configuration**:
  - Port: 80
  - Protocol: TCP
  - Default Action: Forward traffic to the specified target group

### 4. Launch Template 📝

- **Resource**: `aws_launch_template`
- **Description**: Creates a launch template for instances in the Auto Scaling Group.
- **Configuration**:
  - Image ID: Amazon Linux 2 AMI
  - Instance Type: `t2.micro`
  - User Data: Script to install Apache, PHP, and stress utilities
  - Tags: `Name` set to "example-instance"

### 5. Auto Scaling Group (ASG) 📈

- **Resource**: `aws_autoscaling_group`
- **Description**: Manages a group of EC2 instances with auto-scaling based on defined policies.
- **Configuration**:
  - Launch Template: References the launch template created
  - Minimum Size: 1 instance
  - Maximum Size: 3 instances
  - Desired Capacity: 2 instances
  - VPC Subnets: Four specified subnets
  - Tags: `Name` set to "example-asg-instance"
  - Health Check Type: EC2
  - Health Check Grace Period: 300 seconds

### 6. Auto Scaling Policies 📉📈

- **Resource**: `aws_autoscaling_policy`
- **Description**: Defines policies for scaling up and scaling down the ASG.
- **Configuration**:
  - `scale_up`: Increases capacity by 1 instance
  - `scale_down`: Decreases capacity by 1 instance
  - Cooldown: 60 seconds

## Getting Started 🏗️

### Prerequisites

- Terraform installed on your local machine.
- AWS CLI configured with appropriate access.

### Screenshots:


![BeFunky-collage (4)](https://github.com/user-attachments/assets/7abb9b96-947e-42da-baa9-7ba9935d2e0e)


![nlb1](https://github.com/user-attachments/assets/0f2d272e-bbdf-4d90-89da-507b433b24d1)


