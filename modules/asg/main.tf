data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

module "iam" {
  source = "../../modules/iam"  # Adjust path if needed
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow HTTP from ALB and NFS from EFS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  
  }

  tags = {
    Name = "ec2-sg"
  }
}

resource "aws_launch_template" "lt" {
  name_prefix   = "medical-app-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = module.iam.instance_profile_name
  }
user_data = base64encode(<<-EOF
  #!/bin/bash
  exec > /var/log/user-data.log 2>&1
  set -x

  yum update -y
  yum install -y httpd amazon-efs-utils nfs-utils

  systemctl enable httpd
  systemctl start httpd
  echo "<h1>Medical Application</h1>" > /var/www/html/index.html

  mkdir -p /mnt/efs
  for i in {1..5}; do
    sudo mount -t nfs4 ${var.efs_dns_name}:/ /mnt/efs 
    echo "Mount attempt $i failed, retrying in 5s..." >> /var/log/user-data.log
    sleep 5
  done
  
EOF
)

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity          = 2
  max_size                  = 3
  min_size                  = 1
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns         = [var.alb_target_group_arn]
  health_check_type         = "EC2"
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "medical-app-ec2"
    propagate_at_launch = true
  }
}
