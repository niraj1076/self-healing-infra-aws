
---

## 🔹 Part 1: Architecture & Failure Design

### Objective
Design failure scenarios **before** building infrastructure.

### Failure Scenarios Considered
- EC2 CPU spike
- Application unresponsiveness
- Manual stress testing

### Design Decisions
- Detection via **CloudWatch metrics**
- Event-driven recovery using **EventBridge**
- Automated remediation using **Lambda**

📌 *This step ensures reliability is designed, not added later.*

---

## 🔹 Part 2: Base Infrastructure (Terraform)

### Components Provisioned
- EC2 instance (Ubuntu 22.04 – Free Tier)
- Security Group
  - HTTP (80) → Public
  - SSH (22) → Restricted to personal IP
- IAM Role for EC2 (no access keys)
- Default VPC

### Best Practices Used
- Infrastructure as Code (IaC)
- Dynamic AMI lookup
- Least-privilege IAM policies
- Variables for reusability

---

## 🔹 Part 3: Monitoring & Health Detection

### Monitoring Configuration
- **CloudWatch Metric:** CPUUtilization
- **Alarm Threshold:** 85%
- **Evaluation Periods:** 2

### Validation
- CPU stress test performed
- Alarm successfully transitioned to `ALARM` state
- Logs verified in CloudWatch

📌 *Demonstrates understanding of real monitoring thresholds.*

---

## 🔹 Part 4: Auto-Remediation (Self-Healing Core)

### Automation Flow
- CloudWatch Alarm → EventBridge Rule
- EventBridge → Lambda Function
- Lambda → EC2 Reboot / Service Recovery

### Security
- Dedicated IAM role for Lambda
- Only required EC2 and logging permissions

### Outcome
- Automatic recovery without SSH or manual action
- Proven self-healing behavior

📌 *This is the core SRE capability of the project.*

---

## 🔹 Part 5: CI/CD for Infrastructure (GitHub Actions)

### Pipeline Capabilities
- Terraform format check
- Terraform validate
- Terraform plan
- Terraform apply

### Benefits
- Git-driven infrastructure changes
- Consistent and repeatable deployments
- No local dependency on developer machine

📌 *Demonstrates DevOps best practices for infrastructure automation.*

---

## ⏸️ Part 6: Application CI/CD (Planned)

Application deployment CI/CD is **intentionally separated** from infrastructure CI/CD to maintain clarity and modularity.

### Planned Scope
- Application deployment to EC2
- Service restart automation
- Health verification
- Integration with existing self-healing flow

---

## 🔐 Security Considerations

- No AWS access keys stored
- IAM roles used for EC2 and Lambda
- SSH access restricted to a single IP
- Least-privilege policies applied

---

## 💰 Cost Optimization

- All resources are within AWS Free Tier
- Event-driven services used (no idle costs)
- Manual cleanup supported via Terraform destroy

---

## 🧠 Skills Demonstrated

- Terraform (Infrastructure as Code)
- AWS EC2, IAM, CloudWatch
- EventBridge & Lambda automation
- GitHub Actions CI/CD
- Self-healing & reliability design
- DevOps & SRE fundamentals

---

## 🚀 Future Enhancements

- Part 6: Application CI/CD pipeline
- Multi-instance recovery logic
- Additional health metrics
- Remote Terraform state backend

---

## 📎 Conclusion

This project showcases a **real-world self-healing infrastructure pattern** where monitoring, automation, and recovery are tightly integrated using AWS-native services and Infrastructure as Code.

It reflects practical DevOps and SRE thinking rather than just service usage.

---
