---


# 🛠️ Self-Healing Infrastructure on AWS (Terraform)

This project demonstrates a **self-healing infrastructure on AWS**, built using **Terraform** and automated with **GitHub Actions**.

The system continuously monitors EC2 health using **Amazon CloudWatch** and automatically recovers from failures using an **event-driven remediation flow with EventBridge and Lambda**, without any manual intervention.

---

## 📌 Project Status

- Completed: Architecture & Failure Design  
- Completed: Base Infrastructure (Terraform)  
- Completed: Monitoring & Health Detection  
- Completed: Auto-Remediation (Self-Healing)  
- Completed: CI/CD for Infrastructure (GitHub Actions)  
- Planned: Application CI/CD (intentionally separated)

---

## 🧱 Architecture Diagram

![Self-Healing Infrastructure](./self-healing-infra-aws-architecture.png)

### Architecture Flow

- Infrastructure is provisioned using Terraform
- Terraform execution is automated using GitHub Actions
- An EC2 instance runs inside the default VPC
- CloudWatch monitors EC2 CPU utilization
- A CloudWatch Alarm triggers when CPU crosses the threshold
- Alarm state changes are sent to EventBridge
- EventBridge invokes a Lambda function
- Lambda automatically remediates the issue by rebooting the EC2 instance

Result: **Automatic recovery with no manual intervention**

---

## 📂 Repository Structure

```

self-healing-infra-aws/
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── vpc.tf
│   ├── sg.tf
│   ├── iam.tf
│   ├── ec2.tf
│   ├── cloudwatch.tf
│   ├── eventbridge.tf
│   ├── lambda.tf
│   └── outputs.tf
│
├── lambda/
│   └── auto_remediation.py
│
├── .github/
│   └── workflows/
│       └── terraform-ci.yml
│
├── README.md
├── .gitignore
└── self-healing-infra-aws-architecture.png

```

---

# PART 1: Project Initialization & Design Setup

## Purpose

Prepare the project foundation before provisioning any AWS resources.

This part focuses on:
- Repository setup
- Directory structure
- Version control
- Documentation baseline

No AWS resources are created in this part.

---

## Local Requirements

- Git
- VS Code or any code editor
- GitHub account

Verify Git installation:

```bash
git --version
````

---

## Project Initialization

```bash
mkdir self-healing-infra-aws
cd self-healing-infra-aws
git init
```

Create base files and directories:

```bash
touch README.md
mkdir terraform docs scripts
```

Open the project in VS Code:

```bash
code .
```

---

## Git Ignore Configuration

Create `.gitignore`:

```bash
touch .gitignore
```

Add the following:

```gitignore
.terraform/
*.tfstate
*.tfstate.backup
terraform.tfvars
.env
```

---

## Initial Commit and GitHub Setup

```bash
git add .
git commit -m "PART 1: project initialization and repository setup"
```

Create a **public GitHub repository** named:

```
self-healing-infra-aws
```

Link local repository to GitHub:

```bash
git branch -M main
git remote add origin https://github.com/<your-username>/self-healing-infra-aws.git
git push -u origin main
```

---

# PART 2: Base Infrastructure (Terraform)

## Purpose

Provision the core AWS infrastructure required for monitoring and self-healing.

Resources created:

* Default VPC reference
* Public subnets (AZ filtered)
* Security group
* IAM role and instance profile
* EC2 instance
* Terraform outputs

---

## Required Tools

* AWS CLI (configured)
* Terraform v1.3+
* Git
* VS Code
* OS: Windows (PowerShell / VS Code terminal)

---

## Terraform Working Directory

```bash
cd terraform
```

---

## Provider Configuration

Create `provider.tf`:

```hcl
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
```

---

## Variables

Create `variables.tf`:

```hcl
variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "my_ip" {
  description = "Public IP in CIDR format for SSH access"
  type        = string
}
```

---

## VPC and Subnet Lookup

Create `vpc.tf`:

```hcl
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public_azs" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["ap-south-1a", "ap-south-1b"]
  }
}
```

---

## Security Group

Create `sg.tf`:

```hcl
resource "aws_security_group" "web_sg" {
  name   = "self-healing-web-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

---

## IAM Role and Instance Profile

Create `iam.tf`:

```hcl
resource "aws_iam_role" "ec2_role" {
  name = "self-healing-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  role = aws_iam_role.ec2_role.name
}
```

---

## EC2 Instance

Create `ec2.tf`:

```hcl
resource "aws_instance" "web" {
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnets.public_azs.ids[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2
    systemctl enable apache2
    systemctl start apache2
  EOF

  tags = {
    Name = "self-healing-web-ec2"
  }
}
```

---

## Local Variables File

Create `terraform.tfvars` (do not commit):

```hcl
my_ip = "YOUR_PUBLIC_IP/32"
```

---

## Terraform Execution

```bash
terraform init
terraform validate
terraform plan
terraform apply --auto-approve
```

---

## Git Commit for PART 2

```bash
git add .
git commit -m "PART 2: base infrastructure using Terraform"
git push origin main
```

---

## Project Highlights

* Infrastructure as Code using Terraform
* Event-driven self-healing design
* Automated failure detection and recovery
* CI/CD for infrastructure
* Production-style repository structure


