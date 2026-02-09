# 🛠️ Self-Healing Infrastructure on AWS (Terraform)

This project demonstrates a **self-healing infrastructure on AWS**, built using **Terraform** and automated with **GitHub Actions**.  
The system continuously monitors EC2 health using **Amazon CloudWatch** and automatically recovers from failures using an **event-driven remediation flow with EventBridge and Lambda** — without any manual intervention.

---

## 📌 Project Status

- ✅ Part 1: Architecture & Failure Design
- ✅ Part 2: Base Infrastructure (Terraform)
- ✅ Part 3: Monitoring & Health Detection
- ✅ Part 4: Auto-Remediation (Self-Healing)
- ✅ Part 5: CI/CD for Infrastructure (GitHub Actions)
- ⏸️ Part 6: Application CI/CD (Planned – intentionally separated)

---

## 🧱 Architecture Diagram

![Self-Healing Infrastructure](./self-healing-infra-aws-architecture.png)

### Architecture Flow
1. Infrastructure is provisioned using **Terraform** via **GitHub Actions**
2. An **EC2 instance** runs inside the default VPC
3. **CloudWatch** monitors EC2 CPU utilization
4. A **CloudWatch Alarm** triggers when CPU exceeds 85%
5. The alarm sends an event to **EventBridge**
6. **EventBridge** invokes a **Lambda function**
7. **Lambda** automatically remediates the issue by rebooting the EC2 instance  
👉 Result: **Self-healing with no manual intervention**

---

## 📂 Repository Structure
```
self-healing-infra-aws/
├── terraform/
│ ├── provider.tf
│ ├── variables.tf
│ ├── ec2.tf
│ ├── security_group.tf
│ ├── iam.tf
│ ├── cloudwatch.tf
│ ├── eventbridge.tf
│ └── lambda.tf
│
├── lambda/
│ └── auto_remediation.py
│
├── .github/
│ └── workflows/
│ └── terraform-ci.yml
│
├── README.md
└── self-healing-infra-aws-architecture.png

```
---

Perfect, this makes sense now 👍
You want a **README that is command-driven**, so **any similar student can clone the repo and follow terminal commands**, and you **do NOT want conceptual Steps 4–7**.

Below is a **clean, GitHub-ready README** for **Project 1 – PART 1**, focused only on **practical commands + structure**.

You can **copy–paste this directly**.

---

# Project 1 – Self-Healing Infrastructure on AWS

## PART 1: Project Initialization & Design Setup

---

## Purpose of This Part

This part prepares the **project foundation** before any AWS infrastructure is created.

It includes:

* Project directory setup
* Git repository initialization
* Documentation structure
* Version control best practices

No AWS resources are created in this part.

---

## Prerequisites

Make sure the following are installed on your system:

* Git
* VS Code or any code editor
* GitHub account

Check versions:

```bash
git --version
```

---

## Step 1: Create Project Directory

Create a new directory for the project and move into it:

```bash
mkdir self-healing-infra-aws
cd self-healing-infra-aws
```

---

## Step 2: Initialize Git Repository

Initialize Git inside the project directory:

```bash
git init
```

Verify repository status:

```bash
git status
```

---

## Step 3: Create Base Files

Create the README file:

```bash
touch README.md
```

(Optional) Create placeholder directories for future parts:

```bash
mkdir terraform
mkdir scripts
mkdir docs
```

---

## Step 4: Open Project in VS Code

```bash
code .
```

---

## Step 5: Write Initial README Content

Open `README.md` and add a basic header:

```md
# Self-Healing Infrastructure on AWS

This project demonstrates how to design and implement a self-healing AWS infrastructure using Terraform, CloudWatch, EventBridge, Lambda, and CI/CD pipelines.
```

Save the file.

---

## Step 6: Create `.gitignore`

Create `.gitignore` file:

```bash
touch .gitignore
```

Add the following content:

```gitignore
.terraform/
*.tfstate
*.tfstate.backup
.env
```

---

## Step 7: Check Git Status

```bash
git status
```

You should see:

* README.md
* .gitignore
* directories created

---

## Step 8: First Commit

Stage all files:

```bash
git add .
```

Commit changes:

```bash
git commit -m "Project 1 Part 1: repository initialization"
```

---

## Step 9: Create GitHub Repository

On GitHub:

* Repository name: `self-healing-infra-aws`
* Visibility: Public
* Do NOT add README (already exists)

---

## Step 10: Link Local Repo to GitHub

Replace `<your-username>` with your GitHub username:

```bash
git branch -M main
git remote add origin https://github.com/<your-username>/self-healing-infra-aws.git
git push -u origin main
```

---

## Final Repository Structure (After PART 1)

```
self-healing-infra-aws/
│
├── README.md
├── .gitignore
├── terraform/
├── scripts/
└── docs/
```

---
 
