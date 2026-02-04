data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical (Ubuntu official)
}


resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnets.public_azs.ids[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name


  key_name = "ubuntu"   # 👈 ADD THIS LINE


 user_data = <<-EOF
              #!/bin/bash
              set -euxo pipefail

              exec > /var/log/user-data.log 2>&1

              echo "User data started"

              # Update & install packages
              apt update -y
              apt install -y nginx git curl rsync

              # Enable & start nginx
              systemctl enable nginx
              systemctl start nginx

              # Clone GitHub repo
              cd /home/ubuntu
              git clone https://github.com/niraj1076/self-healing-infra-aws.git

              # Create scripts directory
              mkdir -p /home/ubuntu/scripts

              # Copy scripts from repo to runtime location
              cp self-healing-infra-aws/server/*.sh /home/ubuntu/scripts/

              # Permissions
              chmod +x /home/ubuntu/scripts/*.sh
              chown -R ubuntu:ubuntu /home/ubuntu/scripts

              # Bootstrap on reboot (root cron)
              echo "@reboot bash /home/ubuntu/scripts/bootstrap.sh >> /var/log/bootstrap.log 2>&1" | crontab -

              # Default page (optional)
              echo "Self-Healing Infrastructure - EC2 Running (GitOps)" > /var/www/html/index.html

              echo "User data completed"
              EOF



  tags = {
    Name = "self-healing-web-ec2"
  }
}