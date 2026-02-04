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
                set -e

                # Update system
                apt update -y

                # Install nginx
                apt install -y nginx

                # Enable & start nginx
                systemctl start nginx
                systemctl enable nginx

                # Create app directory
                mkdir -p /var/www/html
                echo "Self-Healing Infrastructure - EC2 Running" > /var/www/html/index.html

                # Create scripts directory
                mkdir -p /home/ubuntu/scripts

                # Deploy script
                cat << 'EOT' > /home/ubuntu/scripts/deploy.sh
                #!/bin/bash
                rsync -av --delete /home/ubuntu/app/ /var/www/html/
                EOT

                # Restart script
                cat << 'EOT' > /home/ubuntu/scripts/restart.sh
                #!/bin/bash
                systemctl restart nginx
                EOT

                # Health check script
                cat << 'EOT' > /home/ubuntu/scripts/health.sh
                #!/bin/bash
                STATUS=$(curl -s -o /dev/null -w "%%{http_code}" http://localhost)
                if [ "$STATUS" -ne 200 ]; then
                  exit 1
                fi
                EOT

                # Bootstrap script (runs on reboot)
                cat << 'EOT' > /home/ubuntu/scripts/bootstrap.sh
                #!/bin/bash
                /home/ubuntu/scripts/restart.sh
                /home/ubuntu/scripts/health.sh
                EOT

                # Permissions
                chown -R ubuntu:ubuntu /home/ubuntu/scripts
                chmod +x /home/ubuntu/scripts/*.sh

                # Cron job for reboot
                (crontab -l 2>/dev/null; echo "@reboot /home/ubuntu/scripts/bootstrap.sh") | crontab -
                EOF


  tags = {
    Name = "self-healing-web-ec2"
  }
}