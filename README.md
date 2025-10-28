
## Highly Available Web Architecture on AWS (Reliability Pillar)

## 📌 Project Overview

This Terraform-based project provisions a fault-tolerant, production-grade web hosting stack on AWS. It includes EC2 instances behind an Auto Scaling Group and Application Load Balancer (ALB), a Multi-AZ RDS database layer, DNS failover via Route 53, and shared storage using Amazon EFS. The architecture is designed for high availability, scalability, and resilience—aligned with AWS's Reliability Pillar.

---
## 🖼️ Diagram 

![Highly-available-aws-architecture](Diagram/Aws-Highly-Available-Web-Architecture.png)

## 🎯 Key Objectives

- 🚀 Launch Compute Layer (EC2 Auto Scaling + ALB)  
- 🗄️ Deploy Database Layer (RDS Multi-AZ)  
- 🌐 Configure DNS Failover with Route 53  
- 📦 Integrate Shared Storage via Amazon EFS  
- 🧠 Set Up Remote State Management (S3 + DynamoDB)  
- ✅ Validate Infrastructure and Extend as Needed  
- 🧹 Clean Up Resources Post-Deployment  

---

## ✅ Prerequisites

- AWS CLI authenticated to your account  
- Terraform ≥ 1.3.0  
- Domain registered in Route 53  
- Hosted zone created (e.g., `example.com`)  

---

## 📁 Folder Structure

```bash
├── Diagram
│   └── Aws-Highly-Available-Web-Architecture.png
├── LICENSE
├── README.md
├── backend.tf
├── main.tf
├── modules
│   ├── alb
│   ├── asg
│   ├── efs
│   ├── iam
│   ├── nat_gateway
│   ├── rds
│   ├── route53
│   └── vpc
├── outputs.tf
├── state-bucket
│   └── main.tf
├── terraform.tfvars
└── variables.tf
```
---

## 🧱 Architecture Summary

| Layer       | Components                                                                  |
|------------|------------------------------------------------------------------------------|
| Compute     | EC2 instances in Auto Scaling Group, behind ALB                             |
| Database    | Amazon RDS (Multi-AZ, PostgreSQL/MySQL)                                     |
| Storage     | Amazon EFS mounted to EC2 instances                                         |
| Networking  | VPC with public/private subnets, NAT Gateway for outbound traffic           |
| DNS         | Route 53 hosted zone with failover routing to ALB                           |
| Monitoring  | CloudWatch metrics, ALB health checks                                       |
| State Mgmt  | S3 backend with optional DynamoDB locking                                   |

---

## 🚀 Deployment Sequence

> ⚠️ Always initialize and apply the `state-bucket` module first. It provisions the remote backend (S3) required for Terraform state management.

```bash
# Step 1: Initialize remote state backend
terraform -chdir=state-bucket init
terraform -chdir=state-bucket plan
terraform -chdir=state-bucket apply -auto-approve

# Step 2: Deploy main infrastructure
terraform init
terraform plan
terraform apply -auto-approve
```

---

## 🔥 Teardown Sequence

```bash
# Step 1: Destroy main infrastructure
terraform destroy -auto-approve

# Step 2: destroy state backend
terraform -chdir=state-bucket destroy -auto-approve
```

---

## 🧠 Project Functionality

- VPC module provisions public/private subnets  
- NAT Gateway enables outbound traffic from private EC2s  
- EC2 module launches ASG with Apache and EFS mount  
- ALB module distributes traffic and performs health checks  
- RDS module provisions Multi-AZ database  
- Route 53 module creates A record and failover routing  
- Remote state stored in S3 with optional DynamoDB locking  

---

## 🧩 Common Errors & Fixes

### ❌ Target Group Not Connected
**Cause**: EC2 instance not registered or health check failing  
**Fix**: Ensure Apache is running and responds with HTTP 200 on `/`. Check security group and target group health.

---

### ❌ Route 53 DNS Not Resolving
**Cause**: Domain nameservers don’t match hosted zone  
**Fix**:  
- Go to Route 53 → Registered Domains  
- Update nameservers to match hosted zone:
```text
ns-1572.awsdns-04.co.uk  
ns-218.awsdns-27.com  
ns-752.awsdns-30.net  
ns-1157.awsdns-16.org  
```
---

## 🧠 Notes

- Use `prevent_destroy` on hosted zone to avoid accidental deletion  
- Validate DNS with `dig`, `nslookup`, or [dnschecker.org](https://dnschecker.org)  
- Use CloudWatch alarms for ALB and EC2 health monitoring  
- If you delete the hosted zone to save cost, update your registered domain’s nameservers accordingly  

---

## 🔧 What Could Be Improved

- Add CI/CD pipeline for automated deployment  
- Implement tagging standards for cost tracking  
- Enable AWS Config for compliance monitoring  
- Add CloudWatch dashboards for visibility  




